<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>HealthSync - Login</title>
    <link rel="stylesheet" href="./assets/style1.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Lato:wght@400;700&family=Montserrat:wght@500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <header>
        <nav>
          <div class="logo"><h3>HealthSync</h3></div>
          <ul class="nav-links">
            <li><a href="index.jsp">Home</a></li>
            <li><a href="about.jsp">About</a></li>
            <li><a href="contact.jsp">Contact</a></li>
          </ul>
        </nav>
    </header>
    
    <section class="login-section">
        <div class="login-container animate-fade-in">
          <h2>Login to HealthSync</h2>
          
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
          
          <form action="LoginServlet" method="POST">
            <div class="input-group">
              <label for="username"><i class="fas fa-id-card"></i> Username or HealthSync ID</label>
              <input type="text" id="username" placeholder="Enter Username or 12-digit ID" name="username" required>
            </div>
            
            <div class="input-group">
              <label for="password"><i class="fas fa-lock"></i> Password</label>
              <input type="password" id="password" placeholder="Enter Password" name="password" required>
            </div>
            
            <button type="submit" class="login-btn">
                <i class="fas fa-sign-in-alt"></i> Login
            </button>
          </form>
          
          <div class="login-footer">
            <p>Don't have an account? <a href="registration.jsp">Register here</a></p>
          </div>
        </div>
    </section>
    
    <footer>
        <div class="footer-content">
          <div class="footer-logo">HealthSync</div>
          <p>&copy; 2026 HealthSync. All rights reserved.</p>
        </div>
    </footer>
</body>
</html>
