<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>HealthSync - Registration</title>
    <link rel="stylesheet" href="./assets/style1.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Lato:wght@400;700&family=Montserrat:wght@500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>

    <!-- Header / Navbar -->
    <header>
        <nav>
            <div class="logo"><h3>HealthSync</h3></div>
            <ul class="nav-links">
                <li><a href="index.jsp">Home</a></li>
                <li><a href="login.jsp">Login</a></li>
                <li><a href="about.jsp">About</a></li>
                <li><a href="contact.jsp">Contact</a></li>
            </ul>
        </nav>
    </header>

    <!-- Registration Section -->
    <section class="registration-section">
        <div class="registration-container animate-fade-in">
            <h1>Create an Account</h1>
            
            <%
                String error = request.getParameter("error");
                if (error != null) {
            %>
                <div class="error-banner">
                    <i class="fas fa-exclamation-circle"></i>
                    <%= error %>
                </div>
            <%
                }
            %>

            <!-- Tab Switcher for User Type -->
            <div class="registration-tabs">
                <button type="button" class="reg-tab-btn active" onclick="switchTab('patient')">
                    <i class="fas fa-user-injured"></i> Patient Registration
                </button>
                <button type="button" class="reg-tab-btn" onclick="switchTab('doctor')">
                    <i class="fas fa-user-md"></i> Doctor Registration
                </button>
            </div>

            <!-- Patient Form -->
            <form id="patient-form" class="user-form" action="RegistrationServlet" method="POST" enctype="multipart/form-data" style="display: block;">
                <h2>Patient Details</h2>
                <input type="hidden" name="user_type" value="patient">

                <div class="input-row">
                    <div class="form-group-half">
                        <label for="p-username"><i class="fas fa-id-card-alt"></i> Unique Health ID (12-Digit)</label>
                        <input type="text" id="p-username" name="username" class="read-only-field" readonly required>
                    </div>
                    <div class="form-group-half">
                        <label for="p-aadhaar"><i class="fas fa-fingerprint"></i> Aadhaar Card Number</label>
                        <input type="text" id="p-aadhaar" name="aadhaar" placeholder="xxxx-xxxx-xxxx" required>
                    </div>
                </div>

                <div class="input-row">
                    <div class="form-group-third">
                        <label for="p-first-name">First Name</label>
                        <input type="text" id="p-first-name" name="first_name" required>
                    </div>
                    <div class="form-group-third">
                        <label for="p-middle-name">Middle Name</label>
                        <input type="text" id="p-middle-name" name="middle_name">
                    </div>
                    <div class="form-group-third">
                        <label for="p-last-name">Last Name</label>
                        <input type="text" id="p-last-name" name="last_name" required>
                    </div>
                </div>

                <div class="input-row">
                    <div class="form-group-third">
                        <label for="p-dob">Date of Birth</label>
                        <input type="date" id="p-dob" name="dob" required>
                    </div>
                    <div class="form-group-third">
                        <label for="p-gender">Gender</label>
                        <select id="p-gender" name="gender" required>
                            <option value="Male">Male</option>
                            <option value="Female">Female</option>
                            <option value="Other">Other</option>
                        </select>
                    </div>
                    <div class="form-group-third">
                        <label for="p-mobile">Mobile Number</label>
                        <input type="tel" id="p-mobile" name="mobile" placeholder="Enter Mobile Number" required>
                    </div>
                </div>

                <label><i class="fas fa-map-marker-alt"></i> Address Information</label>
                <div class="address-grid">
                    <input type="text" name="street" placeholder="Street Address" required>
                    <input type="text" name="city" placeholder="City" required>
                    <input type="text" name="state" placeholder="State" required>
                    <input type="text" name="zipcode" placeholder="Zip Code" required>
                </div>

                <div class="input-row">
                    <div class="form-group-full">
                        <label for="p-profile-photo"><i class="fas fa-camera"></i> Profile Picture (Optional)</label>
                        <input type="file" id="p-profile-photo" name="profile_photo" accept="image/*" style="width: 100%; padding: 10px; background: var(--neutral-light); border: 1.5px dashed var(--border-color); border-radius: var(--border-radius-sm); font-family: inherit;">
                    </div>
                </div>

                <div class="input-row">
                    <div class="form-group-half">
                        <label for="p-password"><i class="fas fa-lock"></i> Create Password</label>
                        <input type="password" id="p-password" name="password" required>
                    </div>
                    <div class="form-group-half">
                        <label for="p-confirm-password"><i class="fas fa-lock"></i> Confirm Password</label>
                        <input type="password" id="p-confirm-password" name="confirm-password" required>
                    </div>
                </div>

                <button type="submit" class="submit-btn"><i class="fas fa-user-plus"></i> Register as Patient</button>
            </form>

            <!-- Doctor Form -->
            <form id="doctor-form" class="user-form" action="RegistrationServlet" method="POST" enctype="multipart/form-data" style="display: none;">
                <h2>Medical Professional Details</h2>
                <input type="hidden" name="user_type" value="doctor">

                <div class="input-row">
                    <div class="form-group-half">
                        <label for="d-username"><i class="fas fa-id-badge"></i> Desired Username</label>
                        <input type="text" id="d-username" name="username" placeholder="e.g. drjohndoe" required>
                    </div>
                    <div class="form-group-half">
                        <label for="d-nmrid"><i class="fas fa-file-medical-alt"></i> National Medical Register (NMR) ID</label>
                        <input type="text" id="d-nmrid" name="nmr_id" placeholder="e.g. NMR-123456" required>
                    </div>
                </div>

                <div class="input-row">
                    <div class="form-group-third">
                        <label for="d-first-name">First Name</label>
                        <input type="text" id="d-first-name" name="first_name" required>
                    </div>
                    <div class="form-group-third">
                        <label for="d-middle-name">Middle Name</label>
                        <input type="text" id="d-middle-name" name="middle_name">
                    </div>
                    <div class="form-group-third">
                        <label for="d-last-name">Last Name</label>
                        <input type="text" id="d-last-name" name="last_name" required>
                    </div>
                </div>

                <div class="input-row">
                    <div class="form-group-third">
                        <label for="d-dob">Date of Birth</label>
                        <input type="date" id="d-dob" name="dob" required>
                    </div>
                    <div class="form-group-third">
                        <label for="d-gender">Gender</label>
                        <select id="d-gender" name="gender" required>
                            <option value="Male">Male</option>
                            <option value="Female">Female</option>
                            <option value="Other">Other</option>
                        </select>
                    </div>
                    <div class="form-group-third">
                        <label for="d-mobile">Mobile Number</label>
                        <input type="tel" id="d-mobile" name="mobile" placeholder="Enter Mobile Number" required>
                    </div>
                </div>

                <div class="input-row">
                    <div class="form-group-full">
                        <label for="d-aadhaar"><i class="fas fa-fingerprint"></i> Aadhaar Card Number</label>
                        <input type="text" id="d-aadhaar" name="aadhaar" placeholder="xxxx-xxxx-xxxx" required>
                    </div>
                </div>

                <div class="input-row">
                    <div class="form-group-full">
                        <label for="d-profile-photo"><i class="fas fa-camera"></i> Profile Picture (Optional)</label>
                        <input type="file" id="d-profile-photo" name="profile_photo" accept="image/*" style="width: 100%; padding: 10px; background: var(--neutral-light); border: 1.5px dashed var(--border-color); border-radius: var(--border-radius-sm); font-family: inherit;">
                    </div>
                </div>

                <div class="input-row">
                    <div class="form-group-half">
                        <label for="d-password"><i class="fas fa-lock"></i> Create Password</label>
                        <input type="password" id="d-password" name="password" required>
                    </div>
                    <div class="form-group-half">
                        <label for="d-confirm-password"><i class="fas fa-lock"></i> Confirm Password</label>
                        <input type="password" id="d-confirm-password" name="confirm-password" required>
                    </div>
                </div>

                <button type="submit" class="submit-btn"><i class="fas fa-user-md"></i> Register as Doctor</button>
            </form>
        </div>
    </section>

    <!-- Footer -->
    <footer>
        <div class="footer-content">
            <div class="footer-logo">HealthSync</div>
            <p>&copy; 2026 HealthSync. All rights reserved.</p>
        </div>
    </footer>

    <script>
        // Form switching functionality
        function switchTab(role) {
            const tabs = document.querySelectorAll('.reg-tab-btn');
            const patientForm = document.getElementById('patient-form');
            const doctorForm = document.getElementById('doctor-form');

            if (role === 'patient') {
                tabs[0].classList.add('active');
                tabs[1].classList.remove('active');
                patientForm.style.display = 'block';
                doctorForm.style.display = 'none';
            } else {
                tabs[1].classList.add('active');
                tabs[0].classList.remove('active');
                doctorForm.style.display = 'block';
                patientForm.style.display = 'none';
            }
        }

        // Generate unique 12-digit ID for Patient
        function generateUniqueId() {
            let uniqueId = "";
            for (let i = 0; i < 12; i++) {
                uniqueId += Math.floor(Math.random() * 10);
            }
            return uniqueId;
        }

        // Auto-populate the 12-digit patient HealthSync ID
        window.onload = function () {
            document.getElementById('p-username').value = generateUniqueId();
            
            // Check if URL specifies doctor registration tab
            const urlParams = new URLSearchParams(window.location.search);
            if (urlParams.get('role') === 'doctor') {
                switchTab('doctor');
            }
        };

        // Validate password matches on Patient Form
        document.getElementById('patient-form').onsubmit = function() {
            var password = document.getElementById('p-password').value;
            var confirmPassword = document.getElementById('p-confirm-password').value;
            if (password != confirmPassword) {
                alert('Passwords do not match!');
                return false;
            }
            return true;
        };

        // Validate password matches on Doctor Form
        document.getElementById('doctor-form').onsubmit = function() {
            var password = document.getElementById('d-password').value;
            var confirmPassword = document.getElementById('d-confirm-password').value;
            if (password != confirmPassword) {
                alert('Passwords do not match!');
                return false;
            }
            return true;
        };
    </script>

</body>
</html>
