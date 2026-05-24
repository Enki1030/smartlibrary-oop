package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import utils.DBConnection;

@WebServlet(name = "ExtendServlet", urlPatterns = {"/ExtendServlet"})
public class ExtendServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String txId = request.getParameter("txId");
        
        try (Connection conn = DBConnection.getConnection()) {
            
            // Tambahkan 10 hari ke due_date yang sudah ada
            String sqlUpdateTx = "UPDATE loan_transaction SET due_date = DATE_ADD(due_date, INTERVAL 10 DAY) WHERE transaction_id = ?";
            PreparedStatement stmtTx = conn.prepareStatement(sqlUpdateTx);
            stmtTx.setString(1, txId);
            stmtTx.executeUpdate();
            
            response.sendRedirect("ActiveLoansServlet?msg=Durasi peminjaman berhasil diperpanjang 10 hari!");
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("ActiveLoansServlet?msg=Gagal memperpanjang durasi: " + e.getMessage());
        }
    }
}
