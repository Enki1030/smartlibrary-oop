<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - SmartLibrary 5.0</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="assets/css/style.css">
    <style>
        body, html {
            margin: 0;
            padding: 0;
            height: 100%;
            font-family: 'Inter', sans-serif;
            background-color: #f8fafc;
        }
        
        .split-layout {
            display: flex;
            min-height: 100vh;
            width: 100%;
        }

        /* Left Side: Login */
        .login-side {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 40px;
            background-color: #ffffff;
        }

        .login-container {
            width: 100%;
            max-width: 420px;
        }

        .brand {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 40px;
            color: var(--primary);
            font-size: 1.5rem;
            font-weight: 700;
            letter-spacing: -0.02em;
        }

        .login-title {
            font-size: 2rem;
            font-weight: 800;
            color: var(--text-main);
            margin-bottom: 10px;
            margin-top: 0;
            letter-spacing: -0.02em;
        }

        .login-subtitle {
            color: var(--text-muted);
            margin-bottom: 40px;
            font-size: 1rem;
            line-height: 1.5;
        }

        .form-group {
            margin-bottom: 24px;
        }

        .form-group label {
            display: block;
            font-weight: 600;
            color: var(--text-main);
            margin-bottom: 8px;
            font-size: 0.95rem;
        }

        .form-control {
            width: 100%;
            padding: 14px 16px;
            border: 1px solid var(--border-color);
            border-radius: 12px;
            font-family: 'Inter', sans-serif;
            font-size: 1rem;
            transition: all 0.2s;
            box-sizing: border-box;
            background: #f8fafc;
        }

        .form-control:focus {
            outline: none;
            border-color: var(--primary);
            background: #ffffff;
            box-shadow: 0 0 0 4px rgba(220, 38, 38, 0.1);
        }

        .btn-login {
            width: 100%;
            background: var(--primary);
            color: white;
            border: none;
            padding: 14px;
            border-radius: 12px;
            font-weight: 600;
            font-size: 1rem;
            cursor: pointer;
            transition: all 0.2s;
            margin-top: 10px;
        }

        .btn-login:hover {
            background: var(--primary-hover);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(220, 38, 38, 0.25);
        }

        .alert-error {
            background-color: #fee2e2;
            color: #991b1b;
            border: 1px solid #fecaca;
            padding: 14px 16px;
            border-radius: 12px;
            margin-bottom: 24px;
            font-weight: 500;
            font-size: 0.9rem;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        /* Right Side: Features */
        .feature-side {
            flex: 1.2;
            background: linear-gradient(135deg, #dc2626 0%, #7f1d1d 100%);
            color: white;
            padding: 60px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            position: relative;
            overflow: hidden;
        }

        /* Decorative background elements */
        .feature-side::before {
            content: '';
            position: absolute;
            top: -10%;
            right: -10%;
            width: 500px;
            height: 500px;
            border-radius: 50%;
            background: radial-gradient(circle, rgba(255,255,255,0.1) 0%, rgba(255,255,255,0) 70%);
        }

        .feature-side::after {
            content: '';
            position: absolute;
            bottom: -20%;
            left: -10%;
            width: 600px;
            height: 600px;
            border-radius: 50%;
            background: radial-gradient(circle, rgba(0,0,0,0.2) 0%, rgba(0,0,0,0) 70%);
        }

        .feature-content {
            position: relative;
            z-index: 10;
            max-width: 500px;
            margin: 0 auto;
        }

        .feature-title {
            font-size: 3rem;
            font-weight: 800;
            line-height: 1.1;
            margin-bottom: 24px;
            margin-top: 0;
            letter-spacing: -0.02em;
        }

        .feature-desc {
            font-size: 1.1rem;
            line-height: 1.6;
            opacity: 0.9;
            margin-bottom: 40px;
        }

        .feature-list {
            list-style: none;
            padding: 0;
            margin: 0;
            display: flex;
            flex-direction: column;
            gap: 24px;
        }

        .feature-item {
            display: flex;
            align-items: flex-start;
            gap: 16px;
        }

        .feature-icon {
            width: 40px;
            height: 40px;
            background: rgba(255,255,255,0.2);
            backdrop-filter: blur(10px);
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }

        .feature-text h4 {
            margin: 0 0 6px 0;
            font-size: 1.15rem;
            font-weight: 600;
            letter-spacing: -0.01em;
        }

        .feature-text p {
            margin: 0;
            font-size: 0.95rem;
            opacity: 0.85;
            line-height: 1.5;
        }

        @media (max-width: 900px) {
            .split-layout {
                flex-direction: column-reverse;
            }
            .feature-side {
                padding: 40px 20px;
                flex: auto;
            }
            .feature-title {
                font-size: 2.2rem;
            }
        }
    </style>
</head>
<body>
    <div class="split-layout">
        <!-- Sisi Kiri: Form Login -->
        <div class="login-side">
            <div class="login-container">
                <div class="brand">
                    <svg width="28" height="28" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253"></path></svg>
                    SmartLibrary
                </div>

                <h1 class="login-title">Selamat Datang</h1>
                <p class="login-subtitle">Silakan masukkan detail akun perpustakaan Anda untuk melanjutkan.</p>

                <% 
                    String error = request.getParameter("error");
                    if ("1".equals(error)) {
                %>
                    <div class="alert-error">
                        <svg width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
                        Username atau Password salah!
                    </div>
                <% } else if ("2".equals(error)) { %>
                    <div class="alert-error">
                        <svg width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"></path></svg>
                        Terjadi kesalahan pada Database.
                    </div>
                <% } %>

                <form action="LoginServlet" method="POST">
                    <div class="form-group">
                        <label>Username / NIM</label>
                        <input type="text" name="username" class="form-control" placeholder="Contoh: Budi atau 123456" required autocomplete="off">
                    </div>
                    
                    <div class="form-group">
                        <label>Password</label>
                        <input type="password" name="password" class="form-control" placeholder="Masukkan kata sandi Anda" required>
                    </div>
                    
                    <button type="submit" class="btn-login">Masuk ke Sistem</button>
                </form>
            </div>
        </div>

        <!-- Sisi Kanan: Fitur & Banner -->
        <div class="feature-side">
            <div class="feature-content">
                <h2 class="feature-title">Perpustakaan Digital Masa Depan</h2>
                <p class="feature-desc">Temukan, baca, dan kelola ribuan buku fisik maupun digital dari satu platform cerdas yang dirancang khusus untuk kenyamanan Anda.</p>

                <ul class="feature-list">
                    <li class="feature-item">
                        <div class="feature-icon">
                            <svg width="20" height="20" fill="none" stroke="white" stroke-width="2.5" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M5 13l4 4L19 7"></path></svg>
                        </div>
                        <div class="feature-text">
                            <h4>Katalog Terpadu</h4>
                            <p>Satu pencarian untuk mengakses koleksi buku fisik di rak dan e-book digital secara instan.</p>
                        </div>
                    </li>
                    <li class="feature-item">
                        <div class="feature-icon">
                            <svg width="20" height="20" fill="none" stroke="white" stroke-width="2.5" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
                        </div>
                        <div class="feature-text">
                            <h4>Manajemen Peminjaman</h4>
                            <p>Pantau batas waktu pengembalian, perpanjang masa pinjam, tanpa ribet.</p>
                        </div>
                    </li>
                    <li class="feature-item">
                        <div class="feature-icon">
                            <svg width="20" height="20" fill="none" stroke="white" stroke-width="2.5" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-4l-4 4m0 0l-4-4m4 4V4"></path></svg>
                        </div>
                        <div class="feature-text">
                            <h4>Akses Offline</h4>
                            <p>Unduh e-book favorit Anda untuk dibaca kapan saja, bahkan saat tidak terkoneksi internet.</p>
                        </div>
                    </li>
                </ul>
            </div>
        </div>
    </div>
</body>
</html>