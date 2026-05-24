/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

/**
 *
 * @author ighfir
 */

public class FineCalculator {
    // Konstanta denda (misal: Rp 1.000 per hari keterlambatan)
    private static final double DENDA_PER_HARI = 1000.0;

    // Method static untuk menghitung selisih hari (Date Logic)
    public static int calculatePenaltyDays(LocalDate dueDate, LocalDate returnDate) {
        if (returnDate.isAfter(dueDate)) {
            // Menghitung selisih hari menggunakan class ChronoUnit bawaan Java
            return (int) ChronoUnit.DAYS.between(dueDate, returnDate);
        }
        return 0; // Jika dikembalikan tepat waktu atau lebih awal
    }

    // Method static untuk menghitung nominal denda
    public static double hitungDenda(int penaltyDays) {
        return penaltyDays * DENDA_PER_HARI;
    }
}