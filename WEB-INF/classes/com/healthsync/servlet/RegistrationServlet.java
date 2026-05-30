package com.healthsync.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/RegistrationServlet")
public class RegistrationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // JDBC Connection Details
    private static final String URL = "jdbc:mysql://localhost:3306/healthsync";
    private static final String USER = "root";
    private static final String PASSWORD = "@Amey2005"; // Replace with your MySQL password
    private static final String DRIVER = "com.mysql.cj.jdbc.Driver";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String userType = request.getParameter("user_type");
        String username = request.getParameter("username");
        String firstName = request.getParameter("first_name");
        String middleName = request.getParameter("middle_name");
        String lastName = request.getParameter("last_name");
        String dob = request.getParameter("dob");
        String gender = request.getParameter("gender");
        String mobile = request.getParameter("mobile");
        String aadhaar = request.getParameter("aadhaar");
        String password = request.getParameter("password");

        String nmrId = request.getParameter("nmr_id"); // Only for doctors
        String street = request.getParameter("street");
        String city = request.getParameter("city");
        String state = request.getParameter("state");
        String zipcode = request.getParameter("zipcode");

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            // Load the JDBC Driver
            Class.forName(DRIVER);
            // Establish a connection
            conn = DriverManager.getConnection(URL, USER, PASSWORD);

            // Prepare SQL insert query for user
            String query;
            if (userType.equals("doctor")) {
                query = "INSERT INTO User (username, first_name, middle_name, last_name, dob, gender, mobile, aadhaar, password, user_type, nmr_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, 'doctor', ?)";
            } else {
                query = "INSERT INTO User (username, first_name, middle_name, last_name, dob, gender, mobile, aadhaar, password, user_type, street, city, state, zipcode) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, 'normal', ?, ?, ?, ?)";
            }

            ps = conn.prepareStatement(query);
            ps.setString(1, username);
            ps.setString(2, firstName);
            ps.setString(3, middleName);
            ps.setString(4, lastName);
            ps.setString(5, dob);
            ps.setString(6, gender);
            ps.setString(7, mobile);
            ps.setString(8, aadhaar);
            ps.setString(9, password);

            if (userType.equals("doctor")) {
                ps.setString(10, nmrId); // NMR ID for doctors
            } else {
                ps.setString(10, street);
                ps.setString(11, city);
                ps.setString(12, state);
                ps.setString(13, zipcode);
            }

            // Execute the query
            ps.executeUpdate();

            // Redirect to success page
            response.sendRedirect("registration_success.jsp");

        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            response.sendRedirect("registration.jsp?error=Database Error. Please try again.");
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
