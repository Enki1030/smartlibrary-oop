<%@page import="model.Student" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<% 
    /* Mengecek apakah ada user yang login di session */
    model.Account user = (model.Account) session.getAttribute("userAccount");
    if (user == null || !user.getRole().equals("STUDENT")) {
        response.sendRedirect("index.jsp"); /* Usir jika belum login atau bukan student */
        return;
    }
%>
            <!DOCTYPE html>
            <html lang="id">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>SmartLibrary - Dashboard Mahasiswa</title>
                <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap"
                    rel="stylesheet">
                <link rel="stylesheet" href="assets/css/style.css">
            </head>

            <body>
                <% request.setAttribute("activeMenu", "dashboard"); %>
                <%@ include file="sidebar.jspf" %>

                <!-- Main Content -->
                <main class="main-content">
                    <div class="top-header">
                        <div>SmartLibrary / <strong>Dashboard</strong></div>
                        <!-- Tombol cari buku dihilangkan dari sini, dipindah ke bawah sesuai permintaan -->
                    </div>

                    <div class="welcome-section">
                        <h2>Selamat Datang, <%= user.getUsername() %>! 👋</h2>
                        <p>Akses cepat ke layanan perpustakaan digital dan fisik Anda.</p>
                    </div>

                    <div class="stats-grid">
                        <div class="stat-card">
                            <div class="stat-title">Buku Dipinjam</div>
                            <!-- Mock Data karena tidak ada di Account. Di real app ini bisa dari query DB -->
                            <div class="stat-value">01</div>
                            <div class="stat-desc">Batas maksimal: <%= ((model.Student)user).getBorrowLimit() %> buku</div>
                        </div>
                        <div class="stat-card">
                            <div class="stat-title">E-Book Diakses</div>
                            <div class="stat-value">12</div>
                            <div class="stat-desc">Total koleksi digital yang pernah dibaca</div>
                        </div>
                        <div class="stat-card">
                            <div class="stat-title">Tenggat Waktu</div>
                            <div class="stat-value">01</div>
                            <div class="stat-desc">Segera kembalikan dalam 3 hari</div>
                        </div>
                    </div>

                    <div class="content-grid">
                        <!-- Left Column: Search & Recommendations -->
                        <div>

                            <div class="section-header">
                                <h3 class="section-title">Rekomendasi Untuk Anda</h3>
                                <a href="CatalogServlet" class="link-view-all">Lihat Semua</a>
                            </div>
                            <div class="recommendation-cards">
                                <div class="book-card">
                                    <span class="badge badge-physical">Fisik</span>
                                    <div class="book-title">Refactoring UI</div>
                                    <div class="book-author">Adam Wathan & Steve Schoger</div>
                                </div>
                                <div class="book-card">
                                    <span class="badge badge-digital">Digital</span>
                                    <div class="book-title">Clean Code</div>
                                    <div class="book-author">Robert C. Martin</div>
                                </div>
                                <div class="book-card">
                                    <span class="badge badge-physical">Fisik</span>
                                    <div class="book-title">The Pragmatic Programmer</div>
                                    <div class="book-author">David Thomas</div>
                                </div>
                                <div class="book-card">
                                    <span class="badge badge-digital">Digital</span>
                                    <div class="book-title">Design Patterns</div>
                                    <div class="book-author">Erich Gamma dkk.</div>
                                </div>
                            </div>
                        </div>

                        <!-- Right Column: Activity -->
                        <div>
                            <div class="activity-card">
                                <h3 class="section-title">Aktivitas Terakhir</h3>
                                <div class="activity-list">
                                    <div class="activity-item">
                                        <div class="activity-dot"></div>
                                        <div class="activity-content">
                                            <h4>Mengembalikan Buku</h4>
                                            <p>Algoritma dan Pemrograman (2 jam yang lalu)</p>
                                        </div>
                                    </div>
                                    <div class="activity-item">
                                        <div class="activity-dot digital"></div>
                                        <div class="activity-content">
                                            <h4>Mengakses E-Book</h4>
                                            <p>Mastering Java OOP (Kemarin)</p>
                                        </div>
                                    </div>
                                    <div class="activity-item">
                                        <div class="activity-dot"></div>
                                        <div class="activity-content">
                                            <h4>Meminjam Buku</h4>
                                            <p>The Pragmatic Programmer (3 hari yang lalu)</p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </main>

            </body>

            </html>