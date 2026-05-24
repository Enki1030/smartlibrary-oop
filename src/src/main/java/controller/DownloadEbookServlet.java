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
import jakarta.servlet.http.HttpSession;

import model.Account;
import utils.DBConnection;

@WebServlet(name = "DownloadEbookServlet", urlPatterns = {"/DownloadEbookServlet"})
public class DownloadEbookServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Account user = (Account) session.getAttribute("userAccount");
        String resourceId = request.getParameter("resourceId");
        
        // Validasi Akses
        if (user == null) {
            response.sendRedirect("index.jsp?error=Harap login untuk mengunduh e-book");
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            LocalDate loanDate = LocalDate.now();
            
            // Masukkan ke tabel loan_transaction dengan status DOWNLOADED
            // Tambahkan due_date (sama dengan loan_date) agar tidak error 'Field due_date doesnt have a default value'
            String sqlInsert = "INSERT INTO loan_transaction (username, resource_id, loan_date, due_date, status) VALUES (?, ?, ?, ?, 'DOWNLOADED')";
            PreparedStatement stmtInsert = conn.prepareStatement(sqlInsert);
            stmtInsert.setString(1, user.getUsername());
            stmtInsert.setString(2, resourceId);
            stmtInsert.setDate(3, java.sql.Date.valueOf(loanDate));
            stmtInsert.setDate(4, java.sql.Date.valueOf(loanDate)); // due_date = loan_date untuk ebook
            stmtInsert.executeUpdate();
            
            response.sendRedirect("CatalogServlet?msg=Buku digital berhasil diunduh dan disimpan ke riwayat!");
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("CatalogServlet?error=Gagal mencatat unduhan: " + e.getMessage());
        }
    }
}
