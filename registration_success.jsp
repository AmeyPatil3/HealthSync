<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>HealthSync - Registration Successful</title>
    <link rel="stylesheet" href="./assets/style1.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Lato:wght@400;700&family=Montserrat:wght@500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <meta http-equiv="refresh" content="5;url=login.jsp">
</head>
<body>
    <header>
        <nav>
          <div class="logo"><h3>HealthSync</h3></div>
        </nav>
    </header>
    
    <section class="login-section">
        <div class="login-container success-container animate-fade-in">
            <div class="success-icon">
                <i class="fas fa-check-circle"></i>
            </div>
            <h2>Registration Successful!</h2>
            <p>Thank you for registering with HealthSync. Your health identity profile has been successfully created in our secure database.</p>
            <p class="redirect-text">You will be automatically redirected to the login page in 5 seconds...</p>
            
            <a href="login.jsp" class="login-btn success-btn">
                <i class="fas fa-sign-in-alt"></i> Go to Login Now
            </a>
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
