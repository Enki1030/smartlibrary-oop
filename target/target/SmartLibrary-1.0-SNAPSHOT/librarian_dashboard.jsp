<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="utils.DBConnection"%>
<%@page import="java.util.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    model.Account user = (model.Account) session.getAttribute("userAccount");
    if (user == null || !user.getRole().equals("LIBRARIAN")) {
        response.sendRedirect("index.jsp");
        return;
    }

    // Fetch Active Loans and Recent Returns (Last 7 days)
    List<Map<String, String>> activeLoans = new ArrayList<>();
    List<Map<String, String>> recentReturns = new ArrayList<>();
    
    try (Connection conn = DBConnection.getConnection()) {
        String sqlActive = "SELECT t.username, t.nim, t.jurusan, r.title, t.loan_date, t.due_date " +
                           "FROM loan_transaction t JOIN library_resource r ON t.resource_id = r.id " +
                           "WHERE t.status = 'ACTIVE' ORDER BY t.loan_date DESC";
        PreparedStatement stmtActive = conn.prepareStatement(sqlActive);
        ResultSet rsActive = stmtActive.executeQuery();
        while (rsActive.next()) {
            Map<String, String> m = new HashMap<>();
            m.put("username", rsActive.getString("username"));
            m.put("nim", rsActive.getString("nim"));
            m.put("jurusan", rsActive.getString("jurusan"));
            m.put("title", rsActive.getString("title"));
            m.put("loan_date", rsActive.getString("loan_date"));
            m.put("due_date", rsActive.getString("due_date"));
            activeLoans.add(m);
        }
        
        // Simulating recent returns. Ideally there is a return_date column. We'll use due_date or loan_date as proxy if not available,
        // but since we don't have return_date, we just show all RETURNED, limited to those where due_date is within last 14 days or so.
        // For simplicity, we just fetch RETURNED order by transaction_id DESC limit 10
        String sqlReturn = "SELECT t.username, r.title, t.loan_date " +
                           "FROM loan_transaction t JOIN library_resource r ON t.resource_id = r.id " +
                           "WHERE t.status = 'RETURNED' ORDER BY t.transaction_id DESC LIMIT 10";
        PreparedStatement stmtReturn = conn.prepareStatement(sqlReturn);
        ResultSet rsReturn = stmtReturn.executeQuery();
        while (rsReturn.next()) {
            Map<String, String> m = new HashMap<>();
            m.put("username", rsReturn.getString("username"));
            m.put("title", rsReturn.getString("title"));
            m.put("loan_date", rsReturn.getString("loan_date"));
            recentReturns.add(m);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SmartLibrary - Dashboard Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="assets/css/style.css">
    <style>
        .page-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px; }
        .page-header h1 { font-size: 2rem; color: var(--text-main); }
        .page-header p { color: var(--text-muted); margin-top: 5px; }
        
        .section-title { font-size: 1.25rem; font-weight: 600; margin-bottom: 20px; color: var(--text-main); }
        
        .data-table { width: 100%; border-collapse: collapse; background: var(--card-bg); border-radius: 12px; overflow: hidden; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05); border: 1px solid var(--border-color); margin-bottom: 40px; }
        .data-table th, .data-table td { padding: 16px 20px; text-align: left; border-bottom: 1px solid var(--border-color); }
        .data-table th { background-color: #f8fafc; font-weight: 600; color: var(--text-muted); text-transform: uppercase; font-size: 0.8rem; letter-spacing: 0.05em; }
        .data-table tr:last-child td { border-bottom: none; }
        .data-table tr:hover td { background-color: #f1f5f9; }
        
        .empty-state { text-align: center; padding: 40px; color: var(--text-muted); background: var(--card-bg); border-radius: 12px; border: 1px dashed var(--border-color); margin-bottom: 40px; }
    </style>
</head>
<body>
    <% request.setAttribute("activeMenu", "dashboard"); %>
    <%@ include file="sidebar.jspf" %>

    <main class="main-content">
        <div class="page-header">
            <div>
                <h1>Dashboard Petugas Perpustakaan</h1>
                <p>Selamat bertugas, <b><%= user.getUsername() %></b>! Berikut adalah ringkasan aktivitas perpustakaan.</p>
            </div>
        </div>

        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-title">Buku Sedang Dipinjam</div>
                <div class="stat-value"><%= activeLoans.size() %></div>
                <div class="stat-desc">Transaksi aktif saat ini</div>
            </div>
            <div class="stat-card">
                <div class="stat-title">Peminjam Aktif</div>
                <div class="stat-value"><%= activeLoans.stream().map(m -> m.get("username")).distinct().count() %></div>
                <div class="stat-desc">Mahasiswa meminjam buku</div>
            </div>
            <div class="stat-card">
                <div class="stat-title">Pengembalian Baru</div>
                <div class="stat-value"><%= recentReturns.size() %></div>
                <div class="stat-desc">Histori 10 transaksi terakhir</div>
            </div>
        </div>

        <h2 class="section-title">Mahasiswa Sedang Meminjam Buku (ACTIVE)</h2>
        <% if (activeLoans.isEmpty()) { %>
            <div class="empty-state">Tidak ada buku yang sedang dipinjam saat ini.</div>
        <% } else { %>
            <table class="data-table">
                <thead>
                    <tr>
                        <th>Peminjam (Username)</th>
                        <th>NIM</th>
                        <th>Jurusan</th>
                        <th>Judul Buku</th>
                        <th>Tanggal Pinjam</th>
                        <th>Batas Kembali</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Map<String, String> loan : activeLoans) { %>
                    <tr>
                        <td style="font-weight: 500;"><%= loan.get("username") %></td>
                        <td><%= loan.get("nim") != null ? loan.get("nim") : "-" %></td>
                        <td><%= loan.get("jurusan") != null ? loan.get("jurusan") : "-" %></td>
                        <td><%= loan.get("title") %></td>
                        <td><%= loan.get("loan_date") %></td>
                        <td style="color: var(--primary); font-weight: 500;"><%= loan.get("due_date") %></td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        <% } %>

        <h2 class="section-title">Riwayat Pengembalian Terakhir</h2>
        <% if (recentReturns.isEmpty()) { %>
            <div class="empty-state">Belum ada buku yang dikembalikan baru-baru ini.</div>
        <% } else { %>
            <table class="data-table">
                <thead>
                    <tr>
                        <th>Peminjam (Username)</th>
                        <th>Judul Buku</th>
                        <th>Tanggal Pinjam (Ref)</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Map<String, String> ret : recentReturns) { %>
                    <tr>
                        <td style="font-weight: 500;"><%= ret.get("username") %></td>
                        <td><%= ret.get("title") %></td>
                        <td><%= ret.get("loan_date") %></td>
                        <td><span style="color: #166534; background: #dcfce7; padding: 4px 10px; border-radius: 20px; font-size: 0.75rem; font-weight: 600;">Selesai (RETURNED)</span></td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        <% } %>

    </main>
</body>
</html>