<%@page import="model.Account"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Validasi Akses: Hanya Librarian yang boleh masuk
    Account user = (Account) session.getAttribute("userAccount");
    if (user == null || !user.getRole().equals("LIBRARIAN")) {
        response.sendRedirect("index.jsp?error=Akses Ditolak!");
        return;
    }
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tambah Koleksi - SmartLibrary</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="assets/css/style.css">
    <style>
        .page-header { margin-bottom: 30px; }
        .page-header h1 { font-size: 2rem; color: var(--text-main); font-weight: 700; margin-bottom: 5px; }
        .page-header p { color: var(--text-muted); }
        
        .form-card { background: var(--card-bg); border-radius: 16px; padding: 30px; box-shadow: 0 2px 4px -1px rgba(0,0,0,0.02); border: 1px solid var(--border-color); max-width: 800px; }
        
        .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }
        .form-group.full-width { grid-column: span 2; }
        
        .form-group label { display: block; font-weight: 600; color: var(--text-main); margin-bottom: 8px; font-size: 0.95rem; }
        .form-control { width: 100%; padding: 12px 16px; border: 1px solid var(--border-color); border-radius: 8px; font-family: 'Inter', sans-serif; font-size: 0.95rem; transition: border-color 0.2s; box-sizing: border-box; }
        .form-control:focus { outline: none; border-color: var(--primary); box-shadow: 0 0 0 3px rgba(220, 38, 38, 0.1); }
        
        .hidden { display: none !important; }
        
        .btn-submit { background: var(--primary); color: white; border: none; padding: 12px 24px; border-radius: 8px; font-weight: 600; font-size: 1rem; cursor: pointer; transition: all 0.2s; margin-top: 10px; }
        .btn-submit:hover { background: var(--primary-hover); transform: translateY(-1px); box-shadow: 0 4px 6px -1px rgba(220, 38, 38, 0.2); }
        
        .alert { padding: 15px 20px; border-radius: 8px; margin-bottom: 24px; font-weight: 500; }
        .alert-success { background-color: #dcfce7; color: #166534; border: 1px solid #bbf7d0; }
        .alert-error { background-color: #fee2e2; color: #991b1b; border: 1px solid #fecaca; }
        
        .section-divider { margin: 24px 0; border-top: 1px dashed var(--border-color); }
    </style>
    <script>
        // Trik UI: Menampilkan form yang berbeda berdasarkan jenis aset
        function toggleFields() {
            var type = document.getElementById("type").value;
            if (type === "PHYSICAL_BOOK") {
                document.getElementById("physicalFields").classList.remove("hidden");
                document.getElementById("digitalFields").classList.add("hidden");
            } else if (type === "EBOOK") {
                document.getElementById("digitalFields").classList.remove("hidden");
                document.getElementById("physicalFields").classList.add("hidden");
            }
        }
    </script>
</head>
<body onload="toggleFields()">
    <% request.setAttribute("activeMenu", "add_resource"); %>
    <%@ include file="sidebar.jspf" %>

    <main class="main-content">
        <div class="page-header">
            <h1>Tambah Koleksi Baru</h1>
            <p>Masukkan detail buku fisik atau e-book baru ke dalam sistem perpustakaan.</p>
        </div>

        <% 
            String msg = request.getParameter("msg");
            if (msg != null) out.println("<div class='alert alert-success'>" + msg + "</div>");
            String err = request.getParameter("error");
            if (err != null) out.println("<div class='alert alert-error'>" + err + "</div>");
        %>

        <div class="form-card">
            <form action="ManageResourceServlet" method="POST">
                
                <h3 style="margin-top: 0; margin-bottom: 20px; font-size: 1.1rem; color: var(--text-main); border-bottom: 1px solid var(--border-color); padding-bottom: 10px;">Informasi Dasar</h3>
                
                <div class="form-grid">
                    <div class="form-group">
                        <label>ID Buku/Aset</label>
                        <input type="text" name="id" class="form-control" required placeholder="Contoh: PHY-002">
                    </div>
                    <div class="form-group">
                        <label>Tipe Koleksi</label>
                        <select name="type" id="type" class="form-control" onchange="toggleFields()">
                            <option value="PHYSICAL_BOOK">Buku Fisik</option>
                            <option value="EBOOK">E-Book (Digital)</option>
                        </select>
                    </div>
                    <div class="form-group full-width">
                        <label>Judul Buku</label>
                        <input type="text" name="title" class="form-control" required placeholder="Masukkan judul lengkap">
                    </div>
                    <div class="form-group">
                        <label>Penulis</label>
                        <input type="text" name="author" class="form-control" required placeholder="Nama penulis">
                    </div>
                    <div class="form-group">
                        <label>Tahun Terbit</label>
                        <input type="number" name="year" class="form-control" required placeholder="Contoh: 2023">
                    </div>
                </div>

                <div id="physicalFields">
                    <div class="section-divider"></div>
                    <h3 style="margin-bottom: 20px; font-size: 1.1rem; color: var(--text-main);">Detail Buku Fisik</h3>
                    <div class="form-grid">
                        <div class="form-group">
                            <label>ISBN</label>
                            <input type="text" name="isbn" class="form-control" placeholder="Nomor ISBN (Opsional)">
                        </div>
                        <div class="form-group">
                            <label>Lokasi Rak</label>
                            <input type="text" name="shelfLocation" class="form-control" placeholder="Contoh: Rak A-1">
                        </div>
                        <div class="form-group full-width">
                            <label>Kondisi</label>
                            <input type="text" name="conditionStatus" class="form-control" value="Good">
                        </div>
                    </div>
                </div>

                <div id="digitalFields" class="hidden">
                    <div class="section-divider"></div>
                    <h3 style="margin-bottom: 20px; font-size: 1.1rem; color: var(--text-main);">Detail E-Book</h3>
                    <div class="form-grid">
                        <div class="form-group">
                            <label>Ukuran File (MB)</label>
                            <input type="number" step="0.1" name="fileSize" class="form-control" placeholder="Contoh: 2.5">
                        </div>
                        <div class="form-group">
                            <label>Format File</label>
                            <input type="text" name="fileFormat" class="form-control" placeholder="Contoh: PDF / EPUB">
                        </div>
                        <div class="form-group full-width">
                            <label>Link Download</label>
                            <input type="text" name="downloadUrl" class="form-control" placeholder="URL tautan unduh">
                        </div>
                    </div>
                </div>

                <div class="section-divider"></div>
                <div style="display: flex; gap: 12px; align-items: center;">
                    <button type="submit" class="btn-submit">Simpan Koleksi</button>
                    <a href="librarian_dashboard.jsp" style="color: var(--text-muted); font-weight: 500; text-decoration: none;">Batal</a>
                </div>
            </form>
        </div>
    </main>
</body>
</html>