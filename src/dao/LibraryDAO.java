package dao;

import model.Book;
import model.BookIssue;
import util.DBConnection;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class LibraryDAO {

    public boolean addBook(Book book) {
        String sql = "INSERT INTO books (isbn, title, author, category, total_copies, available_copies) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, book.getIsbn());
            ps.setString(2, book.getTitle());
            ps.setString(3, book.getAuthor());
            ps.setString(4, book.getCategory());
            ps.setInt(5, book.getTotalCopies());
            ps.setInt(6, book.getTotalCopies()); // Initially available = total

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Book> getAllBooks() {
        List<Book> list = new ArrayList<>();
        String sql = "SELECT id, isbn, title, author, category, total_copies, available_copies FROM books ORDER BY id DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(new Book(
                    rs.getInt("id"),
                    rs.getString("isbn"),
                    rs.getString("title"),
                    rs.getString("author"),
                    rs.getString("category"),
                    rs.getInt("total_copies"),
                    rs.getInt("available_copies")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean issueBook(int bookId, int studentId, Date issueDate, Date dueDate) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // Transaction

            // 1. Insert Issue Record
            String issueSql = "INSERT INTO book_issues (book_id, student_id, issue_date, due_date, status) VALUES (?, ?, ?, ?, 'ISSUED')";
            try (PreparedStatement ps1 = conn.prepareStatement(issueSql)) {
                ps1.setInt(1, bookId);
                ps1.setInt(2, studentId);
                ps1.setDate(3, issueDate);
                ps1.setDate(4, dueDate);
                ps1.executeUpdate();
            }

            // 2. Decrement Available Copies
            String decSql = "UPDATE books SET available_copies = available_copies - 1 WHERE id = ? AND available_copies > 0";
            try (PreparedStatement ps2 = conn.prepareStatement(decSql)) {
                ps2.setInt(1, bookId);
                ps2.executeUpdate();
            }

            conn.commit();
            return true;
        } catch (SQLException e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            e.printStackTrace();
        } finally {
            try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
        return false;
    }

    public boolean returnBook(int issueId, Date returnDate) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            // Fetch issue info to calculate fine
            String getSql = "SELECT book_id, due_date FROM book_issues WHERE id = ?";
            int bookId = 0;
            Date dueDate = null;
            try (PreparedStatement psGet = conn.prepareStatement(getSql)) {
                psGet.setInt(1, issueId);
                try (ResultSet rs = psGet.executeQuery()) {
                    if (rs.next()) {
                        bookId = rs.getInt("book_id");
                        dueDate = rs.getDate("due_date");
                    }
                }
            }

            double fine = 0.0;
            if (dueDate != null && returnDate.after(dueDate)) {
                long diffMs = returnDate.getTime() - dueDate.getTime();
                long diffDays = diffMs / (1000 * 60 * 60 * 24);
                fine = diffDays * 10.0; // ₹10 per day fine
            }

            // Update Issue Status & Fine
            String returnSql = "UPDATE book_issues SET return_date = ?, fine_amount = ?, status = 'RETURNED' WHERE id = ?";
            try (PreparedStatement ps1 = conn.prepareStatement(returnSql)) {
                ps1.setDate(1, returnDate);
                ps1.setDouble(2, fine);
                ps1.setInt(3, issueId);
                ps1.executeUpdate();
            }

            // Increment Available Copies
            String incSql = "UPDATE books SET available_copies = available_copies + 1 WHERE id = ?";
            try (PreparedStatement ps2 = conn.prepareStatement(incSql)) {
                ps2.setInt(1, bookId);
                ps2.executeUpdate();
            }

            conn.commit();
            return true;
        } catch (SQLException e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            e.printStackTrace();
        } finally {
            try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
        return false;
    }

    public List<BookIssue> getAllIssuedBooks() {
        List<BookIssue> list = new ArrayList<>();
        String sql = "SELECT bi.id, bi.book_id, bi.student_id, bi.issue_date, bi.due_date, bi.return_date, bi.fine_amount, bi.status, " +
                     "b.title AS book_title, b.isbn, s.full_name, s.roll_number " +
                     "FROM book_issues bi " +
                     "JOIN books b ON bi.book_id = b.id " +
                     "JOIN students s ON bi.student_id = s.id " +
                     "ORDER BY bi.id DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                BookIssue bi = new BookIssue();
                bi.setId(rs.getInt("id"));
                bi.setBookId(rs.getInt("book_id"));
                bi.setBookTitle(rs.getString("book_title"));
                bi.setIsbn(rs.getString("isbn"));
                bi.setStudentId(rs.getInt("student_id"));
                bi.setStudentName(rs.getString("full_name"));
                bi.setRollNumber(rs.getString("roll_number"));
                bi.setIssueDate(rs.getDate("issue_date"));
                bi.setDueDate(rs.getDate("due_date"));
                bi.setReturnDate(rs.getDate("return_date"));
                bi.setFineAmount(rs.getDouble("fine_amount"));
                bi.setStatus(rs.getString("status"));
                list.add(bi);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
