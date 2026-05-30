<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String url = "jdbc:mysql://localhost:3306/healthsync";
    String dbUser = "root";
    String dbPass = "@Amey2005";
    Connection conn = null;
    PreparedStatement pstmt = null;

    String userId = request.getParameter("userId");
    String allergyName = request.getParameter("allergy_name");
    String description = request.getParameter("description");
    String severity = request.getParameter("severity");

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(url, dbUser, dbPass);

        String saveAllergyQuery = "INSERT INTO Allergies (user_id, allergy_name, description, severity) VALUES (?, ?, ?, ?)";
        pstmt = conn.prepareStatement(saveAllergyQuery);
        pstmt.setString(1, userId);
        pstmt.setString(2, allergyName);
        pstmt.setString(3, description);
        pstmt.setString(4, severity);

        int insertedRows = pstmt.executeUpdate();
        if (insertedRows > 0) {
            response.sendRedirect("dash.jsp");
        } else {
            out.println("Failed to save allergy.");
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.println("Error: " + e.getMessage());
    } finally {
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    }
%>
