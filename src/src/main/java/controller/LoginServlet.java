/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import model.Account;
import model.Librarian;
import model.Student;
import utils.DBConnection;

/**
 *
 * @author ighfir
 */
@WebServlet(name = "LoginServlet", urlPatterns = {"/LoginServlet"})
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String user = request.getParameter("username");
        String pass = request.getParameter("password");
        
        try (Connection conn = DBConnection.getConnection()) {
            // Query ke database menggunakan PreparedStatement agar aman dari SQL Injection
            String sql = "SELECT * FROM account WHERE username = ? AND password_user = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, user);
            stmt.setString(2, pass);
            
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                String role = rs.getString("role");
                Account account = null;
                
                // Menerapkan Polimorfisme: Instansiasi objek berdasarkan Role
                if (role.equals("STUDENT")) {
                    account = new Student(
                        rs.getString("username"), 
                        rs.getString("password_user"), 
                        rs.getString("student_id"), 
                        rs.getInt("borrow_limit")
                    );
                } else if (role.equals("LIBRARIAN")) {
                    account = new Librarian(
                        rs.getString("username"), 
                        rs.getString("password_user"), 
                        rs.getString("employee_id")
                    );
                }
                
                if (account != null) {
                    // Simpan objek account ke dalam Session
                    HttpSession session = request.getSession();
                    session.setAttribute("userAccount", account);
                    
                    // Redirect menggunakan method OOP getDashboardUrl() yang kita buat di Model
                    response.sendRedirect(account.getDashboardUrl());
                }
            } else {
                // Jika login gagal, kembalikan ke index.jsp dengan pesan error
                response.sendRedirect("index.jsp?error=1");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("index.jsp?error=2"); // Error database
        }
    }
}