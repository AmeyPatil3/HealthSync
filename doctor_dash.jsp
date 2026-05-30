<%@ page import="java.io.*, java.sql.*, java.util.Base64, javax.servlet.*, javax.servlet.http.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>HealthSync - Doctor Emergency Portal</title>
  <link rel="stylesheet" href="./assets/style3.css">
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Lato:wght@400;700&family=Montserrat:wght@500;700&family=Outfit:wght@400;600;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <!-- HTML5 QR Code Scanner Library -->
  <script src="https://cdnjs.cloudflare.com/ajax/libs/html5-qrcode/2.3.8/html5-qrcode.min.js"></script>
  <script>
    // Front-end Back-Button Security (reload page if fetched from history cache)
    window.addEventListener('pageshow', function(event) {
        if (event.persisted || (window.performance && window.performance.navigation.type === 2)) {
            window.location.reload();
        }
    });
  </script>
</head>
<body>

<%
    // Prevent browser caching of clinical dashboards (Back button security)
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1
    response.setHeader("Pragma", "no-cache"); // HTTP 1.0
    response.setDateHeader("Expires", 0); // Proxies

    // Session and Role Validation
    String doctorId = (String) session.getAttribute("userId");
    String role = (String) session.getAttribute("userRole");
    String docName = (String) session.getAttribute("name");
    String docPhotoBase64 = null;
    
    if (doctorId == null || !"doctor".equalsIgnoreCase(role)) {
        response.sendRedirect("login.jsp");
        return;
    }

    String searchQuery = request.getParameter("searchQuery");
    boolean searchAttempted = (searchQuery != null && !searchQuery.trim().isEmpty());
    boolean patientFound = false;

    // Connect to MySQL database
    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    // Patient Fields
    String pUsername = "", pName = "", pDob = "", pGender = "", pBloodGroup = "", pMobile = "", pAddress = "";
    String pAadhar = "", pInsurance = "", pGuardian = "", pGuardianMobile = "", pEmergencyContact = "";
    String pPhotoBase64 = null;

    try {
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/healthsync", "root", "@Amey2005");
        
        // Fetch doctor photo
        String docPhotoQuery = "SELECT profile_photo FROM Users WHERE username = ?";
        PreparedStatement psDoc = con.prepareStatement(docPhotoQuery);
        psDoc.setString(1, doctorId);
        ResultSet rsDoc = psDoc.executeQuery();
        if (rsDoc.next()) {
            byte[] photoBytes = rsDoc.getBytes("profile_photo");
            if (photoBytes != null && photoBytes.length > 0) {
                docPhotoBase64 = "data:image/jpeg;base64," + Base64.getEncoder().encodeToString(photoBytes);
            }
        }
        rsDoc.close();
        psDoc.close();
        
        if (searchAttempted) {
            // Normalize search input by removing spaces and dashes
            String cleanQuery = searchQuery.trim().replaceAll("[\\s-]", "");

            // Find Patient by 12-digit Username OR Aadhaar (format-insensitive)
            String query = "SELECT * FROM Users WHERE (REPLACE(username, ' ', '') = ? OR REPLACE(REPLACE(aadhaar, '-', ''), ' ', '') = ?) AND user_type = 'patient'";
            ps = con.prepareStatement(query);
            ps.setString(1, cleanQuery);
            ps.setString(2, cleanQuery);
            rs = ps.executeQuery();

            if (rs.next()) {
                patientFound = true;
                pUsername = rs.getString("username");
                pName = rs.getString("name");
                pDob = rs.getString("dob");
                pGender = rs.getString("gender");
                pBloodGroup = rs.getString("blood_group");
                pMobile = rs.getString("mobile");
                pAddress = rs.getString("address");
                pAadhar = rs.getString("aadhaar");
                pInsurance = rs.getString("insurance");
                pGuardian = rs.getString("guardian_name");
                pGuardianMobile = rs.getString("guardian_mobile");
                pEmergencyContact = rs.getString("emergency_contact");
                
                byte[] pPhotoBytes = rs.getBytes("profile_photo");
                if (pPhotoBytes != null && pPhotoBytes.length > 0) {
                    pPhotoBase64 = "data:image/jpeg;base64," + Base64.getEncoder().encodeToString(pPhotoBytes);
                }
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

  <!-- Header -->
  <header class="dashboard-header doc-header">
    <div class="logo-container">
      <i class="fas fa-user-md animate-pulse text-aqua"></i>
      <h2>HealthSync <span class="doc-label">MD Emergency Portal</span></h2>
    </div>
    <div class="user-pill" style="display: flex; align-items: center; gap: 12px;">
      <% if (docPhotoBase64 != null) { %>
        <img src="<%= docPhotoBase64 %>" alt="Doctor" style="width: 32px; height: 32px; object-fit: cover; border-radius: 50%; border: 1.5px solid var(--secondary);">
      <% } else { %>
        <i class="fas fa-user-circle" style="font-size: 24px; color: rgba(255,255,255,0.7);"></i>
      <% } %>
      <span>Logged in: <strong class="text-aqua"><%= docName %></strong></span>
      <a id="logoutBtn" href="./logout.jsp" class="logout-btn"><i class="fas fa-sign-out-alt"></i> Logout</a>
    </div>
  </header>

  <div class="dashboard-container">
    
    <!-- Emergency Search Banner -->
    <div class="doctor-search-hero">
        <h1>Patient Record Emergency Lookup</h1>
        <p>Instantly retrieve clinical logs, critical drug allergen warnings, and blood groups using the patient's 12-digit Unique HealthSync ID or Aadhaar Card number.</p>
        
        <form action="doctor_dash.jsp" method="GET" class="doc-search-form" id="search-form">
            <div class="search-input-group" style="margin-bottom: 20px;">
                <i class="fas fa-search search-icon"></i>
                <input type="text" id="search-input" name="searchQuery" placeholder="Enter 12-digit Unique Health ID or Aadhaar (xxxx-xxxx-xxxx)" value="<%= (searchQuery != null) ? searchQuery : "" %>" required>
                <button type="submit" class="doc-search-btn">Retrieve Records</button>
            </div>
            
            <button type="button" class="btn-scan-qr" onclick="toggleQrScanner()" style="background: rgba(6, 182, 212, 0.15); color: var(--secondary); border: 1.5px solid rgba(6, 182, 212, 0.4); padding: 10px 24px; border-radius: 50px; font-weight: 700; cursor: pointer; transition: var(--transition); display: inline-flex; align-items: center; gap: 8px;">
                <i class="fas fa-qrcode"></i> Scan Emergency Wristband / Card
            </button>
        </form>

        <!-- Interactive Camera QR Code Scanner Panel -->
        <div id="qr-scanner-container" style="display: none; max-width: 480px; margin: 25px auto 0 auto; background: rgba(15, 23, 42, 0.8); padding: 20px; border-radius: var(--border-radius-md); border: 1px solid rgba(255, 255, 255, 0.1); box-shadow: var(--shadow-lg); text-align: center;">
            <h4 style="margin-bottom: 12px; font-family: 'Montserrat', sans-serif; color: var(--white); display: flex; align-items: center; justify-content: center; gap: 8px;"><i class="fas fa-camera text-aqua animate-pulse"></i> EMT Camera QR Scanner</h4>
            <div id="reader" style="width: 100%; border-radius: var(--border-radius-sm); overflow: hidden; background: #000; border: none; box-shadow: inset 0 0 10px rgba(0,0,0,0.5);"></div>
            <button type="button" onclick="stopQrScanner()" style="margin-top: 15px; background: rgba(244, 63, 94, 0.15); color: var(--coral); border: 1px solid rgba(244, 63, 94, 0.3); padding: 8px 20px; border-radius: 50px; font-weight: 700; cursor: pointer; transition: var(--transition); display: inline-flex; align-items: center; gap: 6px;">
                <i class="fas fa-stop"></i> Stop Scanner Camera
            </button>
        </div>
    </div>

    <% if (searchAttempted) { %>
        <% if (patientFound) { %>
            
            <!-- EMERGENCY MEDICAL PROFILE CARD -->
            <div class="emergency-profile-banner animate-fade-in">
                
                <!-- Vital Alerts Column -->
                <div class="vital-alerts-column">
                    
                    <!-- High Priority Vital markers -->
                    <div class="vital-marker-card blood-vital">
                        <i class="fas fa-tint"></i>
                        <label>VITAL BLOOD TYPE</label>
                        <h2><%= (pBloodGroup != null && !pBloodGroup.isEmpty()) ? pBloodGroup : "UNKNOWN" %></h2>
                    </div>

                    <div class="vital-marker-card alert-vital">
                        <i class="fas fa-ambulance"></i>
                        <label>EMERGENCY CONTACT</label>
                        <h2><%= (pEmergencyContact != null && !pEmergencyContact.isEmpty()) ? pEmergencyContact : "NOT REGISTERED" %></h2>
                        <span><%= (pGuardian != null && !pGuardian.isEmpty()) ? pGuardian + " (Guardian)" : "" %></span>
                    </div>

                    <!-- Critical Allergies Checklist -->
                    <div class="critical-allergies-warnings">
                        <h3><i class="fas fa-biohazard"></i> Critical Drug / Allergen Warnings</h3>
                        <div class="warning-badges-list">
                            <%
                                boolean hasCriticalAllergies = false;
                                try {
                                    String query = "SELECT * FROM Allergies WHERE user_id = ? AND severity = 'Critical'";
                                    PreparedStatement psAll = con.prepareStatement(query);
                                    psAll.setString(1, pUsername);
                                    ResultSet rsAll = psAll.executeQuery();
                                    while (rsAll.next()) {
                                        hasCriticalAllergies = true;
                            %>
                                <div class="warning-alert-pill">
                                    <i class="fas fa-exclamation-triangle"></i>
                                    <strong><%= rsAll.getString("allergy_name") %></strong>: <%= rsAll.getString("description") %>
                                </div>
                            <%
                                    }
                                    rsAll.close();
                                    psAll.close();
                                } catch (Exception e) {
                                    e.printStackTrace();
                                }
                                if (!hasCriticalAllergies) {
                            %>
                                <div class="no-critical-allergies">
                                    <i class="fas fa-check-shield text-teal"></i> No critical (anaphylactic) drug allergen warnings registered.
                                </div>
                            <% } %>
                        </div>
                    </div>
                </div>

                <!-- Patient Profile Demographics Column -->
                <div class="patient-demographics-column">
                    <div style="display: flex; align-items: center; gap: 20px; margin-bottom: 24px; border-bottom: 2px solid var(--neutral-light); padding-bottom: 10px;">
                        <% if (pPhotoBase64 != null) { %>
                            <img src="<%= pPhotoBase64 %>" alt="Patient Photo" style="width: 64px; height: 64px; object-fit: cover; border-radius: 50%; border: 2px solid var(--primary);">
                        <% } else { %>
                            <div style="width: 64px; height: 64px; border-radius: 50%; background-color: var(--neutral-light); border: 2px dashed var(--border-color); display: flex; align-items: center; justify-content: center; color: #94a3b8; font-size: 24px;"><i class="fas fa-user"></i></div>
                        <% } %>
                        <h2 style="margin: 0; border: none; padding: 0;">Patient Clinical Passport</h2>
                    </div>
                    
                    <div class="doc-demographics-grid">
                        <div class="dem-field">
                            <label>Full Legal Name</label>
                            <span><%= pName %></span>
                        </div>
                        <div class="dem-field">
                            <label>Unique HealthSync ID</label>
                            <span><%= pUsername %></span>
                        </div>
                        <div class="dem-field">
                            <label>Date of Birth / Age</label>
                            <span><%= pDob %></span>
                        </div>
                        <div class="dem-field">
                            <label>Gender</label>
                            <span><%= pGender %></span>
                        </div>
                        <div class="dem-field">
                            <label>Contact Mobile No</label>
                            <span><%= pMobile %></span>
                        </div>
                        <div class="dem-field">
                            <label>Aadhaar Card Number</label>
                            <span><%= pAadhar %></span>
                        </div>
                        <div class="dem-field">
                            <label>Insurance Card Number</label>
                            <span><%= (pInsurance != null && !pInsurance.isEmpty()) ? pInsurance : "None Registered" %></span>
                        </div>
                        <div class="dem-field dem-field-full">
                            <label>Registered Address</label>
                            <span><%= pAddress %></span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- TAB MENU FOR DETAILED RECORDS -->
            <div class="tab-menu doc-tab-menu animate-fade-in">
              <button class="tab-button active" data-tab="allergic-info"><i class="fas fa-allergies"></i> All Allergies</button>
              <button class="tab-button" data-tab="medical-records"><i class="fas fa-file-medical"></i> Medical Assessments</button>
              <button class="tab-button" data-tab="prescriptions"><i class="fas fa-prescription-bottle-alt"></i> Prescription Log</button>
            </div>

            <!-- Allergies Tab -->
            <div id="allergic-info" class="tab-content active animate-fade-in">
                <div class="info-grid">
                    <%
                        try {
                            String query = "SELECT * FROM Allergies WHERE user_id = ?";
                            PreparedStatement psAll = con.prepareStatement(query);
                            psAll.setString(1, pUsername);
                            ResultSet rsAll = psAll.executeQuery();
                            boolean hasAll = false;
                            while (rsAll.next()) {
                                hasAll = true;
                                String severity = rsAll.getString("severity");
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
                    <div class="info-block card-allergy">
                        <div class="allergy-header">
                            <span class="severity-badge <%= severityClass %>">
                                <i class="fas <%= alertIcon %>"></i> <%= severity %>
                            </span>
                            <h4><%= rsAll.getString("allergy_name") %></h4>
                        </div>
                        <p class="allergy-description"><%= rsAll.getString("description") %></p>
                    </div>
                    <%
                            }
                            rsAll.close();
                            psAll.close();
                            if (!hasAll) {
                    %>
                        <div class="empty-state">
                            <i class="fas fa-shield-virus"></i>
                            <p>No allergies recorded for this patient.</p>
                        </div>
                    <%
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                    %>
                </div>
            </div>

            <!-- Medical Records Tab -->
            <div id="medical-records" class="tab-content animate-fade-in">
              <div class="tab-layout">
                <!-- Record Assessment Form (Left Column) -->
                <div class="form-panel">
                  <h3>Record Medical Assessment</h3>
                  <form action="SaveMedicalRecordServlet" method="POST" enctype="multipart/form-data">
                    <input type="hidden" name="userId" value="<%= pUsername %>">
                    <input type="hidden" name="redirectSource" value="doctor">
                    
                    <div class="form-group">
                      <label>Diagnosis / Assessment:</label>
                      <input type="text" name="diagnosis" placeholder="e.g. Acute Gastritis" required>
                    </div>
                    <div class="form-group">
                      <label>Attending Clinician:</label>
                      <input type="text" name="attending_doctor" value="<%= docName %>" readonly required style="background: #e2e8f0; cursor: not-allowed; color: #475569; font-weight: bold;">
                    </div>
                    <div class="form-group">
                      <label>Assessment Date:</label>
                      <input type="date" name="date" value="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>" required>
                    </div>
                    <div class="form-group">
                      <label>Clinical Notes / Findings:</label>
                      <textarea name="description" placeholder="Enter diagnostic observations, lab findings, or procedures..." rows="4" required></textarea>
                    </div>
                    <div class="form-group">
                      <label><i class="fas fa-paperclip"></i> Upload Lab Report / Case Sheet:</label>
                      <input type="file" name="case_sheet" accept="image/*,application/pdf">
                    </div>
                    
                    <button type="submit" class="submit-btn"><i class="fas fa-plus"></i> Save Clinical Record</button>
                  </form>
                </div>

                <!-- Historical Records Listing (Right Column) -->
                <div class="list-panel">
                  <div class="list-header">
                     <h3>Patient Historical Assessments</h3>
                  </div>
                  <div class="info-grid">
                    <%
                        try {
                            String query = "SELECT * FROM MedicalRecords WHERE user_id = ? ORDER BY date DESC";
                            PreparedStatement psRec = con.prepareStatement(query);
                            psRec.setString(1, pUsername);
                            ResultSet rsRec = psRec.executeQuery();
                            boolean hasRec = false;
                            while (rsRec.next()) {
                                hasRec = true;
                                byte[] fileBytes = rsRec.getBytes("case_sheet");
                                String fileType = rsRec.getString("case_sheet_type");
                                boolean isImage = (fileType != null && fileType.startsWith("image/"));
                    %>
                    <div class="info-block clinical-card animate-fade-in">
                        <div class="clinical-card-header">
                            <h4><%= rsRec.getString("diagnosis") %></h4>
                            <span class="clinical-date"><i class="fas fa-calendar-day"></i> <%= rsRec.getDate("date") %></span>
                        </div>
                        <p><strong><i class="fas fa-user-md text-teal"></i> Attending Doctor:</strong> <%= rsRec.getString("attending_doctor") %></p>
                        <p class="clinical-notes"><%= rsRec.getString("description") %></p>
                        
                        <%
                            if (fileBytes != null && fileBytes.length > 0) {
                                String base64File = Base64.getEncoder().encodeToString(fileBytes);
                                String dataUri = "data:" + fileType + ";base64," + base64File;
                        %>
                            <div class="document-section">
                                <label><i class="fas fa-paperclip"></i> Diagnostic Attachment:</label>
                                 <% if (isImage) { %>
                                     <div class="clinical-thumbnail" onclick="viewDocumentModal('<%= dataUri %>', 'image')">
                                         <img src="<%= dataUri %>" alt="Record Thumbnail">
                                         <div class="thumb-overlay"><i class="fas fa-eye"></i> Click to Preview</div>
                                     </div>
                                 <% } else { %>
                                     <div class="pdf-action-group" style="display: flex; gap: 10px; margin-top: 8px; flex-wrap: wrap;">
                                         <button type="button" class="btn-preview-pdf" onclick="viewDocumentModal('<%= dataUri %>', 'pdf')" style="background: var(--primary); color: white; border: none; padding: 8px 16px; border-radius: var(--border-radius-sm); font-size: 13px; font-weight: bold; cursor: pointer; display: inline-flex; align-items: center; gap: 6px; transition: var(--transition);"><i class="fas fa-eye"></i> Click to Preview</button>
                                         <a href="<%= dataUri %>" download="Record_<%= rsRec.getString("diagnosis") %>.pdf" class="btn-view-doc" style="padding: 8px 16px; font-size: 13px; margin: 0; display: inline-flex; align-items: center; gap: 6px;"><i class="fas fa-download"></i> Download PDF</a>
                                     </div>
                                 <% } %>
                            </div>
                        <% } %>
                    </div>
                    <%
                            }
                            rsRec.close();
                            psRec.close();
                            if (!hasRec) {
                    %>
                        <div class="empty-state">
                            <i class="fas fa-folder-open"></i>
                            <p>No historical medical records available.</p>
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

            <!-- Prescriptions Tab -->
            <div id="prescriptions" class="tab-content animate-fade-in">
              <div class="tab-layout">
                <!-- Write Prescription Form (Left Column) -->
                <div class="form-panel">
                  <h3>Write New Prescription</h3>
                  <form action="SavePrescriptionServlet" method="POST" enctype="multipart/form-data">
                    <input type="hidden" name="userId" value="<%= pUsername %>">
                    <input type="hidden" name="redirectSource" value="doctor">
                    
                    <div class="form-group">
                      <label>Diagnosis / Indication:</label>
                      <input type="text" name="diagnosis" placeholder="e.g. Acute Pharyngitis" required>
                    </div>
                    <div class="form-group">
                      <label>Prescribed By:</label>
                      <input type="text" name="prescribed_by" value="<%= docName %>" readonly required style="background: #e2e8f0; cursor: not-allowed; color: #475569; font-weight: bold;">
                    </div>
                    <div class="form-group">
                      <label>Prescription Date:</label>
                      <input type="date" name="prescribed_date" value="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>" required>
                    </div>
                    <div class="form-group">
                      <label>Medicines & Individual Quantities:</label>
                      <textarea name="medicines" placeholder="e.g. Amoxicillin 500mg (15 Tablets) - 1 tablet three times daily after meals" rows="4" required></textarea>
                    </div>
                    <div class="form-group">
                      <label>Total Course Duration:</label>
                      <input type="text" name="quantity" placeholder="e.g. 5 Days / 1 Week" required>
                    </div>
                    <div class="form-group">
                      <label><i class="fas fa-paperclip"></i> Attach Signed Prescription File:</label>
                      <input type="file" name="prescription_file" accept="image/*,application/pdf">
                    </div>
                    
                    <button type="submit" class="submit-btn"><i class="fas fa-plus"></i> Save & Log Prescription</button>
                  </form>
                </div>

                <!-- Historical Prescription Listing (Right Column) -->
                <div class="list-panel">
                  <div class="list-header">
                     <h3>Patient Prescription History</h3>
                  </div>
                  <div class="info-grid">
                    <%
                        try {
                            String query = "SELECT * FROM Prescriptions WHERE user_id = ? ORDER BY prescribed_date DESC";
                            PreparedStatement psPres = con.prepareStatement(query);
                            psPres.setString(1, pUsername);
                            ResultSet rsPres = psPres.executeQuery();
                            boolean hasPres = false;
                            while (rsPres.next()) {
                                hasPres = true;
                                byte[] fileBytes = rsPres.getBytes("prescription_file");
                                String fileType = rsPres.getString("file_type");
                                boolean isImage = (fileType != null && fileType.startsWith("image/"));
                    %>
                    <div class="info-block clinical-card animate-fade-in">
                        <div class="clinical-card-header">
                            <h4><%= rsPres.getString("diagnosis") %></h4>
                            <span class="clinical-date"><i class="fas fa-calendar-day"></i> <%= rsPres.getDate("prescribed_date") %></span>
                        </div>
                        <p><strong><i class="fas fa-user-md text-teal"></i> Prescribed By:</strong> <%= rsPres.getString("prescribed_by") %></p>
                        <p><strong><i class="fas fa-pills text-teal"></i> Medication Details:</strong></p>
                        <p class="medication-details"><%= rsPres.getString("medicines") %></p>
                        <p><strong><i class="fas fa-prescription-bottle text-teal"></i> Total Course Duration:</strong> <%= rsPres.getString("quantity") %></p>

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
                                        <a href="<%= dataUri %>" download="Prescription_<%= rsPres.getString("diagnosis") %>.pdf" class="btn-view-doc" style="padding: 8px 16px; font-size: 13px; margin: 0; display: inline-flex; align-items: center; gap: 6px;"><i class="fas fa-download"></i> Download PDF</a>
                                    </div>
                                <% } %>
                            </div>
                        <% } %>
                    </div>
                    <%
                            }
                            rsPres.close();
                            psPres.close();
                            if (!hasPres) {
                    %>
                        <div class="empty-state">
                            <i class="fas fa-capsules"></i>
                            <p>No prescriptions recorded for this patient.</p>
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

        <% } else { %>
            
            <!-- Patient Not Found Error State -->
            <div class="doc-error-banner animate-fade-in">
                <i class="fas fa-user-slash"></i>
                <h3>Patient Record Not Found</h3>
                <p>We could not find any active patient matches for "<strong><%= searchQuery %></strong>" in our database. Please confirm the 12-digit Health ID or Aadhaar Card number and try again.</p>
            </div>
            
        <% } %>
    <% } else { %>
        
        <!-- Welcome Screen before Search -->
        <div class="doc-welcome-state">
            <i class="fas fa-clinic-medical"></i>
            <h3>Awaiting Patient Search Query...</h3>
            <p>Please enter the patient's ID above to pull their medical history. Keep this screen open for immediate reference during medical interventions.</p>
        </div>
        
    <% } %>

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
  </div>

  <script src="dashboard.js"></script>
  <script>
    let html5QrCode = null;

    function toggleQrScanner() {
        const container = document.getElementById('qr-scanner-container');
        if (container.style.display === 'none') {
            container.style.display = 'block';
            startQrScanner();
        } else {
            stopQrScanner();
        }
    }

    function startQrScanner() {
        html5QrCode = new Html5Qrcode("reader");
        const qrCodeSuccessCallback = (decodedText, decodedResult) => {
            console.log("QR Code Decoded: " + decodedText);
            stopQrScanner();
            
            // If scanner decoded a direct search link, redirect browser directly to instantly load patient
            if (decodedText.includes("doctor_dash.jsp?searchQuery=")) {
                window.location.href = decodedText;
            } else {
                // If it is a raw 12-digit patient ID or Aadhaar, set input field and auto-submit search
                const searchInput = document.getElementById('search-input');
                if (searchInput) {
                    searchInput.value = decodedText;
                    searchInput.form.submit();
                }
            }
        };
        
        const config = { fps: 10, qrbox: { width: 250, height: 250 } };
        
        // Start camera feed targeting standard back-facing environment lens
        html5QrCode.start({ facingMode: "environment" }, config, qrCodeSuccessCallback)
            .catch(err => {
                console.error("Camera startup failed: ", err);
                alert("Unable to access camera feed. Please check browser permissions.");
                stopQrScanner();
            });
    }

    function stopQrScanner() {
        const container = document.getElementById('qr-scanner-container');
        container.style.display = 'none';
        if (html5QrCode) {
            html5QrCode.stop().then(() => {
                html5QrCode = null;
            }).catch(err => {
                console.error("Failed to stop scanner cleanly: ", err);
            });
        }
    }
  </script>
</body>
</html>
