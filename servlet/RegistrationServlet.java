package com.healthsync.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Part;
import java.io.InputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/RegistrationServlet")
@MultipartConfig(maxFileSize = 10 * 1024 * 1024) // 10MB limit
public class RegistrationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // JDBC Connection Details
    private static final String URL = "jdbc:mysql://localhost:3306/healthsync";
    private static final String USER = "root";
    private static final String PASSWORD = "@Amey2005"; // Replace with your MySQL password
    private static final String DRIVER = "com.mysql.cj.jdbc.Driver";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String userType = request.getParameter("user_type"); // 'patient' or 'doctor'
        String username = request.getParameter("username");
        String firstName = request.getParameter("first_name");
        String middleName = request.getParameter("middle_name");
        String lastName = request.getParameter("last_name");
        String dob = request.getParameter("dob");
        String gender = request.getParameter("gender");
        String mobile = request.getParameter("mobile");
        String aadhaar = request.getParameter("aadhaar");
        String password = request.getParameter("password");

        // Parse profile picture upload
        Part filePart = request.getPart("profile_photo");
        byte[] fileData = null;
        if (filePart != null && filePart.getSize() > 0) {
            try (InputStream is = filePart.getInputStream()) {
                fileData = is.readAllBytes();
            }
        }

        // Format name
        String name;
        if ("doctor".equalsIgnoreCase(userType)) {
            name = "Dr. " + firstName + " " + (lastName != null ? lastName : "");
        } else {
            name = firstName + (middleName != null && !middleName.trim().isEmpty() ? " " + middleName : "") + " " + lastName;
        }

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            // Load the JDBC Driver
            Class.forName(DRIVER);
            // Establish a connection using environment variables (with local fallbacks)
            String dbHost = System.getenv("DB_HOST") != null ? System.getenv("DB_HOST") : "localhost";
            String dbPort = System.getenv("DB_PORT") != null ? System.getenv("DB_PORT") : "3306";
            String dbName = System.getenv("DB_NAME") != null ? System.getenv("DB_NAME") : "healthsync";
            String dbUser = System.getenv("DB_USER") != null ? System.getenv("DB_USER") : USER;
            String dbPass = System.getenv("DB_PASSWORD") != null ? System.getenv("DB_PASSWORD") : PASSWORD;
            String resolvedUrl = "jdbc:mysql://" + dbHost + ":" + dbPort + "/" + dbName;
            conn = DriverManager.getConnection(resolvedUrl, dbUser, dbPass);

            // Prepare SQL insert query for Users table
            String query;
            if ("doctor".equalsIgnoreCase(userType)) {
                String nmrId = request.getParameter("nmr_id");
                query = "INSERT INTO Users (username, password, first_name, middle_name, last_name, name, dob, gender, mobile, aadhaar, user_type, nmr_id, profile_photo) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
                ps = conn.prepareStatement(query);
                ps.setString(1, username);
                ps.setString(2, password);
                ps.setString(3, firstName);
                ps.setString(4, middleName);
                ps.setString(5, lastName);
                ps.setString(6, name);
                ps.setString(7, dob);
                ps.setString(8, gender);
                ps.setString(9, mobile);
                ps.setString(10, aadhaar);
                ps.setString(11, "doctor");
                ps.setString(12, nmrId);
                ps.setBytes(13, fileData);
            } else {
                String street = request.getParameter("street");
                String city = request.getParameter("city");
                String state = request.getParameter("state");
                String zipcode = request.getParameter("zipcode");
                String address = street + ", " + city + ", " + state + ", " + zipcode;

                query = "INSERT INTO Users (username, password, first_name, middle_name, last_name, name, dob, gender, mobile, aadhaar, user_type, street, city, state, zipcode, address, profile_photo) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
                ps = conn.prepareStatement(query);
                ps.setString(1, username);
                ps.setString(2, password);
                ps.setString(3, firstName);
                ps.setString(4, middleName);
                ps.setString(5, lastName);
                ps.setString(6, name);
                ps.setString(7, dob);
                ps.setString(8, gender);
                ps.setString(9, mobile);
                ps.setString(10, aadhaar);
                ps.setString(11, "patient");
                ps.setString(12, street);
                ps.setString(13, city);
                ps.setString(14, state);
                ps.setString(15, zipcode);
                ps.setString(16, address);
                ps.setBytes(17, fileData);
            }

            // Execute the query
            ps.executeUpdate();

            // Redirect to success page
            response.sendRedirect("registration_success.jsp");

        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            response.sendRedirect("registration.jsp?error=Database Error: " + e.getMessage());
        } finally {
            // Close all resources
            try {
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
