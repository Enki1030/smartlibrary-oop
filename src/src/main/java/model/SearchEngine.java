/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import utils.DBConnection;

/**
 *
 * @author ighfir
 */
public class SearchEngine {

    // Method pencarian berdasarkan judul sesuai proposal Anggota 5
    public static List<LibraryResource> searchByTitle(String keyword) {
        List<LibraryResource> resultList = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection()) {
            // Menggunakan fungsi LIKE pada SQL untuk pencarian substring
            String sql = "SELECT * FROM library_resource WHERE title LIKE ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            
            // Tanda % di depan dan belakang agar bisa mencari kata di tengah judul
            stmt.setString(1, "%" + keyword + "%");
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                String type = rs.getString("type");
                LibraryResource resource = null;
                
                if (type.equals("PHYSICAL_BOOK")) {
                    resource = new PhysicalBook(
                        rs.getString("id"), rs.getString("title"), rs.getString("author"),
                        rs.getInt("year_published"), rs.getBoolean("is_available"),
                        rs.getString("isbn"), rs.getString("shelf_location")
                    );
                } else if (type.equals("EBOOK")) {
                    resource = new EBook(
                        rs.getString("id"), rs.getString("title"), rs.getString("author"),
                        rs.getInt("year_published"), rs.getBoolean("is_available"),
                        rs.getDouble("file_size"), rs.getString("file_format"), rs.getString("download_url")
                    );
                }
                
                if (resource != null) {
                    resource.setPublisher(rs.getString("publisher"));
                    resource.setDescription(rs.getString("description"));
                    resultList.add(resource);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return resultList;
    }

    // Method pembantu untuk mengambil semua data (saat kolom pencarian kosong)
    public static List<LibraryResource> getAllResources() {
        return searchByTitle(""); // String kosong akan cocok dengan semua judul
    }
}