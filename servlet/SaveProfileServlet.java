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

@WebServlet("/SaveProfileServlet")
@MultipartConfig(maxFileSize = 10 * 1024 * 1024) // 10MB limit
public class SaveProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // JDBC Connection Details
    private static final String URL = "jdbc:mysql://localhost:3306/healthsync";
    private static final String USER = "root";
    private static final String PASSWORD = "@Amey2005";
    private static final String DRIVER = "com.mysql.cj.jdbc.Driver";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String userId = request.getParameter("userId");
        String name = request.getParameter("name");
        String dob = request.getParameter("dob");
        String gender = request.getParameter("gender");
        String bloodGroup = request.getParameter("blood_group");
        String mobile = request.getParameter("mobile");
        String street = request.getParameter("street");
        String city = request.getParameter("city");
        String state = request.getParameter("state");
        String zipcode = request.getParameter("zipcode");
        String address = street + ", " + city + ", " + state + ", " + zipcode;
        
        String insurance = request.getParameter("insurance");
        String guardianName = request.getParameter("guardian_name");
        String guardianMobile = request.getParameter("guardian_mobile");
        String emergencyContact = request.getParameter("emergency_contact");

        Part filePart = request.getPart("profile_photo");
        byte[] fileData = null;

        if (filePart != null && filePart.getSize() > 0) {
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

            String query;
            if (fileData != null) {
                // Photo is uploaded, so update demographic details AND profile_photo
                query = "UPDATE Users SET name = ?, dob = ?, gender = ?, blood_group = ?, mobile = ?, street = ?, city = ?, state = ?, zipcode = ?, address = ?, insurance = ?, guardian_name = ?, guardian_mobile = ?, emergency_contact = ?, profile_photo = ? WHERE username = ?";
                ps = conn.prepareStatement(query);
                ps.setString(1, name);
                ps.setString(2, dob);
                ps.setString(3, gender);
                ps.setString(4, bloodGroup);
                ps.setString(5, mobile);
                ps.setString(6, street);
                ps.setString(7, city);
                ps.setString(8, state);
                ps.setString(9, zipcode);
                ps.setString(10, address);
                ps.setString(11, insurance);
                ps.setString(12, guardianName);
                ps.setString(13, guardianMobile);
                ps.setString(14, emergencyContact);
                ps.setBytes(15, fileData);
                ps.setString(16, userId);
            } else {
                // No photo uploaded, preserve the existing profile_photo
                query = "UPDATE Users SET name = ?, dob = ?, gender = ?, blood_group = ?, mobile = ?, street = ?, city = ?, state = ?, zipcode = ?, address = ?, insurance = ?, guardian_name = ?, guardian_mobile = ?, emergency_contact = ? WHERE username = ?";
                ps = conn.prepareStatement(query);
                ps.setString(1, name);
                ps.setString(2, dob);
                ps.setString(3, gender);
                ps.setString(4, bloodGroup);
                ps.setString(5, mobile);
                ps.setString(6, street);
                ps.setString(7, city);
                ps.setString(8, state);
                ps.setString(9, zipcode);
                ps.setString(10, address);
                ps.setString(11, insurance);
                ps.setString(12, guardianName);
                ps.setString(13, guardianMobile);
                ps.setString(14, emergencyContact);
                ps.setString(15, userId);
            }

            int updatedRows = ps.executeUpdate();
            if (updatedRows > 0) {
                response.sendRedirect("dash.jsp");
            } else {
                response.sendRedirect("dash.jsp?error=Failed to update profile details");
            }

        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            response.sendRedirect("dash.jsp?error=Database error: " + e.getMessage());
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
