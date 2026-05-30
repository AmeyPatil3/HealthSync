// Handle Tab Switching dynamically across dashboards
document.addEventListener('DOMContentLoaded', () => {
    const tabButtons = document.querySelectorAll('.tab-button');
    const tabContents = document.querySelectorAll('.tab-content');

    tabButtons.forEach(button => {
        button.addEventListener('click', () => {
            tabButtons.forEach(btn => btn.classList.remove('active'));
            tabContents.forEach(content => content.classList.remove('active'));
            
            button.classList.add('active');
            const targetTabId = button.getAttribute('data-tab');
            const targetContent = document.getElementById(targetTabId);
            if (targetContent) {
                targetContent.classList.add('active');
            }
            
            // Trigger Leaflet Map Initialization if Emergency Locator is selected
            if (targetTabId === 'emergency-locator') {
                initEmergencyLocator();
            }
        });
    });

    // Allergy live search filtering by severity
    const searchAllergiesInput = document.getElementById('searchAllergies');
    if (searchAllergiesInput) {
        searchAllergiesInput.addEventListener('input', function() {
            const searchTerm = this.value.toLowerCase().trim();
            const allergyCards = document.querySelectorAll('#allergy-container .card-allergy');

            allergyCards.forEach(card => {
                const severity = card.getAttribute('data-severity') || '';
                if (severity.toLowerCase().includes(searchTerm) || searchTerm === '') {
                    card.style.display = 'block';
                } else {
                    card.style.display = 'none';
                }
            });
        });
    }
});

// Expand/Collapse Edit Profile Form (dash.jsp)
function toggleEditProfile() {
    const formContainer = document.getElementById('edit-profile-form-container');
    if (formContainer) {
        const isHidden = formContainer.style.display === 'none';
        formContainer.style.display = isHidden ? 'block' : 'none';
        if (isHidden) {
            formContainer.scrollIntoView({ behavior: 'smooth' });
        }
    }
}

// Lightbox Modal for medical document image attachments
function viewDocumentModal(dataUri, type) {
    const modal = document.getElementById('document-modal');
    const img = document.getElementById('modal-image');
    const pdf = document.getElementById('modal-pdf');
    if (!modal) return;
    
    // Hide both initially
    if (img) img.style.display = 'none';
    if (pdf) pdf.style.display = 'none';
    
    if (type === 'image' && img) {
        img.src = dataUri;
        img.style.display = 'block';
    } else if (type === 'pdf' && pdf) {
        pdf.src = dataUri;
        pdf.style.display = 'block';
    }
    
    modal.style.display = 'flex';
}

function closeDocumentModal() {
    const modal = document.getElementById('document-modal');
    const img = document.getElementById('modal-image');
    const pdf = document.getElementById('modal-pdf');
    if (modal) {
        modal.style.display = 'none';
    }
    if (img) {
        img.style.display = 'none';
        img.src = '';
    }
    if (pdf) {
        pdf.style.display = 'none';
        pdf.src = '';
    }
}

// Trigger standard print layout for Emergency ID Card
function printMedicalIDCard() {
    window.print();
}

/* ==========================================
   GEOLOCATION EMERGENCY HOSPITALS LOCATOR LOGIC
   ========================================== */

let mapInstance = null;

function initEmergencyLocator() {
    // Prevent double map initialization (Leaflet strict single-bound container rule)
    if (mapInstance) {
        setTimeout(() => {
            mapInstance.invalidateSize(); // Force tiles layout refresh when tab loads
        }, 100);
        return;
    }

    const mapContainer = document.getElementById('emerg-map');
    if (!mapContainer) return;

    // Initialize Leaflet Map centered on default coordinates (Mumbai context [19.0760, 72.8777])
    mapInstance = L.map('emerg-map').setView([19.0760, 72.8777], 13);

    // Bind standard OpenStreetMap tiles
    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        maxZoom: 19,
        attribution: '© OpenStreetMap Contributors'
    }).addTo(mapInstance);

    // Retrieve Browser Geolocation Satellite Data
    if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(
            (position) => {
                const lat = position.coords.latitude;
                const lon = position.coords.longitude;

                // Center Map on current GPS coordinate
                mapInstance.setView([lat, lon], 14);

                // Add customized pulsing "You Are Here" Marker pin
                const userIcon = L.divIcon({
                    className: 'user-pulse-marker-container',
                    html: '<div class="user-pulse-dot"></div><div class="user-pulse-glow"></div>',
                    iconSize: [20, 20],
                    iconAnchor: [10, 10]
                });

                L.marker([lat, lon], { icon: userIcon }).addTo(mapInstance).bindPopup("<b>Your Current Location</b>").openPopup();

                // Fetch real nearby medical care facilities from OpenStreetMap database
                fetchNearbyHospitals(lat, lon);
            },
            (error) => {
                console.error("GPS Geolocation Error:", error);
                let failMsg = "GPS satellite access rejected. Please check browser permissions.";
                if (error.code === error.TIMEOUT) failMsg = "GPS coordinate query timed out.";
                handleLocationFailure(failMsg);
            },
            { enableHighAccuracy: true, timeout: 8000 }
        );
    } else {
        handleLocationFailure("Geolocation is not supported by your browser software.");
    }
}

// Query free OpenStreetMap database via Overpass API for hospitals within 5km
function fetchNearbyHospitals(lat, lon) {
    const listPanel = document.getElementById('facilities-list');
    if (!listPanel) return;

    // Overpass API Query: find nodes tagged [amenity=hospital] or [amenity=clinic] within 5000 meters of lat,lon
    const overpassUrl = `https://overpass-api.de/api/interpreter?data=[out:json];node(around:5000,${lat},${lon})[amenity~"hospital|clinic"];out;`;

    fetch(overpassUrl)
        .then(response => {
            if (!response.ok) throw new Error("Overpass API Server Rejection");
            return response.json();
        })
        .then(data => {
            listPanel.innerHTML = ""; // Clear locating loading animation
            const nodes = data.elements || [];

            if (nodes.length === 0) {
                listPanel.innerHTML = `
                    <div class="empty-locator-state animate-fade-in">
                        <i class="fas fa-search-location"></i>
                        <p>No medical facilities detected within a 5.0 km radius.</p>
                    </div>`;
                appendNationalHelplines(listPanel);
                return;
            }

            // Map and calculate actual geodesic distance in km for each facility
            const facilities = nodes.map(node => {
                const distance = calculateGeodesicDistance(lat, lon, node.lat, node.lon);
                return { ...node, distance };
            }).sort((a, b) => a.distance - b.distance); // Sort by closest distance first

            // Render closest facilities on both the map and list panel
            facilities.forEach((fac) => {
                const name = fac.tags.name || fac.tags.brand || fac.tags["name:en"] || "Emergency Clinic";
                const type = fac.tags.amenity === "hospital" ? "Hospital" : "Clinic";
                const phone = fac.tags.phone || fac.tags["contact:phone"] || "108";
                const address = fac.tags["addr:street"] || fac.tags["addr:full"] || fac.tags["addr:suburb"] || "Nearby Street";
                
                // Add custom medical cross pin on Leaflet Map
                const markerColor = fac.tags.amenity === "hospital" ? "#ef4444" : "#f59e0b";
                const facIcon = L.divIcon({
                    className: 'facility-marker-container',
                    html: `<div class="fac-marker-pin" style="background-color: ${markerColor}"><i class="fas fa-plus"></i></div>`,
                    iconSize: [24, 24],
                    iconAnchor: [12, 12]
                });

                L.marker([fac.lat, fac.lon], { icon: facIcon })
                    .addTo(mapInstance)
                    .bindPopup(`<b>${name}</b><br>${type}<br><a href="https://www.google.com/maps/dir/?api=1&destination=${fac.lat},${fac.lon}" target="_blank" style="color: #0d9488; font-weight: bold; text-decoration: none;">Get Directions</a>`);

                // Create facility description card HTML
                const card = document.createElement('div');
                card.className = 'facility-card animate-fade-in';
                card.innerHTML = `
                    <div class="fac-card-header">
                        <span class="fac-badge ${fac.tags.amenity === 'hospital' ? 'badge-hosp' : 'badge-clinic'}">
                            <i class="fas ${fac.tags.amenity === 'hospital' ? 'fa-hospital' : 'fa-clinic-medical'}"></i> ${type}
                        </span>
                        <span class="fac-dist"><i class="fas fa-route text-teal"></i> ${fac.distance.toFixed(2)} km</span>
                    </div>
                    <h4>${name}</h4>
                    <p class="fac-addr"><i class="fas fa-map-marker-alt"></i> ${address}</p>
                    <div class="fac-card-actions">
                        <a href="tel:${phone.replace(/[\s-]/g, '')}" class="btn-fac-call"><i class="fas fa-phone-alt"></i> Call Center</a>
                        <a href="https://www.google.com/maps/dir/?api=1&destination=${fac.lat},${fac.lon}" target="_blank" class="btn-fac-nav"><i class="fas fa-directions"></i> Navigate</a>
                    </div>
                `;
                listPanel.appendChild(card);
            });
        })
        .catch(err => {
            console.error("Overpass query execution failed:", err);
            handleLocationFailure("Unable to parse live database. Displaying emergency helplines.");
        });
}

// Geodesic distance calculator (Haversine Formula) in Kilometers
function calculateGeodesicDistance(lat1, lon1, lat2, lon2) {
    const R = 6371; // Earth's mean radius in Kilometers
    const dLat = (lat2 - lat1) * Math.PI / 180;
    const dLon = (lon2 - lon1) * Math.PI / 180;
    const a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
              Math.cos(lat1 * Math.PI / 180) * Math.cos(lat2 * Math.PI / 180) *
              Math.sin(dLon / 2) * Math.sin(dLon / 2);
    const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    return R * c;
}

// Fail-safe Geolocation rejection banner
function handleLocationFailure(message) {
    const listPanel = document.getElementById('facilities-list');
    if (!listPanel) return;

    listPanel.innerHTML = `
        <div class="locator-error-card animate-fade-in">
            <i class="fas fa-map-pin text-coral"></i>
            <h4>GPS Satellite Tracking Offline</h4>
            <p>${message}</p>
        </div>`;

    appendNationalHelplines(listPanel);
}

// Append high-priority national helpline directories as a fallback
function appendNationalHelplines(container) {
    const helplines = [
        { service: "National Medical Ambulance", phone: "108", desc: "24x7 Emergency Trauma Dispatcher Services" },
        { service: "National Disasters Management", phone: "1078", desc: "Crisis Emergency Medical Operations Unit" },
        { service: "Central Red Cross Blood Bank", phone: "011-23359379", desc: "Immediate Emergency Blood Infusion requests" },
        { service: "Women Emergency Helpline", phone: "1091", desc: "Crisis Intervention & Counseling Support Services" },
        { service: "National Poison Control Centre", phone: "1800-116-117", desc: "Immediate Toxicological Assessments & Advice" }
    ];

    const title = document.createElement('h3');
    title.className = "fallback-title animate-fade-in";
    title.innerHTML = "<i class='fas fa-phone-volume text-coral animate-pulse'></i> Direct Emergency Helplines";
    container.appendChild(title);

    helplines.forEach(hp => {
        const card = document.createElement('div');
        card.className = 'facility-card fallback-card animate-fade-in';
        card.innerHTML = `
            <div class="fac-card-header">
                <span class="fac-badge badge-emergency"><i class="fas fa-star-of-life animate-spin-slow"></i> HELPLINE</span>
                <span class="fac-dist text-coral"><i class="fas fa-phone-alt"></i> ${hp.phone}</span>
            </div>
            <h4>${hp.service}</h4>
            <p class="fac-addr">${hp.desc}</p>
            <div class="fac-card-actions">
                <a href="tel:${hp.phone}" class="btn-fac-call emergency-btn-call"><i class="fas fa-phone-alt"></i> Direct Dial</a>
            </div>
        `;
        container.appendChild(card);
    });
}

// Download Emergency ID Card as a premium high-DPI PDF named with patient ID
function downloadMedicalIDCardPDF(patientId) {
    const cardElement = document.getElementById('healthsync-emergency-card');
    if (!cardElement) return;

    const exportFilename = patientId ? `HealthSync_${patientId}.pdf` : 'HealthSync_Emergency_ID_Card.pdf';

    // Use [5.5, 3.3] format matching 520px x 310px aspect ratio, with 4x Retina scale and 100% print quality
    const opt = {
        margin:       0,
        filename:     exportFilename,
        image:        { type: 'jpeg', quality: 1.0 }, // Maximum image quality configuration
        html2canvas:  { scale: 4, useCORS: true, logging: false, scrollY: 0, scrollX: 0, letterRendering: true }, // 4x Retina resolution scale and letter-by-letter rendering for sharp text outlines
        jsPDF:        { unit: 'in', format: [5.5, 3.3], orientation: 'landscape' }, // Perfect scale match for 520px x 310px card container
        pagebreak:    { mode: ['avoid-all', 'css', 'legacy'] } // Ensure no horizontal cuts/page splits
    };

    html2pdf().from(cardElement).set(opt).save();
}