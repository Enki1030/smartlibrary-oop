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

@WebServlet(name = "BorrowServlet", urlPatterns = {"/BorrowServlet"})
public class BorrowServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Account user = (Account) session.getAttribute("userAccount");
        String resourceId = request.getParameter("resourceId");
        
        // Validasi Akses (Hanya Student)
        if (user == null || !user.getRole().equals("STUDENT")) {
            response.sendRedirect("index.jsp?error=Harap login sebagai Mahasiswa");
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            int durationDays = 10; // Hardcoded sesuai permintaan
            LocalDate loanDate = LocalDate.now();
            LocalDate dueDate = loanDate.plusDays(durationDays);
            
            // Masukkan ke tabel loan_transaction dengan status PENDING_BORROW (nim dan jurusan akan null)
            String sqlInsert = "INSERT INTO loan_transaction (username, resource_id, loan_date, due_date, status) VALUES (?, ?, ?, ?, 'PENDING_BORROW')";
            PreparedStatement stmtInsert = conn.prepareStatement(sqlInsert);
            stmtInsert.setString(1, user.getUsername());
            stmtInsert.setString(2, resourceId);
            stmtInsert.setDate(3, java.sql.Date.valueOf(loanDate));
            stmtInsert.setDate(4, java.sql.Date.valueOf(dueDate));
            stmtInsert.executeUpdate();
            
            // Buku ditahan dulu saat dipesan:
            String sqlUpdate = "UPDATE library_resource SET is_available = FALSE WHERE id = ?";
            PreparedStatement stmtUpdate = conn.prepareStatement(sqlUpdate);
            stmtUpdate.setString(1, resourceId);
            stmtUpdate.executeUpdate();
            
            response.sendRedirect("CatalogServlet?msg=success");
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("CatalogServlet?error=Transaksi Gagal: " + e.getMessage());
        }
    }
    
    // Fallback jika ada yang panggil GET
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("CatalogServlet");
    }
}