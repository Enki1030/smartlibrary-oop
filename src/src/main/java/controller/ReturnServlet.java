/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.time.LocalDate;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import model.FineCalculator;
import utils.DBConnection;

/**
 *
 * @author ighfir
 */
@WebServlet(name = "ReturnServlet", urlPatterns = {"/ReturnServlet"})
public class ReturnServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String txId = request.getParameter("txId");
        String resourceId = request.getParameter("resourceId");
        String dueDateStr = request.getParameter("dueDate"); // Berformat YYYY-MM-DD
        
        try (Connection conn = DBConnection.getConnection()) {
            
            // 1. Logika Tanggal & Denda
            LocalDate dueDate = LocalDate.parse(dueDateStr);
            LocalDate returnDate = LocalDate.now(); // Anggap dikembalikan hari ini
            
            // Panggil class FineCalculator buatan Anggota 3
            int keterlambatan = FineCalculator.calculatePenaltyDays(dueDate, returnDate);
            double nominalDenda = FineCalculator.hitungDenda(keterlambatan);
            
            // 2. Update status transaksi menjadi PENDING_RETURN
            String sqlUpdateTx = "UPDATE loan_transaction SET status = 'PENDING_RETURN' WHERE transaction_id = ?";
            PreparedStatement stmtTx = conn.prepareStatement(sqlUpdateTx);
            stmtTx.setString(1, txId);
            stmtTx.executeUpdate();
            
            // Catatan: Status is_available = TRUE untuk buku DITUNDA sampai Admin menyetujui pengembalian
            
            // 4. Siapkan pesan sukses
            String pesan = "Permintaan pengembalian dikirim. Menunggu verifikasi fisik oleh Admin!";
            if (keterlambatan > 0) {
                pesan += " (Perkiraan denda keterlambatan " + keterlambatan + " hari: Rp " + nominalDenda + ")";
            }
            
            response.sendRedirect("ActiveLoansServlet?msg=" + pesan);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("ActiveLoansServlet?msg=Terjadi Kesalahan: " + e.getMessage());
        }
    }
}