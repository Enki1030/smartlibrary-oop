package utils;

import java.sql.Connection;
import java.sql.Statement;
import java.sql.SQLException;

public class DatabaseMigration {

    public static void runMigrations() {
        try (Connection conn = DBConnection.getConnection()) {
            try (Statement stmt = conn.createStatement()) {
                // Tambahkan kolom ke library_resource
                try { stmt.execute("ALTER TABLE library_resource ADD COLUMN description TEXT;"); } catch (SQLException e) {}
                try { stmt.execute("ALTER TABLE library_resource ADD COLUMN publisher VARCHAR(100);"); } catch (SQLException e) {}
                
                // Tambahkan kolom ke loan_transaction
                try { stmt.execute("ALTER TABLE loan_transaction ADD COLUMN nim VARCHAR(20);"); } catch (SQLException e) {}
                try { stmt.execute("ALTER TABLE loan_transaction ADD COLUMN jurusan VARCHAR(100);"); } catch (SQLException e) {}
                try { 
                    stmt.execute("ALTER TABLE loan_transaction ADD COLUMN status VARCHAR(20) DEFAULT 'ACTIVE';"); 
                } catch (SQLException e) {
                    // Jika kolom status sudah ada, ubah tipenya agar muat 'PENDING_BORROW' (14 chars)
                    try { stmt.execute("ALTER TABLE loan_transaction MODIFY COLUMN status VARCHAR(50) DEFAULT 'ACTIVE';"); } catch (SQLException ex) {}
                }
                
                // Set default status for old rows
                stmt.execute("UPDATE loan_transaction SET status = 'ACTIVE' WHERE status IS NULL OR status = 'BORROWED';");
                
                System.out.println("Database migrations applied successfully.");
            }
        } catch (Exception e) {
            System.err.println("Migration warning: " + e.getMessage());
        }
    }
}
