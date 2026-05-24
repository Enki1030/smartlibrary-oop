# 📚 SmartLibrary: Hybrid Resource Management System 

![Java](https://img.shields.io/badge/Java-ED8B00?style=for-the-badge&logo=java&logoColor=white)
![MySQL](https://img.shields.io/badge/MySQL-005C84?style=for-the-badge&logo=mysql&logoColor=white)
![Apache Tomcat](https://img.shields.io/badge/Apache%20Tomcat-F8DC75?style=for-the-badge&logo=apachetomcat&logoColor=black)
![Maven](https://img.shields.io/badge/Maven-C71A36?style=for-the-badge&logo=apachemaven&logoColor=white)

**SmartLibrary 5.0** adalah sistem manajemen perpustakaan modern berbasis Web MVC (Model-View-Controller) yang dirancang untuk mengelola aset perpustakaan secara *hybrid*—mengintegrasikan pengelolaan buku fisik (cetak) dan aset digital (E-Book) ke dalam satu arsitektur terpusat. 

Proyek ini dibangun menggunakan **Java Servlet & JSP** guna memenuhi Tugas Besar Mata Kuliah Pemrograman Berorientasi Objek (PBO) IF-04-04 di Telkom University Surabaya.

---

## ✨ Fitur Utama (OOP Implementation)

Sistem ini bukan sekadar aplikasi CRUD biasa, melainkan implementasi murni dari prinsip-prinsip Object-Oriented Programming (OOP):

- **Inheritance & Abstraction:** Pemisahan entitas secara hierarkis menggunakan *Abstract Class* `LibraryResource` yang diturunkan menjadi `PhysicalBook` dan `EBook`.
- **Polymorphism:** Tampilan aksi pada katalog secara dinamis menyesuaikan tipe objek (Tombol "Pinjam Buku" untuk aset fisik vs "Akses Digital" untuk E-Book) tanpa pengkondisian logika UI yang panjang.
- **Interface Driven:** Menggunakan interface `Loanable` untuk mengunci kontrak metode peminjaman, memastikan hanya buku fisik yang dapat diproses dalam `LoanTransaction`.
- **Encapsulation & Robustness:** Pembatasan akses atribut kelas dengan *modifier* `private`, dipadukan dengan *Exception Handling* (`try-catch`) pada level Servlet untuk menjaga stabilitas interaksi dengan *database*.
- **Role-Based Access Control (RBAC):** Hierarki akun dengan *class* induk `Account` yang membedakan hak akses antara `Student` (Peminjaman) dan `Librarian` (Manajemen Inventaris).

---

## 🛠️ Tech Stack & Architecture

* **Arsitektur:** Model-View-Controller (MVC)
* **Backend:** Java (Jakarta EE 9.1), Servlet
* **Frontend:** JSP (JavaServer Pages), HTML5, CSS3, JavaScript
* **Database:** MySQL (dengan pendekatan *Single Table Inheritance*)
* **Build Tool:** Apache Maven
* **Server Container:** Apache Tomcat (v10+)

---

## 👨‍💻 Tim Pengembang

Proyek ini dikembangkan secara kolaboratif dengan pembagian struktur kelas yang spesifik untuk setiap anggota:

| Nama | Peran & Tanggung Jawab OOP |
| :--- | :--- |
| **Ighfir Maulana** | **Core Catalog Architect:** Merancang hierarki `LibraryResource` & `PhysicalBook`. |
| **Niko Rajani Syahputra Pane** | **Digital Asset Specialist:** Logika aset digital, `EBook`, dan interface `Downloadable`. |
| **Nur Ro'yul Amin** | **Transaction Engine:** Logika peminjaman, `FineCalculator` (Date Logic), & Exception Handling. |
| **Abdullah Azzam** | **Access Control System:** Hierarki `Account`, Autentikasi, & Manajemen Session. |
| **Naufal Luthfi Muzzaki** | **Data Aggregator:** Arsitektur sistem `Library`, integrasi ArrayList, & fungsionalitas `SearchEngine`. |

---

## 🚀 Panduan Instalasi & Menjalankan Proyek Lokal

Ikuti langkah-langkah berikut untuk menjalankan SmartLibrary 5.0 di mesin lokal (*localhost*):

### 1. Persiapan Database (MySQL)
1. Nyalakan modul **Apache** dan **MySQL** pada XAMPP.
2. Buka phpMyAdmin (`http://localhost/phpmyadmin`).
3. Buat database baru dengan nama `smartlibrary`.
4. Lakukan **Import** pada file `smartlibrary.sql` yang terdapat di *root* repositori ini.

### 2. Setup Proyek (NetBeans & Maven)
1. Lakukan `git clone` repositori ini ke komputer lokal Anda.
2. Buka IDE NetBeans, pilih **File > Open Project**, lalu arahkan ke folder repositori hasil *clone*.
3. NetBeans (melalui Maven) akan secara otomatis mengunduh semua *dependencies* (seperti `mysql-connector-java` dan `jakartaee-web-api`).
4. Pastikan server **Apache Tomcat** sudah terkonfigurasi di NetBeans Anda.
5. Klik kanan pada proyek, pilih **Clean and Build**.

### 3. Eksekusi
1. Klik **Run Project** (atau tekan F6).
2. Browser akan terbuka otomatis mengarah ke `http://localhost:8080/SmartLibraryWeb/`.
3. Gunakan kredensial *dummy* berikut untuk menguji sistem:
   * **Login Mahasiswa:** Username: `budi123` | Password: `pass123`
   * **Login Librarian:** Username: `admin_lib` | Password: `admin123`

---

## 📁 Struktur Direktori Utama

```text
📦 SmartLibraryWeb
 ┣ 📂 src/main/java
 ┃ ┣ 📂 controller       # Servlet untuk logika rute dan transaksi (Login, Borrow, Catalog)
 ┃ ┣ 📂 model            # Class inti berbasis OOP (Inheritance, Interface, Engine)
 ┃ ┗ 📂 utils            # Kelas utilitas seperti DBConnection
 ┣ 📂 src/main/webapp    # Halaman UI berformat JSP
 ┃ ┣ 📜 index.jsp                # Form Login
 ┃ ┣ 📜 catalog.jsp              # Halaman Katalog Terpadu
 ┃ ┣ 📜 student_dashboard.jsp    # Dashboard Mahasiswa
 ┃ ┗ 📜 librarian_dashboard.jsp  # Dashboard Admin
 ┣ 📜 pom.xml            # Konfigurasi Maven
 ┗ 📜 smartlibrary.sql   # Dump Database MySQL
