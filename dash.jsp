<%@ page import="java.io.*, java.sql.*, java.util.Base64, javax.servlet.*, javax.servlet.http.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>HealthSync - Patient Dashboard</title>
  <link rel="stylesheet" href="./assets/style3.css">
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Lato:wght@400;700&family=Montserrat:wght@500;700&family=Outfit:wght@400;600;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <script>
    // Front-end Back-Button Security (reload page if fetched from history cache)
    window.addEventListener('pageshow', function(event) {
        if (event.persisted || (window.performance && window.performance.navigation.type === 2)) {
            window.location.reload();
        }
    });
  </script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/qrcodejs/1.0.0/qrcode.min.js"></script>
  <!-- HTML2PDF.js Library for high-fidelity vector PDF generation -->
  <script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>
  <!-- Leaflet Maps CSS & JS -->
  <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
  <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
</head>
<body>

<%
    // Prevent browser caching of clinical dashboards (Back button security)
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1
    response.setHeader("Pragma", "no-cache"); // HTTP 1.0
    response.setDateHeader("Expires", 0); // Proxies

    // Session and Role Validation
    String userId = (String) session.getAttribute("userId");
    String role = (String) session.getAttribute("userRole");
    if (userId == null || !"patient".equalsIgnoreCase(role)) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Connect to MySQL database
    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    String username = "", firstName = "", middleName = "", lastName = "", name = "";
    String dob = "", gender = "", bloodGroup = "", mobile = "";
    String street = "", city = "", state = "", zipcode = "", address = "";
    String aadhar = "", insurance = "", guardian = "", guardianMobile = "", emergencyContact = "";
    String photoBase64 = null;

    try {
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/healthsync", "root", "@Amey2005");
        
        // Fetch Patient Profile details
        String query = "SELECT * FROM Users WHERE username = ?";
        ps = con.prepareStatement(query);
        ps.setString(1, userId);
        rs = ps.executeQuery();

        if (rs.next()) {
            username = rs.getString("username");
            firstName = rs.getString("first_name");
            middleName = rs.getString("middle_name");
            lastName = rs.getString("last_name");
            name = rs.getString("name");
            dob = rs.getString("dob");
            gender = rs.getString("gender");
            bloodGroup = rs.getString("blood_group");
            mobile = rs.getString("mobile");
            street = rs.getString("street");
            city = rs.getString("city");
            state = rs.getString("state");
            zipcode = rs.getString("zipcode");
            address = rs.getString("address");
            aadhar = rs.getString("aadhaar");
            insurance = rs.getString("insurance");
            guardian = rs.getString("guardian_name");
            guardianMobile = rs.getString("guardian_mobile");
            emergencyContact = rs.getString("emergency_contact");
            
            // Retrieve profile picture
            byte[] photoBytes = rs.getBytes("profile_photo");
            if (photoBytes != null && photoBytes.length > 0) {
                photoBase64 = "data:image/jpeg;base64," + Base64.getEncoder().encodeToString(photoBytes);
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

  <!-- Header -->
  <header class="dashboard-header">
    <div class="logo-container">
      <i class="fas fa-heartbeat animate-pulse text-teal"></i>
      <h2>HealthSync</h2>
    </div>
    <div class="user-pill" style="display: flex; align-items: center; gap: 12px;">
      <% if (photoBase64 != null) { %>
        <img src="<%= photoBase64 %>" alt="Avatar" style="width: 32px; height: 32px; object-fit: cover; border-radius: 50%; border: 1.5px solid var(--primary);">
      <% } else { %>
        <i class="fas fa-user-circle" style="font-size: 24px; color: rgba(255,255,255,0.7);"></i>
      <% } %>
      <span>Welcome, <strong class="text-teal"><%= name %></strong></span>
      <a id="logoutBtn" href="./logout.jsp" class="logout-btn"><i class="fas fa-sign-out-alt"></i> Logout</a>
    </div>
  </header>

  <div class="dashboard-container">
    <div class="dash-summary">
        <h1>Patient Portal</h1>
        <p>Manage your medical documents, allergies, and clinical records securely.</p>
    </div>

    <!-- Tab Menu -->
    <div class="tab-menu">
      <button class="tab-button active" data-tab="profile"><i class="fas fa-user-circle"></i> Profile</button>
      <button class="tab-button" data-tab="allergic-info"><i class="fas fa-allergies"></i> Allergies</button>
      <button class="tab-button" data-tab="medical-records"><i class="fas fa-file-medical"></i> Medical Records</button>
      <button class="tab-button" data-tab="prescriptions"><i class="fas fa-prescription-bottle-alt"></i> Prescriptions</button>
      <button class="tab-button" data-tab="emergency-locator"><i class="fas fa-map-marked-alt"></i> Emergency Locator</button>
    </div>

    <!-- Profile Tab Content -->
    <div id="profile" class="tab-content active">
      <div class="profile-layout">
        <div class="profile-vitals-card">
          <div class="vital-avatar" style="overflow: hidden; display: flex; justify-content: center; align-items: center;">
            <% if (photoBase64 != null) { %>
              <img src="<%= photoBase64 %>" alt="Profile Picture" style="width: 100%; height: 100%; object-fit: cover;">
            <% } else { %>
              <i class="fas fa-user"></i>
            <% } %>
          </div>
          <h3><%= name %></h3>
          <p class="role-badge">Patient Account</p>
          
          <button class="edit-profile-btn" onclick="toggleEditProfile()" style="width: 100%; margin-bottom: 20px; justify-content: center; font-family: 'Montserrat', sans-serif; letter-spacing: 0.5px; border-radius: 30px; box-shadow: var(--shadow-sm);"><i class="fas fa-edit"></i> Edit Profile Info</button>

          <div class="blood-group-badge <%= (bloodGroup != null && !bloodGroup.isEmpty() && !"null".equalsIgnoreCase(bloodGroup)) ? "has-blood" : "no-blood" %>">
              <i class="fas fa-tint"></i> Blood Group: <strong><%= (bloodGroup != null && !bloodGroup.isEmpty() && !"null".equalsIgnoreCase(bloodGroup)) ? bloodGroup : "Not Set" %></strong>
          </div>
          <div class="health-id-pill">
              <label>HealthSync ID</label>
              <span><%= username %></span>
          </div>
        </div>

        <div class="profile-details-grid">
          <div class="detail-card">
            <h4><i class="fas fa-user-tag text-teal"></i> Name Details</h4>
            <p><strong>First Name:</strong> <%= (firstName != null && !"null".equalsIgnoreCase(firstName)) ? firstName : "Not Provided" %></p>
            <p><strong>Middle Name:</strong> <%= (middleName != null && !middleName.trim().isEmpty() && !"null".equalsIgnoreCase(middleName)) ? middleName : "Not Provided" %></p>
            <p><strong>Last Name:</strong> <%= (lastName != null && !"null".equalsIgnoreCase(lastName)) ? lastName : "Not Provided" %></p>
          </div>

          <div class="detail-card">
            <h4><i class="fas fa-calendar-alt text-teal"></i> Demographics</h4>
            <p><strong>Date of Birth:</strong> <%= (dob != null && !"null".equalsIgnoreCase(dob)) ? dob : "Not Provided" %></p>
            <p><strong>Gender:</strong> <%= (gender != null && !"null".equalsIgnoreCase(gender)) ? gender : "Not Provided" %></p>
            <p><strong>Mobile Number:</strong> <%= (mobile != null && !"null".equalsIgnoreCase(mobile)) ? mobile : "Not Provided" %></p>
          </div>

          <div class="detail-card">
            <h4><i class="fas fa-map-marked-alt text-teal"></i> Address</h4>
            <% if ((street != null && !street.trim().isEmpty() && !"null".equalsIgnoreCase(street)) || 
                   (city != null && !city.trim().isEmpty() && !"null".equalsIgnoreCase(city)) || 
                   (state != null && !state.trim().isEmpty() && !"null".equalsIgnoreCase(state)) || 
                   (zipcode != null && !zipcode.trim().isEmpty() && !"null".equalsIgnoreCase(zipcode))) { %>
              <p><strong>Street:</strong> <%= (street != null && !street.trim().isEmpty() && !"null".equalsIgnoreCase(street)) ? street : "Not Provided" %></p>
              <p><strong>City:</strong> <%= (city != null && !city.trim().isEmpty() && !"null".equalsIgnoreCase(city)) ? city : "Not Provided" %></p>
              <p><strong>State:</strong> <%= (state != null && !state.trim().isEmpty() && !"null".equalsIgnoreCase(state)) ? state : "Not Provided" %></p>
              <p><strong>Zip Code:</strong> <%= (zipcode != null && !zipcode.trim().isEmpty() && !"null".equalsIgnoreCase(zipcode)) ? zipcode : "Not Provided" %></p>
            <% } else { %>
              <p><%= (address != null && !address.trim().isEmpty() && !"null".equalsIgnoreCase(address)) ? address : "Address not provided." %></p>
            <% } %>
          </div>

          <div class="detail-card">
            <h4><i class="fas fa-id-card text-teal"></i> Identifications</h4>
            <p><strong>Aadhaar Card:</strong> <%= (aadhar != null && !aadhar.trim().isEmpty() && !"null".equalsIgnoreCase(aadhar)) ? aadhar : "Not Provided" %></p>
            <p><strong>Insurance Number:</strong> <%= (insurance != null && !insurance.isEmpty() && !"null".equalsIgnoreCase(insurance)) ? insurance : "Not Provided" %></p>
          </div>

          <div class="detail-card emergency-detail">
            <h4><i class="fas fa-ambulance text-coral animate-pulse"></i> Emergency Contacts</h4>
            <p><strong>Guardian Name:</strong> <%= (guardian != null && !guardian.isEmpty() && !"null".equalsIgnoreCase(guardian)) ? guardian : "Not Provided" %></p>
            <p><strong>Guardian Mobile:</strong> <%= (guardianMobile != null && !guardianMobile.isEmpty() && !"null".equalsIgnoreCase(guardianMobile)) ? guardianMobile : "Not Provided" %></p>
            <p><strong>Emergency Contact No:</strong> <strong class="text-coral"><%= (emergencyContact != null && !emergencyContact.isEmpty() && !"null".equalsIgnoreCase(emergencyContact)) ? emergencyContact : "Not Provided" %></strong></p>
          </div>
        </div>
      </div>

      <!-- Emergency Medical ID Card Section -->
      <div class="medical-card-section animate-fade-in">
          <div class="section-title-alt">
              <h3><i class="fas fa-id-card-alt text-teal"></i> Emergency Medical ID Card</h3>
              <p>Download or print your wallet card. In case of emergency, medical personnel can scan it to instantly view your health records.</p>
          </div>
          
          <div class="medical-id-card-card-layout">
              <div class="medical-id-card" id="healthsync-emergency-card">
                  <div class="card-header-banner">
                      <div class="card-logo-group">
                          <i class="fas fa-heartbeat animate-pulse text-coral"></i>
                          <span>HealthSync</span>
                      </div>
                      <div class="card-emergency-title">EMERGENCY CARD</div>
                  </div>
                  
                  <div class="card-main-body">
                      <div class="card-photo-col" style="display: flex; flex-direction: column; align-items: center; gap: 8px;">
                          <% if (photoBase64 != null) { %>
                              <img src="<%= photoBase64 %>" alt="Patient Photo" style="width: 90px; height: 90px; object-fit: cover; border-radius: 12px; border: 1.5px solid rgba(255,255,255,0.25);">
                          <% } else { %>
                              <i class="fas fa-user-shield"></i>
                          <% } %>
                          <div class="blood-pill"><%= (bloodGroup != null && !bloodGroup.isEmpty()) ? bloodGroup : "Not Set" %></div>
                      </div>
                      
                      <div class="card-info-col">
                          <h3><%= name %></h3>
                          <p class="card-field-id">Health ID: <strong><%= username %></strong></p>
                          <div class="card-dem-row">
                              <span>DOB: <strong><%= dob %></strong></span>
                              <span>Gender: <strong><%= gender %></strong></span>
                          </div>
                          <p class="card-field-emerg">Emergency: <strong class="text-coral"><%= (emergencyContact != null && !emergencyContact.isEmpty()) ? emergencyContact : "Not Set" %></strong></p>
                      </div>
                      
                      <div class="card-qr-col">
                          <div id="qrcode-render"></div>
                      </div>
                  </div>
                  
                  <div class="card-footer-banner">
                      <i class="fas fa-shield-alt"></i> IN EMERGENCY: SCAN QR CODE FOR CRITICAL ALLERGY & VITAL DIRECTORY
                  </div>
              </div>
              
              <div class="card-download-panel">
                  <button type="button" class="btn-print-card" onclick="printMedicalIDCard()">
                      <i class="fas fa-print"></i> Print Wallet Card
                  </button>
                  <button type="button" class="btn-print-card" onclick="downloadMedicalIDCardPDF('<%= username %>')" style="background: linear-gradient(135deg, var(--secondary) 0%, #06b6d4 100%); box-shadow: 0 4px 12px rgba(6, 182, 212, 0.15);">
                      <i class="fas fa-file-pdf"></i> Download Card as PDF
                  </button>
              </div>
          </div>
      </div>

      <!-- Expandable Edit Profile Form -->
      <div id="edit-profile-form-container" class="edit-profile-form-container" style="display: none;">
        <h2>Update Profile Details</h2>
        <form action="SaveProfileServlet" method="POST" enctype="multipart/form-data" class="edit-profile-form">
          <input type="hidden" name="userId" value="<%= username %>">
          
          <div class="form-row">
            <div class="form-group">
              <label for="edit-name">Display Name</label>
              <input type="text" id="edit-name" name="name" value="<%= name %>" required>
            </div>
            <div class="form-group">
              <label for="edit-dob">Date of Birth</label>
              <input type="date" id="edit-dob" name="dob" value="<%= dob %>" required>
            </div>
          </div>

          <div class="form-row">
            <div class="form-group">
              <label for="edit-gender">Gender</label>
              <select id="edit-gender" name="gender" required>
                <option value="Male" <%= "Male".equals(gender) ? "selected" : "" %>>Male</option>
                <option value="Female" <%= "Female".equals(gender) ? "selected" : "" %>>Female</option>
                <option value="Other" <%= "Other".equals(gender) ? "selected" : "" %>>Other</option>
              </select>
            </div>
            <div class="form-group">
              <label for="edit-blood">Blood Group</label>
              <select id="edit-blood" name="blood_group" required>
                <option value="A-Positive" <%= "A-Positive".equals(bloodGroup) ? "selected" : "" %>>A-Positive (A+)</option>
                <option value="A-Negative" <%= "A-Negative".equals(bloodGroup) ? "selected" : "" %>>A-Negative (A-)</option>
                <option value="B-Positive" <%= "B-Positive".equals(bloodGroup) ? "selected" : "" %>>B-Positive (B+)</option>
                <option value="B-Negative" <%= "B-Negative".equals(bloodGroup) ? "selected" : "" %>>B-Negative (B-)</option>
                <option value="O-Positive" <%= "O-Positive".equals(bloodGroup) ? "selected" : "" %>>O-Positive (O+)</option>
                <option value="O-Negative" <%= "O-Negative".equals(bloodGroup) ? "selected" : "" %>>O-Negative (O-)</option>
                <option value="AB-Positive" <%= "AB-Positive".equals(bloodGroup) ? "selected" : "" %>>AB-Positive (AB+)</option>
                <option value="AB-Negative" <%= "AB-Negative".equals(bloodGroup) ? "selected" : "" %>>AB-Negative (AB-)</option>
              </select>
            </div>
          </div>

          <div class="form-row">
            <div class="form-group">
              <label for="edit-mobile">Mobile Number</label>
              <input type="text" id="edit-mobile" name="mobile" value="<%= mobile %>" required>
            </div>
            <div class="form-group">
              <label for="edit-insurance">Insurance Number</label>
              <input type="text" id="edit-insurance" name="insurance" value="<%= insurance %>">
            </div>
          </div>

          <div class="form-row">
            <div class="form-group">
              <label for="edit-street">Street Address</label>
              <input type="text" id="edit-street" name="street" value="<%= street %>" required>
            </div>
            <div class="form-group">
              <label for="edit-city">City</label>
              <input type="text" id="edit-city" name="city" value="<%= city %>" required>
            </div>
          </div>

          <div class="form-row">
            <div class="form-group">
              <label for="edit-state">State</label>
              <input type="text" id="edit-state" name="state" value="<%= state %>" required>
            </div>
            <div class="form-group">
              <label for="edit-zipcode">Zip Code</label>
              <input type="text" id="edit-zipcode" name="zipcode" value="<%= zipcode %>" required>
            </div>
          </div>

          <div class="form-row">
            <div class="form-group">
              <label for="edit-guardian">Guardian Name</label>
              <input type="text" id="edit-guardian" name="guardian_name" value="<%= guardian %>">
            </div>
            <div class="form-group">
              <label for="edit-Gmobile">Guardian Mobile</label>
              <input type="text" id="edit-Gmobile" name="guardian_mobile" value="<%= guardianMobile %>">
            </div>
            <div class="form-group">
              <label for="edit-emergency">Emergency Contact</label>
              <input type="text" id="edit-emergency" name="emergency_contact" value="<%= emergencyContact %>" required>
            </div>
          </div>

          <div class="form-row">
            <div class="form-group" style="flex: 1 1 100%;">
              <label for="edit-photo"><i class="fas fa-camera"></i> Update Profile Picture (Optional)</label>
              <input type="file" id="edit-photo" name="profile_photo" accept="image/*" style="width: 100%; padding: 10px; background: var(--neutral-light); border: 1.5px dashed var(--border-color); border-radius: var(--border-radius-sm);">
            </div>
          </div>

          <div class="form-actions">
            <button type="submit" class="save-profile-btn"><i class="fas fa-save"></i> Save Changes</button>
            <button type="button" class="cancel-profile-btn" onclick="toggleEditProfile()"><i class="fas fa-times"></i> Cancel</button>
          </div>
        </form>
      </div>
    </div>

    <!-- Allergic Info Tab Content -->
    <div id="allergic-info" class="tab-content">
      <div class="tab-layout">
        <!-- New Allergy Insertion -->
        <div class="form-panel">
          <h3>Record New Allergy</h3>
          <form action="saveAllergy.jsp" method="POST">
            <input type="hidden" name="userId" value="<%= username %>">
            <div class="form-group">
              <label>Allergy Name:</label>
              <input type="text" name="allergy_name" placeholder="e.g. Shellfish, Penicillin" required>
            </div>
            <div class="form-group">
              <label>Reaction & Description:</label>
              <textarea name="description" placeholder="Describe symptoms or reaction, e.g. swelling, hives" rows="3" required></textarea>
            </div>
            <div class="form-group">
              <label>Severity Level:</label>
              <select name="severity">
                  <option value="Safe">Safe (Mild / Negligible)</option>
                  <option value="Moderate">Moderate (Manageable)</option>
                  <option value="Critical">Critical (Anaphylactic / Life Threatening)</option>
              </select>
            </div>
            <button type="submit" class="submit-btn"><i class="fas fa-plus"></i> Save Allergy Info</button>
          </form>
        </div>

        <!-- Allergy List Display -->
        <div class="list-panel">
          <div class="list-header">
            <h3>Registered Allergies</h3>
            <input type="text" class="search-bar" id="searchAllergies" placeholder="Search allergies by severity (Safe/Moderate/Critical)...">
          </div>
          <div class="info-grid" id="allergy-container">
            <%
                try {
                    String query = "SELECT * FROM Allergies WHERE user_id = ?";
                    ps = con.prepareStatement(query);
                    ps.setString(1, userId);
                    rs = ps.executeQuery();
                    boolean hasAllergies = false;
                    while (rs.next()) {
                        hasAllergies = true;
                        String severity = rs.getString("severity");
                        String severityClass = "sev-safe";
                        String alertIcon = "fa-check-circle";
                        if ("Critical".equalsIgnoreCase(severity)) {
                            severityClass = "sev-critical animate-pulse-red";
                            alertIcon = "fa-exclamation-triangle";
                        } else if ("Moderate".equalsIgnoreCase(severity)) {
                            severityClass = "sev-moderate";
                            alertIcon = "fa-exclamation-circle";
                        }
            %>
            <div class="info-block card-allergy" data-severity="<%= severity.toLowerCase() %>">
                <div class="allergy-header">
                    <span class="severity-badge <%= severityClass %>">
                        <i class="fas <%= alertIcon %>"></i> <%= severity %>
                    </span>
                    <h4><%= rs.getString("allergy_name") %></h4>
                </div>
                <p class="allergy-description"><%= rs.getString("description") %></p>
            </div>
            <% 
                    }
                    if (!hasAllergies) {
            %>
                <div class="empty-state">
                    <i class="fas fa-shield-virus"></i>
                    <p>No active allergies registered.</p>
                </div>
            <%
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            %>
          </div>
        </div>
      </div>
    </div>

    <!-- Medical Records Tab Content -->
    <div id="medical-records" class="tab-content">
      <div class="tab-layout">
        <!-- New Medical Record Insertion -->
        <div class="form-panel">
          <h3>Record Medical Assessment</h3>
          <form action="SaveMedicalRecordServlet" method="POST" enctype="multipart/form-data">
            <input type="hidden" name="userId" value="<%= username %>">
            <div class="form-group">
              <label>Diagnosis / Assessment:</label>
              <input type="text" name="diagnosis" placeholder="e.g. Acute Gastritis" required>
            </div>
            <div class="form-group">
              <label>Attending Doctor / Specialist:</label>
              <input type="text" name="attending_doctor" placeholder="e.g. Dr. Rajesh Patel" required>
            </div>
            <div class="form-group">
              <label>Assessment Date:</label>
              <input type="date" name="date" required>
            </div>
            <div class="form-group">
              <label>Clinical Notes / Description:</label>
              <textarea name="description" placeholder="Clinical notes, medications prescribed, or treatment plan" rows="3"></textarea>
            </div>
            <div class="form-group">
              <label>Case Sheet / Report Attachment (PDF/Image):</label>
              <input type="file" name="case_sheet" accept=".pdf, .jpg, .jpeg, .png" required>
            </div>
            <button type="submit" class="submit-btn"><i class="fas fa-file-upload"></i> Upload Record</button>
          </form>
        </div>

        <!-- Records List Display -->
        <div class="list-panel">
          <h3>Historical Records</h3>
          <div class="info-grid">
            <%
                try {
                    String query = "SELECT * FROM MedicalRecords WHERE user_id = ? ORDER BY date DESC";
                    ps = con.prepareStatement(query);
                    ps.setString(1, userId);
                    rs = ps.executeQuery();
                    boolean hasRecords = false;
                    while (rs.next()) {
                        hasRecords = true;
                        byte[] fileBytes = rs.getBytes("case_sheet");
                        String fileType = rs.getString("case_sheet_type");
                        boolean isImage = (fileType != null && fileType.startsWith("image/"));
            %>
            <div class="info-block clinical-card">
                <div class="clinical-card-header">
                    <h4><%= rs.getString("diagnosis") %></h4>
                    <span class="clinical-date"><i class="fas fa-calendar-day"></i> <%= rs.getDate("date") %></span>
                </div>
                <p><strong><i class="fas fa-user-md text-teal"></i> Attending Doctor:</strong> <%= rs.getString("attending_doctor") %></p>
                <p class="clinical-notes"><%= rs.getString("description") %></p>
                
                <%
                    if (fileBytes != null && fileBytes.length > 0) {
                        String base64File = Base64.getEncoder().encodeToString(fileBytes);
                        String dataUri = "data:" + fileType + ";base64," + base64File;
                %>
                    <div class="document-section">
                        <label><i class="fas fa-paperclip"></i> Attachment:</label>
                        <% if (isImage) { %>
                            <div class="clinical-thumbnail" onclick="viewDocumentModal('<%= dataUri %>', 'image')">
                                <img src="<%= dataUri %>" alt="Attachment Thumbnail">
                                <div class="thumb-overlay"><i class="fas fa-eye"></i> Click to Preview</div>
                            </div>
                        <% } else { %>
                            <div class="pdf-action-group" style="display: flex; gap: 10px; margin-top: 8px; flex-wrap: wrap;">
                                <button type="button" class="btn-preview-pdf" onclick="viewDocumentModal('<%= dataUri %>', 'pdf')" style="background: var(--primary); color: white; border: none; padding: 8px 16px; border-radius: var(--border-radius-sm); font-size: 13px; font-weight: bold; cursor: pointer; display: inline-flex; align-items: center; gap: 6px; transition: var(--transition);"><i class="fas fa-eye"></i> Click to Preview</button>
                                <a href="<%= dataUri %>" download="Record_<%= rs.getString("diagnosis") %>.pdf" class="btn-view-doc" style="padding: 8px 16px; font-size: 13px; margin: 0; display: inline-flex; align-items: center; gap: 6px;"><i class="fas fa-download"></i> Download PDF</a>
                            </div>
                        <% } %>
                    </div>
                <% } %>
            </div>
            <% 
                    }
                    if (!hasRecords) {
            %>
                <div class="empty-state">
                    <i class="fas fa-folder-open"></i>
                    <p>No historical medical records stored yet.</p>
                </div>
            <%
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            %>
          </div>
        </div>
      </div>
    </div>

    <!-- Prescriptions Tab Content -->
    <div id="prescriptions" class="tab-content">
      <div class="tab-layout">
        <!-- New Prescription Insertion -->
        <div class="form-panel">
          <h3>Record New Prescription</h3>
          <form action="SavePrescriptionServlet" method="POST" enctype="multipart/form-data">
            <input type="hidden" name="userId" value="<%= username %>">
            <div class="form-group">
              <label>Diagnosis / Indication:</label>
              <input type="text" name="diagnosis" placeholder="e.g. Hypertension, Flu" required>
            </div>
            <div class="form-group">
              <label>Prescribing Professional:</label>
              <input type="text" name="prescribed_by" placeholder="e.g. Dr. John Watson" required>
            </div>
            <div class="form-group">
              <label>Prescribed Date:</label>
              <input type="date" name="prescribed_date" required>
            </div>
            <div class="form-group">
              <label>Medicines & Individual Quantities:</label>
              <textarea name="medicines" placeholder="e.g. Paracetamol 500mg (10 Tablets) - 1-0-1 after meals" rows="3" required></textarea>
            </div>
            <div class="form-group">
              <label>Total Course Duration:</label>
              <input type="text" name="quantity" placeholder="e.g. 5 Days / 1 Week" required>
            </div>
            <div class="form-group">
              <label>Prescription Document Attachment (PDF/Image):</label>
              <input type="file" name="prescription_file" accept=".pdf, .jpg, .jpeg, .png" required>
            </div>
            <button type="submit" class="submit-btn"><i class="fas fa-file-medical"></i> Save Prescription</button>
          </form>
        </div>

        <!-- Prescriptions List Display -->
        <div class="list-panel">
          <h3>Active & Past Prescriptions</h3>
          <div class="info-grid">
            <%
                try {
                    String query = "SELECT * FROM Prescriptions WHERE user_id = ? ORDER BY prescribed_date DESC";
                    ps = con.prepareStatement(query);
                    ps.setString(1, userId);
                    rs = ps.executeQuery();
                    boolean hasPrescriptions = false;
                    while (rs.next()) {
                        hasPrescriptions = true;
                        byte[] fileBytes = rs.getBytes("prescription_file");
                        String fileType = rs.getString("file_type");
                        boolean isImage = (fileType != null && fileType.startsWith("image/"));
            %>
            <div class="info-block clinical-card">
                <div class="clinical-card-header">
                    <h4><%= rs.getString("diagnosis") %></h4>
                    <span class="clinical-date"><i class="fas fa-calendar-day"></i> <%= rs.getDate("prescribed_date") %></span>
                </div>
                <p><strong><i class="fas fa-user-md text-teal"></i> Prescribed By:</strong> <%= rs.getString("prescribed_by") %></p>
                <p><strong><i class="fas fa-pills text-teal"></i> Medication Details:</strong></p>
                <p class="medication-details"><%= rs.getString("medicines") %></p>
                <p><strong><i class="fas fa-prescription-bottle text-teal"></i> Total Course Duration:</strong> <%= rs.getString("quantity") %></p>

                <%
                    if (fileBytes != null && fileBytes.length > 0) {
                        String base64File = Base64.getEncoder().encodeToString(fileBytes);
                        String dataUri = "data:" + fileType + ";base64," + base64File;
                %>
                    <div class="document-section">
                        <label><i class="fas fa-paperclip"></i> Attached Prescription File:</label>
                        <% if (isImage) { %>
                            <div class="clinical-thumbnail" onclick="viewDocumentModal('<%= dataUri %>', 'image')">
                                <img src="<%= dataUri %>" alt="Prescription Thumbnail">
                                <div class="thumb-overlay"><i class="fas fa-eye"></i> Click to Preview</div>
                            </div>
                        <% } else { %>
                            <div class="pdf-action-group" style="display: flex; gap: 10px; margin-top: 8px; flex-wrap: wrap;">
                                <button type="button" class="btn-preview-pdf" onclick="viewDocumentModal('<%= dataUri %>', 'pdf')" style="background: var(--primary); color: white; border: none; padding: 8px 16px; border-radius: var(--border-radius-sm); font-size: 13px; font-weight: bold; cursor: pointer; display: inline-flex; align-items: center; gap: 6px; transition: var(--transition);"><i class="fas fa-eye"></i> Click to Preview</button>
                                <a href="<%= dataUri %>" download="Prescription_<%= rs.getString("diagnosis") %>.pdf" class="btn-view-doc" style="padding: 8px 16px; font-size: 13px; margin: 0; display: inline-flex; align-items: center; gap: 6px;"><i class="fas fa-download"></i> Download PDF</a>
                            </div>
                        <% } %>
                    </div>
                <% } %>
            </div>
            <% 
                    }
                    if (!hasPrescriptions) {
            %>
                <div class="empty-state">
                    <i class="fas fa-capsules"></i>
                    <p>No prescription logs stored yet.</p>
                </div>
            <%
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                } finally {
                    if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
                    if (ps != null) try { ps.close(); } catch (SQLException ignored) {}
                    if (con != null) try { con.close(); } catch (SQLException ignored) {}
                }
            %>
          </div>
        </div>
      </div>
    </div>

    <!-- Emergency Locator Tab Content -->
    <div id="emergency-locator" class="tab-content animate-fade-in">
      <div class="locator-layout">
        
        <!-- Sidebar Panel for Facility Listings -->
        <div class="locator-sidebar">
          <div class="sidebar-header-group">
            <h3><i class="fas fa-hospital-symbol text-coral animate-pulse"></i> Nearest Emergency Care</h3>
            <p id="radius-text">Scanning 5.0 km radius from current GPS location.</p>
          </div>
          
          <div class="facilities-grid-panel" id="facilities-list">
             <div class="locating-state" id="locator-status-card">
                 <i class="fas fa-location-crosshairs fa-spin text-teal"></i>
                 <p>Acquiring secure GPS coordinates...</p>
                 <span class="sub-status">Please permit browser geolocation access when prompted.</span>
             </div>
          </div>
        </div>

        <!-- Interactive Map Panel -->
        <div class="locator-map-panel">
          <div id="emerg-map"></div>
        </div>
        
      </div>
    </div>
  </div>

  <!-- Document View Modal -->
  <div id="document-modal" class="document-modal" onclick="closeDocumentModal()">
    <span class="close-modal" onclick="closeDocumentModal()">&times;</span>
    <div class="modal-content-container" onclick="event.stopPropagation()">
        <img id="modal-image" src="" alt="Full View Document" style="display: none;">
        <iframe id="modal-pdf" src="" style="display: none; width: 80vw; height: 80vh; border: none; border-radius: var(--border-radius-md); background: white; box-shadow: var(--shadow-lg);"></iframe>
    </div>
  </div>

  <div class="footer">
    <p>© 2026 HealthSync. All rights reserved.</p>
    <p><a href="./contact.jsp">Contact Project Team</a></p>
  </div>

  <script src="dashboard.js"></script>
  <script>
    // Dynamically render the patient's Emergency QR Code on page load
    window.addEventListener('load', function() {
        const qrContainer = document.getElementById('qrcode-render');
        if (qrContainer) {
            // Dynamically build lookup URL resolving browser host (domain and port)
            const searchUrl = window.location.protocol + "//" + window.location.host + "/newhealth/doctor_dash.jsp?searchQuery=<%= username %>";
            
            new QRCode(qrContainer, {
                text: searchUrl,
                width: 256, // High resolution generation for ultimate scanning clarity
                height: 256,
                colorDark : "#0f172a",
                colorLight : "#ffffff",
                correctLevel : QRCode.CorrectLevel.H
            });
        }
    });
  </script>
</body>
</html>
