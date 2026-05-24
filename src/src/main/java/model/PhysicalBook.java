/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author ighfir
 */

public class PhysicalBook extends LibraryResource implements Loanable {
    private String isbn;
    private String shelfLocation;

    public PhysicalBook(String id, String title, String author, int year, boolean isAvailable, String isbn, String shelfLocation) {
        super(id, title, author, year, isAvailable);
        this.isbn = isbn;
        this.shelfLocation = shelfLocation;
    }

    @Override
    public String getDetailInfo() {
        return "Buku Fisik | Lokasi: " + shelfLocation + " | ISBN: " + isbn;
    }

    // Implementasi method dari interface Loanable
    @Override
    public void borrowItem(Account user) throws Exception {
        if (!this.isAvailable) {
            // Melempar exception jika buku sudah dipinjam (Robustness)
            throw new Exception("Buku ini sedang tidak tersedia untuk dipinjam.");
        }
        if (!user.getRole().equals("STUDENT")) {
            throw new Exception("Hanya mahasiswa yang diperbolehkan meminjam buku fisik.");
        }
        // Ubah status internal objek
        this.isAvailable = false; 
    }

    @Override
    public void returnItem() {
        this.isAvailable = true;
    }
}