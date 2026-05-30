# HealthSync 🏥 

**Live Deployment:** [https://healthsync-duld.onrender.com/healthsync/index.jsp](https://healthsync-duld.onrender.com/healthsync/index.jsp)

HealthSync is a premium, high-fidelity Java EE (JSP/Servlet) based Personal Health Record (PHR) and emergency clinical system. It provides a secure, cohesive platform for patients to manage their profiles, vitals, medical records, and prescriptions while equipping doctors with advanced diagnostic tools, patient search indexers, and an integrated EMT camera QR code scanner.

---

## 🌟 Key Features

### 👤 Patient Portal (`dash.jsp`)
*   **Emergency Digital ID Card**: Generates a downloadable emergency digital identity card embedded with key clinical vitals, blood groups, emergency contacts, and a unique QR access code.
*   **Vitals Tracking Panel**: Logs and monitors patient stats including Blood Pressure, Heart Rate, SpO2, Temperature, and Weight.
*   **Interactive Geolocation Health Facility Locator**: An embedded responsive Leaflet.js map finding emergency centers, clinics, and nearest hospitals dynamically.
*   **Structured Medical Record Vault**: Supports file attachment uploads (PDFs and Images) complete with a dual Action panel: direct **Download** or interactive **Click to Preview** lightbox modals utilizing embedded sandbox iframe triggers.
*   **Allergen Tag Panel**: Custom dynamic tagging section for food, drug, and environmental allergens with severity levels.
*   **Prescription History**: Lists active prescription regimes mapped to specific medicine quantities and complete course durations.
*   **Address Management**: Restructured address profile components including safeguards that display `"Not Provided"` instead of `"null"` values for blank user inputs.

### 🥼 Doctor & Clinical Dashboard (`doctor_dash.jsp`)
*   **Patient Index Search**: Instant lookups by Patient ID, Name, or Phone Number to view complete patient histories.
*   **EMT Camera QR Code Scanner**: Integrated HTML5 QR code video scanner. EMTs can scan a patient's physical Emergency ID card to instantly load their life-saving profile details.
*   **Prescription Writing Engine**: Structured tool that allows doctors to select medicines, set individual dosages/quantities, and set the total course duration.
*   **Diagnosis and Records Upload**: Log consultations, diagnosis notes, and instantly bind PDF/image attachments directly to the patient's record.

### 🔐 Unified Authentication Gateway (`registration.jsp` & `login.jsp`)
*   **Role-Based Security**: Complete multi-tab user logins and dynamic sign-up panels for both patients and healthcare practitioners.
*   **Tab Deep-Linking**: Routing tags automatically pre-select registration workflows (e.g. visiting `/registration.jsp?role=doctor` opens the doctor tab directly).

---

## 🛠️ Technology Stack

*   **Frontend**: JSP (JavaServer Pages), Vanilla CSS3 (Custom design system featuring dark glassmorphism, HSL tailwinds, and premium animations), Vanilla JavaScript (ES6+), Leaflet Map API, HTML5 QR-Code Library.
*   **Backend**: Java Servlets (Java EE), JDBC (Java Database Connectivity).
*   **Database**: MySQL Server (v8.0+).
*   **Server Container**: Apache Tomcat v9.0+.

---

## 📂 Project Directory Structure

```text
HealthSync/
├── assets/
│   ├── style.css              # Custom stylesheet for the Landing page
│   ├── style1.css             # Layouts for signup, login, and info views
│   └── style3.css             # Main stylesheet for Patient & Doctor dashboards
├── servlet/                   # Java Servlet Source Files
│   ├── LoginServlet.java
│   ├── RegistrationServlet.java
│   ├── SaveMedicalRecordServlet.java
│   ├── SavePrescriptionServlet.java
│   └── SaveProfileServlet.java
├── image/                     # Team and Layout images
│   ├── amey.jpeg
│   ├── anand.jpeg
│   ├── atharva.jpeg
│   ├── shrey.jpeg
│   └── hos.jpg
├── WEB-INF/
│   ├── web.xml                # Servlet configuration mappings
│   ├── classes/               # Compiled JVM classes
│   └── lib/                   # Local Tomcat dependencies
├── lib/                       # Classpath libraries for local builds
│   ├── mysql-connector-j-9.1.0.jar
│   └── servlet-api.jar
├── build/                     # Local workspace class compilation files
├── schema.sql                 # SQL DB setup instructions and data seeds
├── index.jsp                  # Landing page
├── login.jsp                  # Authentication UI
├── logout.jsp                 # Session termination
├── about.jsp                  # Information page
├── contact.jsp                # Developer/Team profiles
├── registration.jsp           # Role-based registry forms
├── registration_success.jsp   # Post-registry success page
├── dash.jsp                   # Patient platform
├── doctor_dash.jsp            # Doctor/Clinical platform
└── saveAllergy.jsp            # Allergy scriptlet controller
```

---

## 💾 Database Configuration

The application operates on a relational MySQL structure. Set up the schema using [schema.sql](file:///Users/ameypatil/Desktop/HealthSync/schema.sql):

```bash
mysql -u your_username -p < schema.sql
```

### Core Schema Tables:
1.  **`patients`**: Tracks detailed profile info, contact data, and discrete residential address details.
2.  **`doctors`**: Tracks professional credentials, license keys, and clinic locations.
3.  **`vitals`**: Captures patient clinical stats historically.
4.  **`allergies`**: Maps specific environment and drug allergens with severity scales.
5.  **`medical_records`**: Maintains logs of diagnoses, consultation details, and binary documents.
6.  **`prescriptions`**: Tracks medicine courses, detailed dosages, and complete treatment durations.

---

## 🚀 Setup & Installation Instructions

### Prerequisites
*   Java Development Kit (JDK 8 or above).
*   Apache Tomcat Server (v9.0 is highly recommended).
*   MySQL Server (v8.0 or above).

### Step 1: Database Setup
Make sure MySQL is running, then initialize the tables:
```sql
CREATE DATABASE newhealth;
USE newhealth;
-- Run the queries inside schema.sql
```

### Step 2: Set up Apache Tomcat Context
Copy the compiled war file or deploy the directory into Tomcat's `webapps` path:
```bash
cp -r /Users/ameypatil/Desktop/HealthSync /usr/local/tomcat/webapps/newhealth
```

### Step 3: Run the Web App
1. Start the Tomcat Server:
   ```bash
   sh /usr/local/tomcat/bin/startup.sh
   ```
2. Navigate to the landing page at `http://localhost:8080/newhealth/index.jsp`.

---

## 👥 Developers / Contributors

Meet the development team driving the HealthSync platform:

*   **Amey Patil**
*   **Anand Patel** 
*   **Atharva Rajput** 
*   **Shrey Rane** 
