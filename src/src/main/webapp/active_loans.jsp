<%@page import="java.util.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    List<Map<String, String>> activeLoans = (List<Map<String, String>>) request.getAttribute("activeLoans");
    model.Account user = (model.Account) session.getAttribute("userAccount");
    if (user == null) {
        response.sendRedirect("index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SmartLibrary - Aktivitas Peminjaman</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="assets/css/style.css">
    <style>
        .page-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px; }
        .page-header h1 { font-size: 2rem; color: var(--text-main); font-weight: 700; }
        .page-header p { color: var(--text-muted); margin-top: 5px; }
        .alert { padding: 15px 20px; border-radius: 8px; margin-bottom: 24px; font-weight: 500; }
        .alert-info { background-color: var(--info-bg); color: var(--info-text); border: 1px solid #bae6fd; }
        
        /* Solid Button Tabs */
        .tabs { display: flex; gap: 12px; margin-bottom: 30px; }
        .tab-btn { background: var(--card-bg); border: 1px solid var(--border-color); padding: 10px 20px; border-radius: 8px; font-size: 0.95rem; font-weight: 600; color: var(--text-muted); cursor: pointer; transition: all 0.2s; }
        .tab-btn:hover { background: #f1f5f9; color: var(--text-main); }
        .tab-btn.active { background: var(--primary); color: white; border-color: var(--primary); box-shadow: 0 4px 6px -1px rgba(0,0,0,0.1); }
        
        .tab-content { display: none; }
        .tab-content.active { display: block; animation: fadeIn 0.3s ease; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(5px); } to { opacity: 1; transform: translateY(0); } }

        /* Apple-style Table */
        .table-container { background: var(--card-bg); border-radius: 12px; border: 1px solid var(--border-color); overflow: hidden; box-shadow: 0 2px 4px -1px rgba(0,0,0,0.02); }
        .apple-table { width: 100%; border-collapse: collapse; text-align: left; }
        .apple-table th { padding: 16px 20px; font-size: 0.85rem; font-weight: 600; color: var(--text-muted); background: #f8fafc; border-bottom: 1px solid var(--border-color); }
        .apple-table td { padding: 16px 20px; font-size: 0.95rem; color: var(--text-main); border-bottom: 1px solid var(--border-color); vertical-align: middle; }
        .apple-table tbody tr:last-child td { border-bottom: none; }
        .apple-table tbody tr:hover { background-color: #fcfcfc; }

        .book-icon-wrapper { display: flex; align-items: center; gap: 12px; }
        .book-icon { width: 36px; height: 36px; background: #f1f5f9; border-radius: 6px; display: flex; align-items: center; justify-content: center; font-size: 1.2rem; }
        .book-title-text { font-weight: 600; color: var(--text-main); }

        /* Pill Badges */
        .status-pill { display: inline-block; padding: 6px 12px; border-radius: 20px; font-size: 0.8rem; font-weight: 600; }
        .pill-active { background: #dcfce7; color: #166534; }
        .pill-pending { background: #fef08a; color: #854d0e; }
        .pill-returned { background: #e2e8f0; color: #475569; }
        .pill-downloaded { background: #f3e8ff; color: #7e22ce; }

        .table-btn { padding: 8px 14px; border-radius: 6px; font-size: 0.85rem; font-weight: 600; text-decoration: none; border: 1px solid var(--border-color); color: var(--text-main); transition: all 0.2s; background: white; cursor: pointer; display: inline-block; text-align: center; }
        .table-btn:hover { background: #f1f5f9; }
        .table-btn-primary { background: var(--text-main); color: white; border-color: var(--text-main); }
        .table-btn-primary:hover { background: #334155; color: white; }
        
        .empty-state { text-align: center; padding: 40px; color: var(--text-muted); background: var(--card-bg); border-radius: 12px; border: 1px dashed var(--border-color); }
    </style>
</head>
<body>
    <% request.setAttribute("activeMenu", "loans"); %>
    <%@ include file="sidebar.jspf" %>

    <main class="main-content">
        <div class="page-header">
            <div>
                <h1>Aktivitas & Peminjaman</h1>
                <p>Pantau status peminjaman dan riwayat baca Anda di sini.</p>
            </div>
        </div>

        <% 
            String msg = request.getParameter("msg");
            if (msg != null) { out.print("<div class='alert alert-info'>" + msg + "</div>"); }
        %>

        <% if (activeLoans == null || activeLoans.isEmpty()) { %>
            <div class="empty-state">
                <svg width="48" height="48" fill="none" stroke="currentColor" stroke-width="1.5" viewBox="0 0 24 24" style="margin-bottom: 15px; color: #cbd5e1;"><path stroke-linecap="round" stroke-linejoin="round" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253"></path></svg>
                <h3>Belum Ada Aktivitas</h3>
                <p>Anda belum meminjam buku apapun. Kunjungi Katalog untuk mulai membaca.</p>
            </div>
        <% } else { 
            List<Map<String, String>> pendingLoans = new ArrayList<>();
            List<Map<String, String>> activeOnly = new ArrayList<>();
            List<Map<String, String>> returnedLoans = new ArrayList<>();
            List<Map<String, String>> downloadedEbooks = new ArrayList<>();
            
            for (Map<String, String> loan : activeLoans) {
                String status = loan.get("status");
                if (status.equals("PENDING_BORROW") || status.equals("PENDING_RETURN")) {
                    pendingLoans.add(loan);
                } else if (status.equals("ACTIVE")) {
                    activeOnly.add(loan);
                } else if (status.equals("RETURNED")) {
                    returnedLoans.add(loan);
                } else if (status.equals("DOWNLOADED")) {
                    downloadedEbooks.add(loan);
                }
            }
        %>

        <div class="tabs">
            <button class="tab-btn active" onclick="showTab('tab-active')">Sedang Dipinjam (<%= activeOnly.size() %>)</button>
            <button class="tab-btn" onclick="showTab('tab-pending')">Menunggu Konfirmasi (<%= pendingLoans.size() %>)</button>
            <button class="tab-btn" onclick="showTab('tab-returned')">Riwayat Selesai (<%= returnedLoans.size() %>)</button>
            <button class="tab-btn" onclick="showTab('tab-downloaded')">E-Book Terunduh (<%= downloadedEbooks.size() %>)</button>
        </div>

        <!-- 1. Sedang Dipinjam (ACTIVE) -->
        <div id="tab-active" class="tab-content active">
            <% if (activeOnly.isEmpty()) { %>
                <div class="empty-state">Tidak ada buku yang sedang Anda pinjam.</div>
            <% } else { %>
                <div class="table-container">
                    <table class="apple-table">
                        <thead>
                            <tr>
                                <th>Buku / Jurnal</th>
                                <th>Tanggal Pinjam</th>
                                <th>Batas Kembali</th>
                                <th>Status</th>
                                <th>Aksi</th>
                            </tr>
                        </thead>
                        <tbody>
                        <% for (Map<String, String> loan : activeOnly) { %>
                            <tr>
                                <td>
                                    <div class="book-icon-wrapper">
                                        <div class="book-icon">📚</div>
                                        <span class="book-title-text"><%= loan.get("title") %></span>
                                    </div>
                                </td>
                                <td><%= loan.get("loan_date") %></td>
                                <td style="color: var(--primary); font-weight: 600;"><%= loan.get("due_date") %></td>
                                <td><span class="status-pill pill-active">Aktif Dipinjam</span></td>
                                <td>
                                    <div style="display: flex; gap: 8px;">
                                        <a href="ExtendServlet?txId=<%= loan.get("transaction_id") %>" class="table-btn">Perpanjang</a>
                                        <a href="ReturnServlet?txId=<%= loan.get("transaction_id") %>&resourceId=<%= loan.get("resource_id") %>&dueDate=<%= loan.get("due_date") %>" class="table-btn table-btn-primary">Kembalikan</a>
                                    </div>
                                </td>
                            </tr>
                        <% } %>
                        </tbody>
                    </table>
                </div>
            <% } %>
        </div>

        <!-- 2. Menunggu Konfirmasi (PENDING) -->
        <div id="tab-pending" class="tab-content">
            <% if (pendingLoans.isEmpty()) { %>
                <div class="empty-state">Tidak ada permintaan yang menunggu konfirmasi.</div>
            <% } else { %>
                <div class="table-container">
                    <table class="apple-table">
                        <thead>
                            <tr>
                                <th>Buku / Jurnal</th>
                                <th>Tanggal Transaksi</th>
                                <th>Batas Waktu</th>
                                <th>Status Sistem</th>
                            </tr>
                        </thead>
                        <tbody>
                        <% for (Map<String, String> loan : pendingLoans) { 
                            boolean isReturn = loan.get("status").equals("PENDING_RETURN");
                        %>
                            <tr>
                                <td>
                                    <div class="book-icon-wrapper">
                                        <div class="book-icon">⏳</div>
                                        <span class="book-title-text"><%= loan.get("title") %></span>
                                    </div>
                                </td>
                                <td><%= loan.get("loan_date") %></td>
                                <td><%= loan.get("due_date") %></td>
                                <td><span class="status-pill pill-pending"><%= isReturn ? "Tunggu Pengembalian" : "Tunggu Persetujuan" %></span></td>
                            </tr>
                        <% } %>
                        </tbody>
                    </table>
                </div>
            <% } %>
        </div>

        <!-- 3. Selesai (RETURNED) -->
        <div id="tab-returned" class="tab-content">
            <% if (returnedLoans.isEmpty()) { %>
                <div class="empty-state">Belum ada riwayat buku yang selesai dikembalikan.</div>
            <% } else { %>
                <div class="table-container">
                    <table class="apple-table">
                        <thead>
                            <tr>
                                <th>Buku / Jurnal</th>
                                <th>Tanggal Pinjam</th>
                                <th>Status Akhir</th>
                            </tr>
                        </thead>
                        <tbody>
                        <% for (Map<String, String> loan : returnedLoans) { %>
                            <tr>
                                <td>
                                    <div class="book-icon-wrapper">
                                        <div class="book-icon" style="opacity: 0.5;">✅</div>
                                        <span class="book-title-text" style="color: var(--text-muted);"><%= loan.get("title") %></span>
                                    </div>
                                </td>
                                <td><%= loan.get("loan_date") %></td>
                                <td><span class="status-pill pill-returned">Dikembalikan</span></td>
                            </tr>
                        <% } %>
                        </tbody>
                    </table>
                </div>
            <% } %>
        </div>

        <!-- 4. E-Book Terunduh (DOWNLOADED) -->
        <div id="tab-downloaded" class="tab-content">
            <% if (downloadedEbooks.isEmpty()) { %>
                <div class="empty-state">Belum ada e-book yang Anda unduh.</div>
            <% } else { %>
                <div class="table-container">
                    <table class="apple-table">
                        <thead>
                            <tr>
                                <th>Buku Digital / E-Book</th>
                                <th>Tanggal Unduh</th>
                                <th>Keterangan</th>
                            </tr>
                        </thead>
                        <tbody>
                        <% for (Map<String, String> loan : downloadedEbooks) { %>
                            <tr>
                                <td>
                                    <div class="book-icon-wrapper">
                                        <div class="book-icon" style="background: #f3e8ff;">📱</div>
                                        <span class="book-title-text"><%= loan.get("title") %></span>
                                    </div>
                                </td>
                                <td><%= loan.get("loan_date") %></td>
                                <td><span class="status-pill pill-downloaded">Berhasil Diunduh</span></td>
                            </tr>
                        <% } %>
                        </tbody>
                    </table>
                </div>
            <% } %>
        </div>

        <% } %>
    </main>

    <script>
        function showTab(tabId) {
            // Sembunyikan semua konten tab
            const contents = document.querySelectorAll('.tab-content');
            contents.forEach(content => content.classList.remove('active'));
            
            // Hapus kelas aktif dari semua tombol
            const buttons = document.querySelectorAll('.tab-btn');
            buttons.forEach(btn => btn.classList.remove('active'));
            
            // Tampilkan tab yang dipilih
            document.getElementById(tabId).classList.add('active');
            
            // Set tombol yang ditekan jadi aktif
            event.currentTarget.classList.add('active');
        }
    </script>
</body>
</html>