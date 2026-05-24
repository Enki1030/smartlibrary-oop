/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

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
@WebServlet(name = "ManageResourceServlet", urlPatterns = {"/ManageResourceServlet"})
public class ManageResourceServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Keamanan ekstra: Cek session kembali di sisi Controller
        HttpSession session = request.getSession();
        Account user = (Account) session.getAttribute("userAccount");
        if (user == null || !user.getRole().equals("LIBRARIAN")) {
            response.sendRedirect("index.jsp");
            return;
        }

        // Menangkap Parameter Umum (Inheritance level parent)
        String id = request.getParameter("id");
        String title = request.getParameter("title");
        String author = request.getParameter("author");
        int year = Integer.parseInt(request.getParameter("year"));
        String type = request.getParameter("type");
        boolean isAvailable = true; // Default selalu tersedia saat baru ditambahkan

        try (Connection conn = DBConnection.getConnection()) {
            
            if (type.equals("PHYSICAL_BOOK")) {
                // Menangkap Parameter Khusus Fisik
                String isbn = request.getParameter("isbn");
                String shelfLocation = request.getParameter("shelfLocation");
                String conditionStatus = request.getParameter("conditionStatus");
                
                String sql = "INSERT INTO library_resource (id, title, author, year_published, is_available, type, isbn, shelf_location, condition_status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setString(1, id);
                stmt.setString(2, title);
                stmt.setString(3, author);
                stmt.setInt(4, year);
                stmt.setBoolean(5, isAvailable);
                stmt.setString(6, type);
                stmt.setString(7, isbn);
                stmt.setString(8, shelfLocation);
                stmt.setString(9, conditionStatus);
                stmt.executeUpdate();
                
            } else if (type.equals("EBOOK")) {
                // Menangkap Parameter Khusus Digital
                double fileSize = Double.parseDouble(request.getParameter("fileSize"));
                String fileFormat = request.getParameter("fileFormat");
                String downloadUrl = request.getParameter("downloadUrl");
                
                String sql = "INSERT INTO library_resource (id, title, author, year_published, is_available, type, file_size, file_format, download_url) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setString(1, id);
                stmt.setString(2, title);
                stmt.setString(3, author);
                stmt.setInt(4, year);
                stmt.setBoolean(5, isAvailable);
                stmt.setString(6, type);
                stmt.setDouble(7, fileSize);
                stmt.setString(8, fileFormat);
                stmt.setString(9, downloadUrl);
                stmt.executeUpdate();
            }

            // Jika sukses, kembalikan ke form dengan pesan berhasil
            response.sendRedirect("add_resource.jsp?msg=Koleksi dengan ID " + id + " berhasil ditambahkan!");
            
        } catch (Exception e) {
            e.printStackTrace();
            // Exception Handling (Robustness)
            response.sendRedirect("add_resource.jsp?error=Gagal menyimpan ke database: " + e.getMessage());
        }
    }
}