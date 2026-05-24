<%@page import="java.util.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    List<Map<String, String>> pendingRequests = (List<Map<String, String>>) request.getAttribute("pendingRequests");
    model.Account user = (model.Account) session.getAttribute("userAccount");
    if (user == null || !user.getRole().equals("LIBRARIAN")) {
        response.sendRedirect("index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SmartLibrary - Persetujuan Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="assets/css/style.css">
    <style>
        .page-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px; }
        .page-header h1 { font-size: 2rem; color: var(--text-main); }
        .page-header p { color: var(--text-muted); margin-top: 5px; }
        .alert { padding: 15px 20px; border-radius: 8px; margin-bottom: 24px; font-weight: 500; }
        .alert-info { background-color: var(--info-bg); color: var(--info-text); border: 1px solid #bae6fd; }
        
        .request-card { background: var(--card-bg); border-radius: 12px; padding: 24px; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05); margin-bottom: 20px; border: 1px solid var(--border-color); display: flex; justify-content: space-between; align-items: flex-start; }
        .request-card:hover { border-color: var(--primary); }
        
        .req-title { font-size: 1.1rem; font-weight: 600; margin-bottom: 8px; color: var(--text-main); }
        .req-detail { font-size: 0.9rem; color: var(--text-muted); margin-bottom: 4px; display: flex; gap: 8px; }
        .req-detail span { font-weight: 500; color: var(--text-main); }
        
        .badge-type { display: inline-block; padding: 6px 12px; border-radius: 20px; font-size: 0.75rem; font-weight: 600; margin-bottom: 12px; }
        .badge-borrow { background-color: #fef08a; color: #854d0e; }
        .badge-return { background-color: #e0e7ff; color: #3730a3; }
        
        .actions { display: flex; gap: 10px; flex-direction: column; min-width: 150px; }
        .btn { padding: 10px 16px; border-radius: 8px; font-weight: 600; cursor: pointer; text-decoration: none; border: none; font-size: 0.9rem; transition: background 0.2s; text-align: center; width: 100%; }
        .btn-approve { background-color: var(--success-bg); color: var(--success-text); border: 1px solid #86efac; }
        .btn-approve:hover { background-color: #bbf7d0; }
        .btn-reject { background-color: #fee2e2; color: #991b1b; border: 1px solid #f87171; }
        .btn-reject:hover { background-color: #fecaca; }
        
        .empty-state { text-align: center; padding: 60px; color: var(--text-muted); background: var(--card-bg); border-radius: 12px; border: 1px dashed var(--border-color); }
    </style>
</head>
<body>
    <% request.setAttribute("activeMenu", "approval"); %>
    <%@ include file="sidebar.jspf" %>

    <main class="main-content">
        <div class="page-header">
            <div>
                <h1>Persetujuan Peminjaman</h1>
                <p>Kelola permintaan peminjaman dan pengembalian buku dari mahasiswa.</p>
            </div>
        </div>

        <% 
            String msg = request.getParameter("msg");
            if (msg != null) { out.print("<div class='alert alert-info'>" + msg + "</div>"); }
        %>

        <% if (pendingRequests == null || pendingRequests.isEmpty()) { %>
            <div class="empty-state">
                <svg width="48" height="48" fill="none" stroke="currentColor" stroke-width="1.5" viewBox="0 0 24 24" style="margin-bottom: 15px; color: #cbd5e1;"><path stroke-linecap="round" stroke-linejoin="round" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
                <h3>Tidak Ada Permintaan</h3>
                <p>Saat ini tidak ada permintaan yang perlu ditinjau.</p>
            </div>
        <% } else { 
            for (Map<String, String> req : pendingRequests) { 
                boolean isBorrow = req.get("status").equals("PENDING_BORROW");
        %>
            <div class="request-card" style="border-left: 4px solid <%= isBorrow ? "#eab308" : "#4f46e5" %>;">
                <div>
                    <span class="badge-type <%= isBorrow ? "badge-borrow" : "badge-return" %>">
                        <%= isBorrow ? "Permintaan Pinjam Buku" : "Permintaan Pengembalian Buku" %>
                    </span>
                    <h3 class="req-title"><%= req.get("title") %></h3>
                    <div class="req-detail">Peminjam (Username): <span><%= req.get("username") %></span></div>
                    <% if (isBorrow) { %>
                        <div class="req-detail" style="font-size: 0.8rem; font-style: italic;">*Detail data diri (NIM/Jurusan) akan terintegrasi dengan Profil Akun di update selanjutnya.</div>
                    <% } %>
                    <div class="req-detail">Tanggal Transaksi: <span><%= req.get("loan_date") %></span></div>
                </div>
                <div class="actions">
                    <form action="AdminApprovalServlet" method="POST" style="display:inline;">
                        <input type="hidden" name="txId" value="<%= req.get("transaction_id") %>">
                        <input type="hidden" name="resourceId" value="<%= req.get("resource_id") %>">
                        <input type="hidden" name="currentStatus" value="<%= req.get("status") %>">
                        <input type="hidden" name="action" value="approve">
                        <button type="submit" class="btn btn-approve">
                            <%= isBorrow ? "Setujui Pinjam" : "Setujui Kembali" %>
                        </button>
                    </form>
                    <form action="AdminApprovalServlet" method="POST" style="display:inline;">
                        <input type="hidden" name="txId" value="<%= req.get("transaction_id") %>">
                        <input type="hidden" name="resourceId" value="<%= req.get("resource_id") %>">
                        <input type="hidden" name="currentStatus" value="<%= req.get("status") %>">
                        <input type="hidden" name="action" value="reject">
                        <button type="submit" class="btn btn-reject">Tolak</button>
                    </form>
                </div>
            </div>
        <% }} %>

    </main>
</body>
</html>
