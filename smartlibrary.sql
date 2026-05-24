-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               8.0.30 - MySQL Community Server - GPL
-- Server OS:                    Win64
-- HeidiSQL Version:             12.1.0.6537
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Dumping database structure for smartlibrary
CREATE DATABASE IF NOT EXISTS `smartlibrary` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `smartlibrary`;

-- Dumping structure for table smartlibrary.account
DROP TABLE IF EXISTS `account`;
CREATE TABLE IF NOT EXISTS `account` (
  `username` varchar(50) NOT NULL,
  `password_user` varchar(255) NOT NULL,
  `role` enum('STUDENT','LIBRARIAN') NOT NULL,
  `student_id` varchar(20) DEFAULT NULL,
  `major` varchar(50) DEFAULT NULL,
  `borrow_limit` int DEFAULT '3',
  `employee_id` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table smartlibrary.account: ~2 rows (approximately)
INSERT INTO `account` (`username`, `password_user`, `role`, `student_id`, `major`, `borrow_limit`, `employee_id`) VALUES
	('admin_lib', 'admin123', 'LIBRARIAN', NULL, NULL, 3, 'LIB-001'),
	('budi123', 'pass123', 'STUDENT', '10307240001', 'Informatika', 3, NULL);

-- Dumping structure for table smartlibrary.library_resource
DROP TABLE IF EXISTS `library_resource`;
CREATE TABLE IF NOT EXISTS `library_resource` (
  `id` varchar(20) NOT NULL,
  `title` varchar(100) NOT NULL,
  `author` varchar(100) DEFAULT NULL,
  `year_published` int DEFAULT NULL,
  `is_available` tinyint(1) DEFAULT '1',
  `type` enum('PHYSICAL_BOOK','EBOOK') NOT NULL,
  `isbn` varchar(20) DEFAULT NULL,
  `shelf_location` varchar(50) DEFAULT NULL,
  `condition_status` varchar(20) DEFAULT NULL,
  `file_size` double DEFAULT NULL,
  `file_format` varchar(10) DEFAULT NULL,
  `download_url` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table smartlibrary.library_resource: ~2 rows (approximately)
INSERT INTO `library_resource` (`id`, `title`, `author`, `year_published`, `is_available`, `type`, `isbn`, `shelf_location`, `condition_status`, `file_size`, `file_format`, `download_url`) VALUES
	('DIG-001', 'Mastering Java OOP', 'John Doe', 2023, 1, 'EBOOK', NULL, NULL, NULL, 5.2, 'PDF', 'http://smartlibrary.com/dl/dig-001'),
	('PHY-001', 'Algoritma dan Pemrograman', 'Rinaldi Munir', 2016, 1, 'PHYSICAL_BOOK', '978-602-123', 'Rak A1', 'Good', NULL, NULL, NULL),
	('PHY-002', 'Refactoring UI', 'Adam Wathan & Steve Schoger', 2018, 1, 'PHYSICAL_BOOK', '978-123-456', 'Rak B2', 'New', NULL, NULL, NULL),
	('DIG-002', 'Refactoring UI', 'Adam Wathan & Steve Schoger', 2018, 1, 'EBOOK', NULL, NULL, NULL, 15.4, 'PDF', 'http://smartlibrary.com/dl/dig-002'),
	('DIG-003', 'Clean Code', 'Robert C. Martin', 2008, 1, 'EBOOK', NULL, NULL, NULL, 8.1, 'PDF', 'http://smartlibrary.com/dl/dig-003'),
	('PHY-004', 'The Pragmatic Programmer', 'David Thomas', 1999, 1, 'PHYSICAL_BOOK', '978-020-161', 'Rak C1', 'Good', NULL, NULL, NULL),
	('DIG-005', 'Design Patterns', 'Erich Gamma dkk.', 1994, 1, 'EBOOK', NULL, NULL, NULL, 12.0, 'EPUB', 'http://smartlibrary.com/dl/dig-005'),
	('PHY-006', 'Sapiens: A Brief History of Humankind', 'Yuval Noah Harari', 2011, 1, 'PHYSICAL_BOOK', '978-006-231', 'Rak D1', 'Good', NULL, NULL, NULL),
	('DIG-006', 'Sapiens: A Brief History of Humankind', 'Yuval Noah Harari', 2011, 1, 'EBOOK', NULL, NULL, NULL, 10.5, 'PDF', 'http://smartlibrary.com/dl/dig-006'),
	('PHY-007', 'Atomic Habits', 'James Clear', 2018, 1, 'PHYSICAL_BOOK', '978-073-521', 'Rak D2', 'Good', NULL, NULL, NULL),
	('PHY-008', 'Introduction to Algorithms', 'Thomas H. Cormen', 2009, 0, 'PHYSICAL_BOOK', '978-026-203', 'Rak A2', 'Worn', NULL, NULL, NULL),
	('DIG-008', 'Introduction to Algorithms', 'Thomas H. Cormen', 2009, 1, 'EBOOK', NULL, NULL, NULL, 25.0, 'PDF', 'http://smartlibrary.com/dl/dig-008'),
	('PHY-009', 'Laskar Pelangi', 'Andrea Hirata', 2005, 1, 'PHYSICAL_BOOK', '978-979-306', 'Rak F1', 'Good', NULL, NULL, NULL),
	('PHY-010', 'Bumi Manusia', 'Pramoedya Ananta Toer', 1980, 1, 'PHYSICAL_BOOK', '978-979-973', 'Rak F2', 'Old', NULL, NULL, NULL),
	('DIG-010', 'Bumi Manusia', 'Pramoedya Ananta Toer', 1980, 1, 'EBOOK', NULL, NULL, NULL, 4.3, 'EPUB', 'http://smartlibrary.com/dl/dig-010'),
	('DIG-011', 'Grit: The Power of Passion and Perseverance', 'Angela Duckworth', 2016, 1, 'EBOOK', NULL, NULL, NULL, 6.7, 'PDF', 'http://smartlibrary.com/dl/dig-011'),
	('PHY-012', 'The Lean Startup', 'Eric Ries', 2011, 1, 'PHYSICAL_BOOK', '978-030-788', 'Rak E1', 'Good', NULL, NULL, NULL),
	('PHY-013', 'Thinking, Fast and Slow', 'Daniel Kahneman', 2011, 1, 'PHYSICAL_BOOK', '978-037-427', 'Rak D3', 'Good', NULL, NULL, NULL),
	('DIG-014', 'Deep Work', 'Cal Newport', 2016, 1, 'EBOOK', NULL, NULL, NULL, 3.2, 'EPUB', 'http://smartlibrary.com/dl/dig-014'),
	('PHY-015', 'Head First Design Patterns', 'Eric Freeman', 2004, 1, 'PHYSICAL_BOOK', '978-059-600', 'Rak C2', 'Good', NULL, NULL, NULL),
	('DIG-015', 'Head First Design Patterns', 'Eric Freeman', 2004, 1, 'EBOOK', NULL, NULL, NULL, 14.1, 'PDF', 'http://smartlibrary.com/dl/dig-015'),
	('PHY-016', 'Don\'t Make Me Think', 'Steve Krug', 2000, 1, 'PHYSICAL_BOOK', '978-032-134', 'Rak B3', 'Good', NULL, NULL, NULL),
	('DIG-017', 'You Don\'t Know JS', 'Kyle Simpson', 2015, 1, 'EBOOK', NULL, NULL, NULL, 5.0, 'PDF', 'http://smartlibrary.com/dl/dig-017'),
	('PHY-018', 'The Phoenix Project', 'Gene Kim', 2013, 1, 'PHYSICAL_BOOK', '978-098-826', 'Rak E2', 'Good', NULL, NULL, NULL),
	('PHY-019', 'Cracking the Coding Interview', 'Gayle Laakmann McDowell', 2015, 0, 'PHYSICAL_BOOK', '978-098-478', 'Rak A3', 'Good', NULL, NULL, NULL),
	('DIG-020', 'Structure and Interpretation of Computer Programs', 'Harold Abelson', 1984, 1, 'EBOOK', NULL, NULL, NULL, 11.2, 'PDF', 'http://smartlibrary.com/dl/dig-020');

-- Dumping structure for table smartlibrary.loan_transaction
DROP TABLE IF EXISTS `loan_transaction`;
CREATE TABLE IF NOT EXISTS `loan_transaction` (
  `transaction_id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `resource_id` varchar(20) NOT NULL,
  `loan_date` date NOT NULL,
  `due_date` date NOT NULL,
  `status` enum('BORROWED','RETURNED') DEFAULT 'BORROWED',
  PRIMARY KEY (`transaction_id`),
  KEY `username` (`username`),
  KEY `resource_id` (`resource_id`),
  CONSTRAINT `loan_transaction_ibfk_1` FOREIGN KEY (`username`) REFERENCES `account` (`username`),
  CONSTRAINT `loan_transaction_ibfk_2` FOREIGN KEY (`resource_id`) REFERENCES `library_resource` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table smartlibrary.loan_transaction: ~1 rows (approximately)
INSERT INTO `loan_transaction` (`transaction_id`, `username`, `resource_id`, `loan_date`, `due_date`, `status`) VALUES
	(3, 'budi123', 'PHY-001', '2026-05-05', '2026-05-12', 'RETURNED'),
	(4, 'budi123', 'PHY-001', '2026-05-05', '2026-05-12', 'RETURNED'),
	(5, 'budi123', 'PHY-001', '2026-05-05', '2026-05-12', 'RETURNED'),
	(6, 'budi123', 'PHY-001', '2026-05-05', '2026-05-12', 'RETURNED'),
	(7, 'budi123', 'PHY-001', '2026-05-05', '2026-05-12', 'RETURNED');

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
