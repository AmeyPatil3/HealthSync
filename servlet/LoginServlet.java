package com.healthsync.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // JDBC Connection Details
    private static final String URL = "jdbc:mysql://localhost:3306/healthsync";
    private static final String USER = "root";
    private static final String PASSWORD = "@Amey2005"; // Replace with your actual password
    private static final String DRIVER = "com.mysql.cj.jdbc.Driver";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            // Load the JDBC Driver
            Class.forName(DRIVER);
            // Establish a connection
            conn = DriverManager.getConnection(URL, USER, PASSWORD);

            // Prepare SQL query targeting unified Users table
            String query = "SELECT * FROM Users WHERE username = ? AND password = ?";
            ps = conn.prepareStatement(query);
            ps.setString(1, username);
            ps.setString(2, password);

            // Execute the query
            rs = ps.executeQuery();

            if (rs.next()) {
                // Login successful, fetch details
                String role = rs.getString("user_type");

                // Create session
                HttpSession session = request.getSession();
                session.setAttribute("userId", username);
                session.setAttribute("userRole", role);
                session.setAttribute("name", rs.getString("name"));

                // Redirect based on role
                if ("doctor".equalsIgnoreCase(role)) {
                    response.sendRedirect("doctor_dash.jsp");
                } else {
                    response.sendRedirect("dash.jsp");
                }
            } else {
                // Login failed, redirect to login page with an error
                response.sendRedirect("login.jsp?error=Invalid username or password");
            }

        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            response.sendRedirect("login.jsp?error=Database error: " + e.getMessage());
        } finally {
            // Close all resources
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
