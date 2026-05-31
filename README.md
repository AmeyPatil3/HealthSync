<div align="center">
  <img width="120px" height="120px" alt="HealthSync Logo" src="https://img.icons8.com/color/120/hospital.png" />
  <h1>🏥 HealthSync</h1>
  <h3>Unified Personal Health Record (PHR) & Emergency Clinical System</h3>
  <p><i>A premium, high-fidelity, and role-based Java EE platform designed for patient health empowerment, emergency clinical lookups, and dynamic QR medical passport scanning.</i></p>
  <p>🚀 <b>Live Application:</b> <a href="https://healthsync-duld.onrender.com/healthsync/index.jsp">https://healthsync-duld.onrender.com/healthsync/index.jsp</a></p>

  [![Java JDK](https://img.shields.io/badge/Java_JDK-11.0-ED8B00?logo=openjdk&logoColor=white)](#)
  [![Apache Tomcat](https://img.shields.io/badge/Apache_Tomcat-9.0-F8DC75?logo=apachetomcat&logoColor=black)](#)
  [![MySQL](https://img.shields.io/badge/MySQL-8.0-4479A1?logo=mysql&logoColor=white)](#)
  [![Docker](https://img.shields.io/badge/Docker-Container-2496ED?logo=docker&logoColor=white)](#)
  [![Leaflet.js](https://img.shields.io/badge/Leaflet.js-Geolocation-199900?logo=leaflet&logoColor=white)](#)
  [![Render](https://img.shields.io/badge/Render-Deployment-46E3B7?logo=render&logoColor=white)](#)
  [![Clever Cloud](https://img.shields.io/badge/Clever_Cloud-MySQL_Host-2E3192?logo=clevercloud&logoColor=white)](#)
</div>

---

> [!IMPORTANT]
> **HealthSync is built for emergency medical response and personal health tracking.** Patients can generate secure, printable Emergency QR Passport cards, while verified clinical practitioners can instantly lookup critical patient vitals, allergies, and treatment histories in real-time during emergency crises.

---

## ✨ Primary Core Features

### 🩺 1. Comprehensive Patient Portal & Vitals Tracking
* **Vital Indicators:** Monitor clinical stats including Blood Pressure, Heart Rate, SpO2, Temperature, and Weight inside responsive charts.
* **Allergen Registry:** Custom tagging modules for drug, food, and environmental allergens with color-coded severity levels.
* **Secure Profile Management:** Dynamic avatar image uploads and structured address properties (Street, City, State, Zip) with safety fallbacks preventing unpolished `null` displays.

### 🥼 2. Doctor & Clinical Workstation
* **EMT Rapid Indexing:** Search for patients by 12-digit Patient ID or Aadhaar number to view unified medical cards.
* **Clinical Records Writer:** Attending doctors can document consultations, diagnose illnesses, attach reports, and log prescriptions (mapping individual dosages, quantities, and total course durations).
* **Shared Redirection Backend:** Hidden routing properties in [SaveMedicalRecordServlet.java](file:///Users/ameypatil/Desktop/HealthSync/servlet/SaveMedicalRecordServlet.java) and [SavePrescriptionServlet.java](file:///Users/ameypatil/Desktop/HealthSync/servlet/SavePrescriptionServlet.java) automatically direct clinicians back to their search results, preserving search state.

### 🪪 3. Emergency ID Card & PDF Export
* **Retina QR Generator:** Employs the `qrcode.js` engine to render high-contrast, wallet-sized Emergency Medical Cards with personal details, emergency contacts, and active allergens.
* **Vector PDF Downloads:** Uses `html2pdf.js` with a 3x resolution scaling filter to download cards locally in razor-sharp print formats.
* **Print Stylesheets:** Specialized CSS `@media print` rules isolate and center the medical passport in exact credit-card proportions (3.375" x 2.125") while hiding standard dashboard layouts.

### 📸 4. Camera-Based EMT QR-Scanner
* **Live Video Capture:** Integrated `html5-qrcode` video feed within the Doctor Dashboard to scan patient physical cards.
* **Smart URL Rewriter:** The scanner dynamically extracts the `searchQuery` from scanned QR codes, automatically rewriting legacy context paths (such as `/newhealth/`) to match the live server's active runtime path, resolving all 404 routing errors.

### 📍 5. GPS Health Facility Locator
* **Keyless Mapping:** Embedded [Leaflet.js](https://leafletjs.com/) and OpenStreetMap APIs to render location maps without requiring API billing keys.
* **Overpass API Integration:** Queries global OpenStreetMap nodes to map all hospitals, clinics, and emergency rooms within a 5.0 km radius, computing geodesic distances on-the-fly using the **Haversine formula**.
* **Helpline Directory:** Direct-dial phone links to emergency services (Ambulance, Poison Control, Red Cross) as instant failovers if GPS coordinates are unavailable.

### 🔒 6. Cache-Guard Session Security
* **Unauthorized Backtrack Block:** Injects active HTTP header cache-control directives alongside client history state handlers on JSP pages, forcing complete session re-validation and preventing browser back-button bypasses.

---

## 🏗️ Project Architecture & Directory Map

```text
HealthSync/
├── assets/                    # Dashboard Style sheets & Assets
│   ├── style.css              # Custom styling for Landing page
│   ├── style1.css             # Registration and Login styles
│   └── style3.css             # Dashboard split layouts & wallet card print templates
├── servlet/                   # Java Servlet Backend Components
│   ├── LoginServlet.java      # Checks user credentials & dispatches role sessions
│   ├── RegistrationServlet.java # Processes doctor/patient signups & avatar uploads
│   ├── SaveMedicalRecordServlet.java # Binds diagnoses notes and report files to patients
│   ├── SavePrescriptionServlet.java  # Adds prescription course records to the database
│   └── SaveProfileServlet.java # Modifies patient vitals and contact profiles
├── image/                     # Team profiles and general static images
├── WEB-INF/                   # Deployment descriptor config directory
│   ├── web.xml                # Handles endpoint mappings & multipart boundaries
│   └── classes/               # Compiled JVM bytecode files (.class)
├── lib/                       # Compilation libraries (mysql-connector, servlet-api)
├── Dockerfile                 # Multi-stage compilation & Tomcat container builder
├── docker-compose.yml         # Container orchestration configuration
├── schema.sql                 # Database table structures and test seed records
├── deploy.md                  # Deployment handbook (Clever Cloud + Render)
└── *.jsp                      # Dynamic Server Views (dash, doctor_dash, index, etc.)
```

---

## 🚀 Quick Start Guide

### Option A: Running with Docker (Recommended & Easiest)
Make sure you have Docker installed. Clone the repository and boot the multi-container stack:
```bash
# Clone the repository
git clone <repository-url>
cd HealthSync

# Start the application
docker-compose up --build -d
```
* **Application Landing Page:** [http://localhost:8080/healthsync/index.jsp](http://localhost:8080/healthsync/index.jsp)
* **Local MySQL Database Port:** `3307` (Mapped container database)

---

### Option B: Traditional Manual Run
#### 1. Setup Database
Initialize your local MySQL server and seed the tables using [schema.sql](file:///Users/ameypatil/Desktop/HealthSync/schema.sql):
```bash
mysql -u your_username -p
mysql> CREATE DATABASE healthsync;
mysql> USE healthsync;
mysql> source schema.sql;
```

#### 2. Compile Java Servlets
Compile the servlet source code files into standard class binaries:
```bash
javac -d WEB-INF/classes -cp WEB-INF/lib/servlet-api.jar servlet/*.java
```

#### 3. Deploy to Tomcat
1. Copy the `HealthSync` directory into your Tomcat container:
   ```bash
   cp -r /Users/ameypatil/Desktop/HealthSync /usr/local/tomcat/webapps/healthsync
   ```
2. Start the Tomcat Server:
   ```bash
   sh /usr/local/tomcat/bin/startup.sh
   ```
3. Open [http://localhost:8080/healthsync/index.jsp](http://localhost:8080/healthsync/index.jsp) in your browser.

---

## 🛠️ Build & Lifecycle Commands

* `docker-compose up --build -d` — Compiles servlets inside Docker and boots Tomcat + MySQL stack.
* `docker-compose down` — Stops running container network.
* `javac -d WEB-INF/classes -cp WEB-INF/lib/servlet-api.jar servlet/*.java` — Manually compiles Java source files.

---

## ☁️ Production Deployment Roadmap

The application is configured to run fully on cloud-native free tiers (Clever Cloud + Render):

### 1. Database Setup (Clever Cloud)
1. Register a free MySQL instance on **Clever Cloud**.
2. Connect using your preferred database client (e.g. phpMyAdmin, DBeaver) and execute [schema.sql](file:///Users/ameypatil/Desktop/HealthSync/schema.sql) to initialize tables and seed default users.

### 2. Web Service Setup (Render)
1. Deploy a new Web Service on **Render** linked to your Git repository.
2. Select **Docker** as the environment (Render will automatically execute the multi-stage compiler in your [Dockerfile](file:///Users/ameypatil/Desktop/HealthSync/Dockerfile)).
3. Under **Advanced Settings**, configure these environment variables to point to your Clever Cloud instance:
   * `DB_HOST`: *[Your Clever Cloud MySQL host]*
   * `DB_PORT`: `3306` (or custom host port)
   * `DB_NAME`: *[Your Clever Cloud database name]*
   * `DB_USER`: *[Your Clever Cloud database user]*
   * `DB_PASSWORD`: *[Your Clever Cloud database password]*
4. Once the build turns **Live**, access your portal at:
   `https://<your-subdomain>.onrender.com/healthsync/index.jsp`

---

## 👥 Developers / Contributors

Meet the development team driving the HealthSync platform:

* **Amey Patil** — [AmeyPatil3](https://github.com/AmeyPatil3)
* **Anand Patel** — [AnandPatel](https://github.com/)
* **Atharva Rajput** — [AtharvaRajput](https://github.com/)
* **Shrey Rane** — [ShreyRane](https://github.com/)
