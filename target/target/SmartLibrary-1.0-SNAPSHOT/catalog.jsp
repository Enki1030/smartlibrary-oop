<%@page import="java.util.*"%>
<%@page import="model.LibraryResource"%>
<%@page import="model.PhysicalBook"%>
<%@page import="model.EBook"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    List<LibraryResource> rawList = (List<LibraryResource>) request.getAttribute("katalogData");
    
    Map<String, List<LibraryResource>> groupedList = new LinkedHashMap<>();
    if (rawList != null) {
        for (LibraryResource item : rawList) {
            groupedList.computeIfAbsent(item.getTitle(), k -> new ArrayList<>()).add(item);
        }
    }
    
    model.Account currentUser = (model.Account) session.getAttribute("userAccount");
    boolean isStudent = (currentUser != null && currentUser.getRole().equals("STUDENT"));
    String backUrl = (currentUser != null) ? currentUser.getDashboardUrl() : "index.jsp";
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SmartLibrary - Katalog Koleksi</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="assets/css/style.css">
    <style>
        .catalog-container { padding: 32px; flex: 1; }
        .header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px; }
        .title-section h1 { font-size: 2rem; font-weight: 700; color: var(--text-main); }
        .title-section p { color: var(--text-muted); margin-top: 5px; }
        .btn-back { display: inline-flex; align-items: center; gap: 8px; padding: 10px 20px; background-color: var(--card-bg); color: var(--text-main); text-decoration: none; border-radius: 8px; border: 1px solid var(--border-color); font-weight: 500; transition: all 0.2s; }
        .btn-back:hover { border-color: var(--text-muted); background-color: #f1f5f9; }
        .search-container { background: var(--card-bg); padding: 20px; border-radius: 12px; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05); margin-bottom: 40px; display: flex; gap: 15px; }
        .catalog-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(240px, 1fr)); gap: 30px; }
        .book-card { background: var(--card-bg); border-radius: 12px; overflow: hidden; box-shadow: 0 2px 4px -1px rgba(0,0,0,0.02); transition: transform 0.2s, box-shadow 0.2s; display: flex; flex-direction: column; border: 1px solid var(--border-color); }
        .book-card:hover { transform: translateY(-4px); box-shadow: 0 10px 15px -3px rgba(0,0,0,0.05); border-color: var(--primary); }
        
        /* Book Cover Placeholder */
        .book-image-placeholder { 
            aspect-ratio: 3/4; 
            background-color: #e2e8f0; 
            display: flex; align-items: center; justify-content: center; 
            color: var(--text-muted); font-size: 0.9rem; 
            border-bottom: 1px solid var(--border-color); position: relative; 
            cursor: pointer;
        }
        .bg-img-1 { background: linear-gradient(135deg, #f6d365 0%, #fda085 100%); }
        .bg-img-2 { background: linear-gradient(135deg, #84fab0 0%, #8fd3f4 100%); }
        .bg-img-3 { background: linear-gradient(135deg, #a18cd1 0%, #fbc2eb 100%); }
        .bg-img-4 { background: linear-gradient(135deg, #ff9a9e 0%, #fecfef 100%); }
        .book-content { padding: 20px; flex: 1; display: flex; flex-direction: column; cursor: pointer; }
        .book-badges { display: flex; gap: 8px; margin-bottom: 12px; flex-wrap: wrap; }
        .badge-unavailable { background-color: #fef3c7; color: #92400e; }
        .book-title { font-size: 1.15rem; font-weight: 700; color: var(--text-main); margin-bottom: 6px; line-height: 1.4; }
        .book-author { font-size: 0.9rem; color: var(--text-muted); margin-bottom: 15px; }
        
        .card-actions {
            margin-top: auto; 
            padding: 0 20px 20px 20px; 
            display: flex; 
            flex-direction: column; 
            gap: 10px;
        }
        
        .btn-card-action {
            width: 100%; padding: 10px; border-radius: 8px; font-weight: 600; text-align: center; border: none; cursor: pointer; font-size: 0.9rem; transition: background 0.2s;
        }
        .btn-card-phy { background: var(--text-main); color: white; }
        .btn-card-phy:hover { background: #334155; }
        .btn-card-eb { background: var(--primary); color: white; }
        .btn-card-eb:hover { background: var(--primary-hover); }
        .alert { padding: 15px 20px; border-radius: 8px; margin-bottom: 20px; font-weight: 500; }
        .alert-error { background-color: #fee2e2; color: #991b1b; border: 1px solid #f87171; }
        .alert-success { background-color: var(--success-bg); color: var(--success-text); border: 1px solid #86efac; }
        .empty-state { grid-column: 1 / -1; text-align: center; padding: 60px 20px; background: var(--card-bg); border-radius: 12px; border: 1px dashed var(--border-color); color: var(--text-muted); }
        
        /* Modal Detail styling */
        .modal-detail-content { max-width: 600px; padding: 0; overflow: hidden; }
        .modal-banner { height: 180px; display: flex; align-items: center; justify-content: center; position: relative; }
        .modal-banner-title { background: rgba(255,255,255,0.9); padding: 8px 16px; border-radius: 6px; font-weight: 700; color: var(--text-main); text-align: center; max-width: 80%; }
        .modal-body { padding: 30px; }
        .detail-row { display: flex; margin-bottom: 12px; font-size: 0.95rem; }
        .detail-label { width: 120px; font-weight: 600; color: var(--text-muted); flex-shrink: 0; }
        .detail-value { color: var(--text-main); flex-grow: 1; }
        .desc-box { background: #f8fafc; padding: 15px; border-radius: 8px; margin-top: 20px; font-size: 0.9rem; color: var(--text-main); border: 1px solid var(--border-color); line-height: 1.5; }
        .action-container { display: flex; gap: 15px; margin-top: 25px; border-top: 1px solid var(--border-color); padding-top: 25px; }
        .action-card { flex: 1; border: 1px solid var(--border-color); padding: 15px; border-radius: 8px; text-align: center; background: #fafafa; }
        .action-card h4 { margin-bottom: 10px; color: var(--text-main); font-size: 1rem; }
        .action-btn { width: 100%; padding: 10px; border-radius: 6px; font-weight: 600; cursor: pointer; border: none; transition: 0.2s; }
        .btn-physical { background: var(--text-main); color: white; }
        .btn-physical:hover { background: #334155; }
        .btn-digital { background: var(--primary); color: white; }
        .btn-digital:hover { background: #2563eb; }
    </style>
</head>
<body>
    <% request.setAttribute("activeMenu", "catalog"); %>
    <%@ include file="sidebar.jspf" %>

    <main class="main-content">
        <div class="header">
            <div class="title-section">
                <h1>Katalog Koleksi</h1>
                <p>Jelajahi dan pinjam koleksi buku fisik maupun digital kami.</p>
            </div>
            <a href="<%= backUrl %>" class="btn-back">
                <svg width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M10 19l-7-7m0 0l7-7m-7 7h18"></path></svg>
                Kembali
            </a>
        </div>

        <% 
            String error = request.getParameter("error");
            String msg = request.getParameter("msg");
            if (error != null) { out.print("<div class='alert alert-error'>" + error + "</div>"); }
            if (msg != null && msg.equals("success")) { out.print("<div class='alert alert-success'>Permintaan peminjaman berhasil dikirim! Menunggu konfirmasi Admin.</div>"); }
            if (msg != null && msg.contains("diunduh")) { out.print("<div class='alert alert-success'>" + msg + "</div>"); }
        %>

        <div class="search-container">
            <input type="text" id="liveSearchInput" class="search-input" placeholder="Cari judul buku, penulis, atau topik (Ketik untuk mencari otomatis)..." value="<%= request.getParameter("keyword") != null ? request.getParameter("keyword") : "" %>">
        </div>

        <div class="catalog-grid" id="catalogGrid">
            <%
                if (rawList == null) {
            %>
                <div class="empty-state">
                    <h3>Gagal Terhubung ke Database</h3>
                    <p>Katalog tidak dapat dimuat. Pastikan server database XAMPP Anda aktif.</p>
                </div>
            <%
                } else if (groupedList.isEmpty()) {
            %>
                <div class="empty-state">
                    <h3>Tidak Ada Hasil</h3>
                    <p>Buku yang Anda cari tidak ditemukan dalam katalog.</p>
                </div>
            <%
                } else {
                    int imgIndex = 1;
                    for (Map.Entry<String, List<LibraryResource>> entry : groupedList.entrySet()) {
                        String title = entry.getKey();
                        List<LibraryResource> resources = entry.getValue();
                        
                        LibraryResource baseItem = resources.get(0);
                        
                        boolean hasPhysical = false;
                        boolean hasEbook = false;
                        LibraryResource physicalItem = null;
                        LibraryResource ebookItem = null;
                        
                        for (LibraryResource r : resources) {
                            if (r instanceof PhysicalBook) { hasPhysical = true; physicalItem = r; }
                            if (r instanceof EBook) { hasEbook = true; ebookItem = r; }
                        }
                        
                        String bgClass = "bg-img-" + ((imgIndex % 4) + 1);
                        imgIndex++;
                        
                        String safeTitle = title.replace("'", "\\'").replace("\"", "&quot;");
                        String safeAuthor = baseItem.getAuthor().replace("'", "\\'").replace("\"", "&quot;");
                        String publisher = baseItem.getPublisher() != null ? baseItem.getPublisher() : "Tidak diketahui";
                        String safePublisher = publisher.replace("'", "\\'").replace("\"", "&quot;");
                        String desc = baseItem.getDescription() != null ? baseItem.getDescription() : "Tidak ada ringkasan yang tersedia untuk buku ini.";
                        String safeDesc = desc.replace("'", "\\'").replace("\"", "&quot;").replace("\n", " ");
                        
                        String phyId = hasPhysical ? physicalItem.getId() : "";
                        boolean phyAvail = hasPhysical && physicalItem.isAvailable();
                        String ebId = hasEbook ? ebookItem.getId() : "";
                        String ebFormat = hasEbook ? ((EBook)ebookItem).getFileFormat() : "";
                        String ebSize = hasEbook ? ((EBook)ebookItem).getFileSize() + "MB" : "";
            %>
            <div class="book-card" 
                 data-title="<%= title.toLowerCase() %>" 
                 data-author="<%= baseItem.getAuthor().toLowerCase() %>">
                
                <div class="book-image-placeholder <%= bgClass %>" onclick="openDetailModal('<%= safeTitle %>', '<%= safeAuthor %>', '<%= baseItem.getYear() %>', '<%= safePublisher %>', '<%= safeDesc %>', '<%= bgClass %>', '<%= phyId %>', <%= phyAvail %>, '<%= ebId %>', '<%= ebFormat %>', '<%= ebSize %>')">
                    <span style="background: rgba(255,255,255,0.9); padding: 6px 12px; border-radius: 8px; font-weight: 600; color: var(--text-main); font-size: 0.8rem;">Cover: <%= title %></span>
                </div>
                
                <div class="book-content" onclick="openDetailModal('<%= safeTitle %>', '<%= safeAuthor %>', '<%= baseItem.getYear() %>', '<%= safePublisher %>', '<%= safeDesc %>', '<%= bgClass %>', '<%= phyId %>', <%= phyAvail %>, '<%= ebId %>', '<%= ebFormat %>', '<%= ebSize %>')">
                    <div class="book-badges">
                        <% if (hasPhysical) { %>
                            <span class="badge badge-physical">Fisik</span>
                        <% } %>
                        <% if (hasEbook) { %>
                            <span class="badge badge-digital">Digital</span>
                        <% } %>
                        <% if (hasPhysical && !physicalItem.isAvailable()) { %>
                            <span class="badge badge-unavailable">Habis</span>
                        <% } %>
                    </div>
                    
                    <h3 class="book-title"><%= title %></h3>
                    <p class="book-author"><%= baseItem.getAuthor() %></p>
                </div>
                
                <div class="card-actions">
                    <% if (hasPhysical) { 
                        if (phyAvail && isStudent) { %>
                            <form action="BorrowServlet" method="POST" style="margin:0;">
                                <input type="hidden" name="resourceId" value="<%= phyId %>">
                                <button type="submit" class="btn-card-action btn-card-phy" onclick="return confirm('Pinjam buku fisik ini?')">Pinjam Fisik</button>
                            </form>
                        <% } else if (phyAvail && !isStudent) { %>
                            <button disabled class="btn-card-action" style="background:#e2e8f0; color:var(--text-muted); cursor:not-allowed;">Fisik (Login Mahasiswa)</button>
                        <% } else { %>
                            <button disabled class="btn-card-action" style="background:#fef3c7; color:#92400e; cursor:not-allowed;">Fisik Dipinjam</button>
                        <% }
                    } %>
                    
                    <% if (hasEbook) { 
                        if (currentUser != null) { %>
                            <form action="DownloadEbookServlet" method="POST" style="margin:0;">
                                <input type="hidden" name="resourceId" value="<%= ebId %>">
                                <button type="submit" class="btn-card-action btn-card-eb">Baca E-Book</button>
                            </form>
                        <% } else { %>
                            <button disabled class="btn-card-action" style="background:#e2e8f0; color:var(--text-muted); cursor:not-allowed;">E-Book (Login Dulu)</button>
                        <% }
                    } %>
                </div>
            </div>
            <%
                    }
                }
            %>
        </div>
    </main>

    <!-- Unified Detail Modal -->
    <div id="detailModal" class="modal-overlay hidden">
        <div class="modal-content modal-detail-content">
            <button class="modal-close" style="z-index: 10; background: white; border-radius: 50%; width: 30px; height: 30px; right: 15px; top: 15px;" onclick="closeModal('detailModal')">&times;</button>
            
            <div id="mdlBanner" class="modal-banner bg-img-1">
                <div id="mdlBannerTitle" class="modal-banner-title">Judul Buku</div>
            </div>
            
            <div class="modal-body">
                <div class="detail-row">
                    <div class="detail-label">Judul Lengkap</div>
                    <div class="detail-value" id="mdlTitle"></div>
                </div>
                <div class="detail-row">
                    <div class="detail-label">Penulis</div>
                    <div class="detail-value" id="mdlAuthor"></div>
                </div>
                <div class="detail-row">
                    <div class="detail-label">Penerbit</div>
                    <div class="detail-value" id="mdlPublisher"></div>
                </div>
                <div class="detail-row">
                    <div class="detail-label">Tahun Terbit</div>
                    <div class="detail-value" id="mdlYear"></div>
                </div>
                
                <div class="desc-box">
                    <strong style="display:block; margin-bottom:5px; color: var(--text-muted);">Ringkasan / Sinopsis:</strong>
                    <span id="mdlDesc"></span>
                </div>
                
                <div class="action-container" id="mdlActions">
                    <!-- Physical Action -->
                    <div class="action-card" id="phyActionCard" style="display: none;">
                        <h4>Buku Fisik</h4>
                        <p style="font-size: 0.8rem; color: var(--text-muted); margin-bottom: 10px;" id="phyStatus"></p>
                        <% if (isStudent) { %>
                            <form action="BorrowServlet" method="POST" id="phyForm">
                                <input type="hidden" name="resourceId" id="phyResourceId">
                                <button type="submit" class="action-btn btn-physical" id="phyBtn" onclick="return confirm('Apakah Anda yakin ingin meminjam buku fisik ini selama 10 hari?')">Pinjam Buku Fisik</button>
                            </form>
                        <% } else { %>
                            <span style="font-size: 0.8rem; color: #dc2626; font-weight: 500;">Hanya mahasiswa yang dapat meminjam buku fisik.</span>
                        <% } %>
                    </div>
                    
                    <!-- Digital Action -->
                    <div class="action-card" id="ebActionCard" style="display: none;">
                        <h4>E-Book Digital</h4>
                        <p style="font-size: 0.8rem; color: var(--text-muted); margin-bottom: 10px;">Format: <span id="ebFormatText"></span> | <span id="ebSizeText"></span></p>
                        <% if (currentUser != null) { %>
                            <form action="DownloadEbookServlet" method="POST">
                                <input type="hidden" name="resourceId" id="ebResourceId">
                                <button type="submit" class="action-btn btn-digital">Unduh & Simpan ke Riwayat</button>
                            </form>
                        <% } else { %>
                            <span style="font-size: 0.8rem; color: #dc2626; font-weight: 500;">Silakan Login untuk mengunduh.</span>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Live Search Logic
        document.getElementById('liveSearchInput').addEventListener('keyup', function() {
            const queryWords = this.value.toLowerCase().split(/\s+/).filter(word => word.length > 0);
            const cards = document.querySelectorAll('.book-card');
            cards.forEach(card => {
                const title = card.getAttribute('data-title');
                const author = card.getAttribute('data-author');
                const searchString = title + " " + author;
                
                const isMatch = queryWords.every(word => searchString.includes(word));
                
                if (queryWords.length === 0 || isMatch) {
                    card.style.display = 'flex';
                } else {
                    card.style.display = 'none';
                }
            });
        });

        // Detail Modal Logic
        function openDetailModal(title, author, year, publisher, desc, bgClass, phyId, phyAvail, ebId, ebFormat, ebSize) {
            document.getElementById('mdlTitle').innerText = title;
            document.getElementById('mdlBannerTitle').innerText = title;
            document.getElementById('mdlAuthor').innerText = author;
            document.getElementById('mdlYear').innerText = year;
            document.getElementById('mdlPublisher').innerText = publisher;
            document.getElementById('mdlDesc').innerText = desc;
            
            // Set Banner background
            const banner = document.getElementById('mdlBanner');
            banner.className = 'modal-banner ' + bgClass;
            
            // Physical Book Logic
            const phyCard = document.getElementById('phyActionCard');
            if (phyId !== "") {
                phyCard.style.display = 'block';
                document.getElementById('phyResourceId').value = phyId;
                const phyBtn = document.getElementById('phyBtn');
                const phyStatus = document.getElementById('phyStatus');
                if (phyAvail) {
                    phyStatus.innerText = "Tersedia di Perpustakaan";
                    if (phyBtn) { phyBtn.disabled = false; phyBtn.style.opacity = "1"; phyBtn.innerText = "Pinjam Buku Fisik"; }
                } else {
                    phyStatus.innerText = "Stok Sedang Habis/Dipinjam";
                    if (phyBtn) { phyBtn.disabled = true; phyBtn.style.opacity = "0.5"; phyBtn.innerText = "Tidak Tersedia"; }
                }
            } else {
                phyCard.style.display = 'none';
            }
            
            // E-Book Logic
            const ebCard = document.getElementById('ebActionCard');
            if (ebId !== "") {
                ebCard.style.display = 'block';
                document.getElementById('ebResourceId').value = ebId;
                document.getElementById('ebFormatText').innerText = ebFormat;
                document.getElementById('ebSizeText').innerText = ebSize;
            } else {
                ebCard.style.display = 'none';
            }
            
            document.getElementById('detailModal').classList.remove('hidden');
        }

        function closeModal(modalId) {
            document.getElementById(modalId).classList.add('hidden');
        }
    </script>
</body>
</html>