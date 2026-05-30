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
        String userType = request.getParameter("user_type");

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            // Load the JDBC Driver
            Class.forName(DRIVER);

            // Establish a connection
            conn = DriverManager.getConnection(URL, USER, PASSWORD);

            // Prepare SQL query
            String query = "SELECT * FROM User WHERE username = ? AND password = ? AND user_type = ?";
            ps = conn.prepareStatement(query);
            ps.setString(1, username);
            ps.setString(2, password);
            ps.setString(3, userType);

            // Execute the query
            rs = ps.executeQuery();

            if (rs.next()) {
                // Login successful, create session
                HttpSession session = request.getSession();
                session.setAttribute("username", username);
                session.setAttribute("user_type", userType);

                // Redirect to dashboard
                response.sendRedirect("dashboard.jsp");
            } else {
                // Login failed, redirect to login page with an error message
                response.sendRedirect("login.jsp?error=Invalid username or password");
            }

        } catch (ClassNotFoundException e) {
            // JDBC driver class not found
            e.printStackTrace();
            response.sendRedirect("login.jsp?error=Database driver error");
        } catch (SQLException e) {
            // SQL error or database connection failure
            e.printStackTrace();
            response.sendRedirect("login.jsp?error=Database connection error");
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
