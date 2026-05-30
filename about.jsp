<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>HealthSync - About the Initiative</title>
  <link rel="stylesheet" href="./assets/style1.css">
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Lato:wght@400;700&family=Montserrat:wght@500;700&family=Outfit:wght@400;600;800&display=swap" rel="stylesheet">
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
        <li><a href="about.jsp" class="active">About</a></li>
        <li><a href="contact.jsp">Contact</a></li>
      </ul>
    </nav>
  </header>

  <!-- About Section -->
  <section class="about-section">
    <div class="about-container animate-fade-in">
      <h1>About Project HealthSync</h1>
      <p class="about-lead"><strong>Project HealthSync (Sync Your Data, Empower Your Health)</strong> is an emergency-critical initiative focused on providing fast and safe medical care by building a secure, easily queryable repository of user-managed medical data.</p>

      <div class="about-card">
        <h2><i class="fas fa-star text-teal"></i> Major Features</h2>
        <ul class="about-features-list">
          <li>
            <i class="fas fa-database text-teal"></i>
            <div>
              <strong>Structured Demographics Vault:</strong>
              <p>Consolidates vital blood type, insurance parameters, guardian mobile details, and medical identifiers in one location.</p>
            </div>
          </li>
          <li>
            <i class="fas fa-exclamation-triangle text-coral"></i>
            <div>
              <strong>High-Priority Allergen Shield:</strong>
              <p>Highlights severe allergies (e.g., Penicillin, Peanuts) in bold, pulsing visual alerts to prevent fatal clinical oversights in ERs.</p>
            </div>
          </li>
          <li>
            <i class="fas fa-file-prescription text-teal"></i>
            <div>
              <strong>Binary Records Repository:</strong>
              <p>Stores patient case sheets, scan reports, and prescription histories directly as secure database blobs for high availability.</p>
            </div>
          </li>
        </ul>
      </div>

      <div class="about-card">
        <h2><i class="fas fa-briefcase-medical text-teal"></i> Key Medical Use Cases</h2>
        <ul class="standard-list">
          <li><strong>Emergency Response Acceleration:</strong> Eliminates time wasted running preliminary diagnostic tests (like blood typing) in severe trauma situations.</li>
          <li><strong>Allergen Prevention:</strong> Prevents administration of anaphylaxis-triggering medications by providing doctors with instant lookup cards.</li>
          <li><strong>Digital Medical Passport:</strong> Serves as an authorized, easily downloadable repository of vaccination reports, travel medical clearance forms, and test sheets.</li>
        </ul>
      </div>

      <div class="about-card serve-card">
        <h2><i class="fas fa-users-cog text-teal"></i> Who We Serve</h2>
        <p>Our goal is to assist and empower healthcare providers by lifting the intense time constraints experienced in emergency rooms and clinics. HealthSync supports:</p>
        <div class="serve-grid">
            <div class="serve-pill"><i class="fas fa-user-md"></i> Clinical Doctors</div>
            <div class="serve-pill"><i class="fas fa-ambulance"></i> EMTs & Responders</div>
            <div class="serve-pill"><i class="fas fa-hospital-user"></i> Patients & Families</div>
        </div>
      </div>
    </div>
  </section>

  <!-- Footer -->
  <footer>
    <div class="footer-content">
      <div class="footer-logo">HealthSync</div>
      <p>&copy; 2026 HealthSync. All rights reserved.</p>
    </div>
  </footer>

</body>
</html>
