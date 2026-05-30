package com.healthsync.servlet;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

@WebServlet("/SavePrescriptionServlet")
@MultipartConfig(maxFileSize = 10 * 1024 * 1024) // 10MB Maximum file size
public class SavePrescriptionServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final String URL = "jdbc:mysql://localhost:3306/healthsync";
    private static final String USER = "root";
    private static final String PASSWORD = "@Amey2005";
    private static final String DRIVER = "com.mysql.cj.jdbc.Driver";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String userId = request.getParameter("userId");
        String diagnosis = request.getParameter("diagnosis");
        String prescribedBy = request.getParameter("prescribed_by");
        String date = request.getParameter("prescribed_date");
        String medicines = request.getParameter("medicines");
        String quantity = request.getParameter("quantity");
        String redirectSource = request.getParameter("redirectSource");

        Part filePart = request.getPart("prescription_file");
        byte[] fileData = null;
        String contentType = null;

        if (filePart != null && filePart.getSize() > 0) {
            contentType = filePart.getContentType();
            try (InputStream is = filePart.getInputStream()) {
                fileData = is.readAllBytes();
            }
        }

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            Class.forName(DRIVER);
            // Establish a connection using environment variables (with local fallbacks)
            String dbHost = System.getenv("DB_HOST") != null ? System.getenv("DB_HOST") : "localhost";
            String dbPort = System.getenv("DB_PORT") != null ? System.getenv("DB_PORT") : "3306";
            String dbName = System.getenv("DB_NAME") != null ? System.getenv("DB_NAME") : "healthsync";
            String dbUser = System.getenv("DB_USER") != null ? System.getenv("DB_USER") : USER;
            String dbPass = System.getenv("DB_PASSWORD") != null ? System.getenv("DB_PASSWORD") : PASSWORD;
            String resolvedUrl = "jdbc:mysql://" + dbHost + ":" + dbPort + "/" + dbName;
            conn = DriverManager.getConnection(resolvedUrl, dbUser, dbPass);

            String query = "INSERT INTO Prescriptions (user_id, diagnosis, prescribed_date, prescribed_by, medicines, quantity, prescription_file, file_type) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            ps = conn.prepareStatement(query);
            ps.setString(1, userId);
            ps.setString(2, diagnosis);
            ps.setString(3, date);
            ps.setString(4, prescribedBy);
            ps.setString(5, medicines);
            ps.setString(6, quantity);
            ps.setBytes(7, fileData);
            ps.setString(8, contentType);

            ps.executeUpdate();
            
            if ("doctor".equalsIgnoreCase(redirectSource)) {
                response.sendRedirect("doctor_dash.jsp?searchQuery=" + userId);
            } else {
                response.sendRedirect("dash.jsp");
            }

        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            if ("doctor".equalsIgnoreCase(redirectSource)) {
                response.sendRedirect("doctor_dash.jsp?searchQuery=" + userId + "&error=Database error: " + e.getMessage());
            } else {
                response.sendRedirect("dash.jsp?error=Database error: " + e.getMessage());
            }
        } finally {
            try {
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
