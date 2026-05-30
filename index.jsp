<%@ page contentType="text/html;charset=UTF-8" language="java" %>
  <!DOCTYPE html>
  <html lang="en">

  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>HealthSync - Sync Your Data, Empower Your Health</title>
    <link rel="stylesheet" href="./assets/style.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link
      href="https://fonts.googleapis.com/css2?family=Lato:wght@400;700&family=Montserrat:wght@500;700&family=Outfit:wght@400;600;800&display=swap"
      rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  </head>

  <body>

    <!-- Header / Navbar -->
    <header class="home-header">
      <nav>
        <div class="logo">
          <i class="fas fa-heartbeat text-teal animate-pulse"></i>
          <h3>HealthSync</h3>
        </div>
        <ul class="nav-links">
          <li><a href="#home">Home</a></li>
          <li><a href="#features">Features</a></li>
          <li><a href="about.jsp">About</a></li>
          <li><a href="contact.jsp">Contact</a></li>
        </ul>
        <a href="login.jsp" class="login-btn-nav"><i class="fas fa-sign-in-alt"></i> Login Portal</a>
      </nav>
    </header>

    <!-- Hero Section -->
    <section class="hero-section" id="home">
      <div class="hero-overlay"></div>
      <div class="hero-content">
        <span class="hero-eyebrow"><i class="fas fa-shield-alt"></i> Secure Health Record</span>
        <h1>Sync Your Data,<br><span class="text-teal">Empower Your Health</span></h1>
        <p class="hero-lead">Secure, instant, and real-time medical profile access. Built to assist emergency responders
          and clinicians when every second count.</p>
        <div class="hero-actions">
          <a href="login.jsp" class="cta-btn primary-cta"><i class="fas fa-user-circle"></i> Access Dashboard</a>
          <a href="about.jsp" class="cta-btn secondary-cta"><i class="fas fa-info-circle"></i> Learn More</a>
        </div>
      </div>
    </section>

    <!-- Features Section -->
    <section class="features-section" id="features">
      <div class="section-title">
        <h2>Intelligent Medical Records Management</h2>
        <p>A unified digital ecosystem engineered to bridge the clinical communication gap.</p>
      </div>
      <div class="features-grid">
        <div class="feature-card animate-hover">
          <div class="feature-icon bg-soft-teal">
            <i class="fas fa-notes-medical"></i>
          </div>
          <h3>Instant Emergency Search</h3>
          <p>Certified doctors can pull vital blood groups, critical drug allergies, and emergency contact details in
            seconds during active medical interventions.</p>
        </div>
        <div class="feature-card animate-hover">
          <div class="feature-icon bg-soft-blue">
            <i class="fas fa-lock"></i>
          </div>
          <h3>Advanced Data Security</h3>
          <p>Your sensitive personal medical records are encrypted, isolated, and stored securely with industry-standard
            web safety practices.</p>
        </div>
        <div class="feature-card animate-hover">
          <div class="feature-icon bg-soft-purple">
            <i class="fas fa-sync-alt"></i>
          </div>
          <h3>Binary Vault Storage</h3>
          <p>Attach clinical diagnostic case sheets and prescription documents directly into secure database BLOB
            vaults, making them downloadable anywhere.</p>
        </div>
      </div>
    </section>

    <!-- CTA Banner Section -->
    <section class="action-banner-section">
      <div class="action-banner-content">
        <h2>Are You a Registered Medical Practitioner?</h2>
        <p>Access our high-priority emergency lookup suite to view patient records, verify drug allergen warnings, and
          contact guardians instantly.</p>
        <a href="registration.jsp?role=doctor" class="cta-btn register-cta"><i class="fas fa-user-md"></i> Register
          Doctor Credentials</a>
      </div>
    </section>

    <!-- Footer -->
    <footer>
      <div class="footer-content">
        <div class="footer-logo">HealthSync</div>
        <p>Seamlessly bridging patients, emergency personnel, and medical practitioners.</p>
        <p class="copyright">&copy; 2026 HealthSync. All rights reserved.</p>
        <ul class="footer-links-grid">
          <li><a href="about.jsp">About Project</a></li>
          <li><a href="contact.jsp">Support & Feedback</a></li>
        </ul>
      </div>
    </footer>

  </body>

  </html>