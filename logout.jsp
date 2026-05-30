<%-- logout.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Invalidate the current session to log the user out
    if (session != null) {
        session.invalidate();
    }
    // Redirect to the login page
    response.sendRedirect("login.jsp");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Logging Out...</title>
</head>
<body>
    <p>You are being logged out. Please wait...</p>
</body>
</html>
