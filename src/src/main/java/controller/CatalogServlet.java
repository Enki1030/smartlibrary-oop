/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import model.LibraryResource;
import model.SearchEngine;

/**
 *
 * @author ighfir
 */
@WebServlet(name = "CatalogServlet", urlPatterns = {"/CatalogServlet"})
public class CatalogServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Menangkap kata kunci dari form pencarian (jika ada)
        String keyword = request.getParameter("keyword");
        List<LibraryResource> catalogList;
        
        // Jika user melakukan pencarian
        if (keyword != null && !keyword.trim().isEmpty()) {
            catalogList = SearchEngine.searchByTitle(keyword);
        } else {
            // Jika tidak ada pencarian, tampilkan semua
            catalogList = SearchEngine.getAllResources();
        }
        
        // Kirim hasil pencarian ke halaman JSP
        request.setAttribute("katalogData", catalogList);
        request.getRequestDispatcher("catalog.jsp").forward(request, response);
    }
}