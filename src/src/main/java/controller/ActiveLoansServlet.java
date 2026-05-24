/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import model.Account;
import utils.DBConnection;

/**
 *
 * @author ighfir
 */

@WebServlet(name = "ActiveLoansServlet", urlPatterns = {"/ActiveLoansServlet"})
public class ActiveLoansServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Account user = (Account) session.getAttribute("userAccount");
        
        if (user == null || !user.getRole().equals("STUDENT")) {
            response.sendRedirect("index.jsp");
            return;
        }

        // Kita gunakan List of Map untuk mempermudah passing data JOIN ke JSP
        List<Map<String, String>> loans = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT t.transaction_id, t.resource_id, r.title, t.loan_date, t.due_date, t.status " +
                         "FROM loan_transaction t JOIN library_resource r ON t.resource_id = r.id " +
                         "WHERE t.username = ? ORDER BY t.transaction_id DESC";
            
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, user.getUsername());
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Map<String, String> loanData = new HashMap<>();
                loanData.put("transaction_id", rs.getString("transaction_id"));
                loanData.put("resource_id", rs.getString("resource_id"));
                loanData.put("title", rs.getString("title"));
                loanData.put("loan_date", rs.getString("loan_date"));
                loanData.put("due_date", rs.getString("due_date"));
                
                String dbStatus = rs.getString("status");
                if (dbStatus == null || dbStatus.equals("BORROWED")) dbStatus = "ACTIVE";
                loanData.put("status", dbStatus);
                
                loans.add(loanData);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        request.setAttribute("activeLoans", loans);
        request.getRequestDispatcher("active_loans.jsp").forward(request, response);
    }
}