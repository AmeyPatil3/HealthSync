<%@ page contentType="text/html;charset=UTF-8" language="java" %>
  <!DOCTYPE html>
  <html lang="en">

  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>HealthSync - Contact & Support</title>
    <link rel="stylesheet" href="./assets/style1.css?v=1.0.1">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link
      href="https://fonts.googleapis.com/css2?family=Lato:wght@400;700&family=Montserrat:wght@500;700&family=Outfit:wght@400;600;800&display=swap"
      rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  </head>

  <body>

    <!-- Header / Navbar -->
    <header>
      <nav>
        <div class="logo">
          <h3>HealthSync</h3>
        </div>
        <ul class="nav-links">
          <li><a href="index.jsp">Home</a></li>
          <li><a href="login.jsp">Login</a></li>
          <li><a href="about.jsp">About</a></li>
          <li><a href="contact.jsp" class="active">Contact</a></li>
        </ul>
      </nav>
    </header>

    <!-- Contact Us Section -->
    <section class="contact-us-section animate-fade-in">
      <div class="contact-container">
        <h1>Contact Our Team</h1>
        <p class="contact-lead">HealthSync is designed and maintained by a dedicated group of developers working to
          improve clinical workflows.</p>

        <div class="team-container">
          <!-- Team Member 1 -->
          <div class="team-member animate-hover">
            <div class="photo-wrapper">
              <img src="./image/anand.jpeg" alt="Anand Patel" class="team-photo"
                style="width: 100px; height: 100px; border-radius: 50%; object-fit: cover; border: 3px solid #f1f5f9; box-shadow: 0 4px 10px rgba(0,0,0,0.06);">
            </div>
            <h2>Anand Patel</h2>
            <p class="member-email"><i class="fas fa-envelope text-teal"></i> <a
                href="mailto:anand.patel@somaiya.edu">anand.patel@somaiya.edu</a></p>
            <div class="social-icons">
              <a href="https://www.instagram.com/anand.patel25/" target="_blank"><i class="fab fa-instagram"></i></a>
              <a href="https://www.linkedin.com/in/anand-patel-29963b3b0/" target="_blank"><i
                  class="fab fa-linkedin"></i></a>
              <a href="#" target="_blank"><i class="fab fa-github"></i></a>
            </div>
          </div>

          <!-- Team Member 2 -->
          <div class="team-member animate-hover">
            <div class="photo-wrapper">
              <img src="./image/amey.jpeg" alt="Amey Patil" class="team-photo"
                style="width: 100px; height: 100px; border-radius: 50%; object-fit: cover; border: 3px solid #f1f5f9; box-shadow: 0 4px 10px rgba(0,0,0,0.06);">
            </div>
            <h2>Amey Patil</h2>
            <p class="member-email"><i class="fas fa-envelope text-teal"></i> <a
                href="mailto:amey.patil@somaiya.edu">amey.patil@somaiya.edu</a></p>
            <div class="social-icons">
              <a href="https://www.instagram.com/amey_patil_05/" target="_blank"><i class="fab fa-instagram"></i></a>
              <a href="https://www.linkedin.com/in/ameypatil3" target="_blank"><i class="fab fa-linkedin"></i></a>
              <a href="https://github.com/AmeyPatil3" target="_blank"><i class="fab fa-github"></i></a>
            </div>
          </div>

          <!-- Team Member 3 -->
          <div class="team-member animate-hover">
            <div class="photo-wrapper">
              <img src="./image/atharva.jpeg" alt="Atharva Rajput" class="team-photo"
                style="width: 100px; height: 100px; border-radius: 50%; object-fit: cover; border: 3px solid #f1f5f9; box-shadow: 0 4px 10px rgba(0,0,0,0.06);">
            </div>
            <h2>Atharva Rajput</h2>
            <p class="member-email"><i class="fas fa-envelope text-teal"></i> <a
                href="mailto:atharva.rajput@somaiya.edu">atharva.rajput@somaiya.edu</a></p>
            <div class="social-icons">
              <a href="https://www.instagram.com/atharvarajput20/" target="_blank"><i class="fab fa-instagram"></i></a>
              <a href="#" target="_blank"><i class="fab fa-linkedin"></i></a>
              <a href="#" target="_blank"><i class="fab fa-github"></i></a>
            </div>
          </div>

          <!-- Team Member 4 -->
          <div class="team-member animate-hover">
            <div class="photo-wrapper">
              <img src="./image/shrey.jpeg" alt="Shrey Rane" class="team-photo"
                style="width: 100px; height: 100px; border-radius: 50%; object-fit: cover; border: 3px solid #f1f5f9; box-shadow: 0 4px 10px rgba(0,0,0,0.06);">
            </div>
            <h2>Shrey Rane</h2>
            <p class="member-email"><i class="fas fa-envelope text-teal"></i> <a
                href="mailto:shrey.r@somaiya.edu">shrey.r@somaiya.edu</a></p>
            <div class="social-icons">
              <a href="https://www.instagram.com/shrey_rane911/" target="_blank"><i class="fab fa-instagram"></i></a>
              <a href="https://www.linkedin.com/in/shrey-rane-65a5241b9" target="_blank"><i
                  class="fab fa-linkedin"></i></a>
              <a href="https://github.com/ShreyRane" target="_blank"><i class="fab fa-github"></i></a>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- Feedback Section -->
    <div class="feedback-container">
      <h2>We Value Your Feedback</h2>

      <%
        if (request.getMethod().equals("POST")) {
            String fbName = request.getParameter("name");
            String fbEmail = request.getParameter("email");
            String fbMsg = request.getParameter("message");
            if (fbName != null && fbEmail != null && fbMsg != null) {
      %>
        <div class="success-banner feedback-success animate-fade-in">
          <i class="fas fa-check-circle"></i> Thank you, <strong><%= fbName %></strong>! Your feedback has been successfully received. We will get in touch with you shortly.
        </div>
      <%
            }
        }
      %>

          <form action="contact.jsp" method="POST" class="feedback-form">
            <div class="form-group">
              <label for="name">Your Name:</label>
              <input type="text" id="name" name="name" placeholder="Enter Full Name" required>
            </div>

            <div class="form-group">
              <label for="email">Your Email Address:</label>
              <input type="email" id="email" name="email" placeholder="Enter Email Address" required>
            </div>

            <div class="form-group">
              <label for="message">Your Message / Feedback:</label>
              <textarea id="message" name="message" rows="5" placeholder="Share your experience or ask questions..."
                required></textarea>
            </div>

            <button type="submit" class="submit-btn"><i class="fas fa-paper-plane"></i> Submit Feedback</button>
          </form>
    </div>

    <!-- Footer -->
    <footer>
      <div class="footer-content">
        <div class="footer-logo">HealthSync</div>
        <p>&copy; 2026 HealthSync. All rights reserved.</p>
      </div>
    </footer>

  </body>

  </html>