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

@WebServlet(name = "AdminApprovalServlet", urlPatterns = {"/AdminApprovalServlet"})
public class AdminApprovalServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Account user = (Account) session.getAttribute("userAccount");
        
        if (user == null || !user.getRole().equals("LIBRARIAN")) {
            response.sendRedirect("index.jsp");
            return;
        }

        List<Map<String, String>> pendingRequests = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection()) {
            // Ambil semua transaksi yang butuh approval (PENDING_BORROW atau PENDING_RETURN)
            String sql = "SELECT t.transaction_id, t.username, t.nim, t.jurusan, t.resource_id, r.title, t.loan_date, t.due_date, t.status " +
                         "FROM loan_transaction t JOIN library_resource r ON t.resource_id = r.id " +
                         "WHERE t.status IN ('PENDING_BORROW', 'PENDING_RETURN') ORDER BY t.loan_date DESC";
            
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Map<String, String> data = new HashMap<>();
                data.put("transaction_id", rs.getString("transaction_id"));
                data.put("username", rs.getString("username"));
                data.put("nim", rs.getString("nim") != null ? rs.getString("nim") : "-");
                data.put("jurusan", rs.getString("jurusan") != null ? rs.getString("jurusan") : "-");
                data.put("resource_id", rs.getString("resource_id"));
                data.put("title", rs.getString("title"));
                data.put("loan_date", rs.getString("loan_date"));
                data.put("due_date", rs.getString("due_date"));
                data.put("status", rs.getString("status"));
                pendingRequests.add(data);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        request.setAttribute("pendingRequests", pendingRequests);
        request.getRequestDispatcher("admin_approval.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Account user = (Account) session.getAttribute("userAccount");
        
        if (user == null || !user.getRole().equals("LIBRARIAN")) {
            response.sendRedirect("index.jsp");
            return;
        }

        String txId = request.getParameter("txId");
        String action = request.getParameter("action"); // 'approve' atau 'reject'
        String currentStatus = request.getParameter("currentStatus"); // 'PENDING_BORROW' atau 'PENDING_RETURN'
        String resourceId = request.getParameter("resourceId");

        try (Connection conn = DBConnection.getConnection()) {
            if (action.equals("approve")) {
                if (currentStatus.equals("PENDING_BORROW")) {
                    String sql = "UPDATE loan_transaction SET status = 'ACTIVE' WHERE transaction_id = ?";
                    PreparedStatement stmt = conn.prepareStatement(sql);
                    stmt.setString(1, txId);
                    stmt.executeUpdate();
                } else if (currentStatus.equals("PENDING_RETURN")) {
                    String sql = "UPDATE loan_transaction SET status = 'RETURNED' WHERE transaction_id = ?";
                    PreparedStatement stmt = conn.prepareStatement(sql);
                    stmt.setString(1, txId);
                    stmt.executeUpdate();
                    
                    // Kembalikan stok buku
                    String sqlBook = "UPDATE library_resource SET is_available = TRUE WHERE id = ?";
                    PreparedStatement stmtBook = conn.prepareStatement(sqlBook);
                    stmtBook.setString(1, resourceId);
                    stmtBook.executeUpdate();
                }
            } else if (action.equals("reject")) {
                if (currentStatus.equals("PENDING_BORROW")) {
                    // Tolak peminjaman -> Hapus transaksi dan kembalikan stok buku
                    String sqlDel = "DELETE FROM loan_transaction WHERE transaction_id = ?";
                    PreparedStatement stmtDel = conn.prepareStatement(sqlDel);
                    stmtDel.setString(1, txId);
                    stmtDel.executeUpdate();
                    
                    String sqlBook = "UPDATE library_resource SET is_available = TRUE WHERE id = ?";
                    PreparedStatement stmtBook = conn.prepareStatement(sqlBook);
                    stmtBook.setString(1, resourceId);
                    stmtBook.executeUpdate();
                } else if (currentStatus.equals("PENDING_RETURN")) {
                    // Tolak pengembalian (misal buku hilang/rusak, suruh urus dulu)
                    // Status dikembalikan ke ACTIVE
                    String sql = "UPDATE loan_transaction SET status = 'ACTIVE' WHERE transaction_id = ?";
                    PreparedStatement stmt = conn.prepareStatement(sql);
                    stmt.setString(1, txId);
                    stmt.executeUpdate();
                }
            }
            response.sendRedirect("AdminApprovalServlet?msg=Aksi Berhasil");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("AdminApprovalServlet?msg=Gagal: " + e.getMessage());
        }
    }
}
