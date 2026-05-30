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

@WebServlet("/SaveMedicalRecordServlet")
@MultipartConfig(maxFileSize = 10 * 1024 * 1024) // 10MB Maximum file size
public class SaveMedicalRecordServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final String URL = "jdbc:mysql://localhost:3306/healthsync";
    private static final String USER = "root";
    private static final String PASSWORD = "@Amey2005";
    private static final String DRIVER = "com.mysql.cj.jdbc.Driver";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String userId = request.getParameter("userId");
        String diagnosis = request.getParameter("diagnosis");
        String doctor = request.getParameter("attending_doctor");
        String date = request.getParameter("date");
        String description = request.getParameter("description");
        String redirectSource = request.getParameter("redirectSource");

        Part filePart = request.getPart("case_sheet");
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
            conn = DriverManager.getConnection(URL, USER, PASSWORD);

            String query = "INSERT INTO MedicalRecords (user_id, diagnosis, attending_doctor, date, description, case_sheet, case_sheet_type) VALUES (?, ?, ?, ?, ?, ?, ?)";
            ps = conn.prepareStatement(query);
            ps.setString(1, userId);
            ps.setString(2, diagnosis);
            ps.setString(3, doctor);
            ps.setString(4, date);
            ps.setString(5, description);
            ps.setBytes(6, fileData);
            ps.setString(7, contentType);

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
