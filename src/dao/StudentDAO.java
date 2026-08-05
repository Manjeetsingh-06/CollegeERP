package dao;

import model.Student;
import util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class StudentDAO {

    /**
     * Transactionally adds a student and auto-creates their user login account.
     */
    public boolean addStudent(Student student, String password) {
        Connection conn = null;
        PreparedStatement psUser = null;
        PreparedStatement psStudent = null;
        ResultSet rsUser = null;

        String userSql = "INSERT INTO users (username, password, role) VALUES (?, ?, 'STUDENT')";
        String studentSql = "INSERT INTO students (user_id, roll_number, full_name, email, phone, dept_id, semester) VALUES (?, ?, ?, ?, ?, ?, ?)";

        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // Begin Transaction

            // 1. Create User Login
            psUser = conn.prepareStatement(userSql, Statement.RETURN_GENERATED_KEYS);
            psUser.setString(1, student.getRollNumber().toLowerCase()); // Username is roll number
            psUser.setString(2, password);
            psUser.executeUpdate();

            rsUser = psUser.getGeneratedKeys();
            int userId = 0;
            if (rsUser.next()) {
                userId = rsUser.getInt(1);
            }

            // 2. Insert Student Details
            psStudent = conn.prepareStatement(studentSql);
            psStudent.setInt(1, userId);
            psStudent.setString(2, student.getRollNumber());
            psStudent.setString(3, student.getFullName());
            psStudent.setString(4, student.getEmail());
            psStudent.setString(5, student.getPhone());
            psStudent.setInt(6, student.getDeptId());
            psStudent.setInt(7, student.getSemester());

            int rows = psStudent.executeUpdate();
            conn.commit(); // Commit Transaction
            return rows > 0;

        } catch (SQLException e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            System.err.println("Error adding student: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (rsUser != null) rsUser.close();
                if (psUser != null) psUser.close();
                if (psStudent != null) psStudent.close();
                if (conn != null) conn.close();
            } catch (SQLException e) { e.printStackTrace(); }
        }
        return false;
    }

    public List<Student> getAllStudents() {
        List<Student> list = new ArrayList<>();
        String sql = "SELECT s.id, s.user_id, s.roll_number, s.full_name, s.email, s.phone, s.dept_id, s.semester, d.dept_name, u.username " +
                     "FROM students s " +
                     "LEFT JOIN departments d ON s.dept_id = d.id " +
                     "LEFT JOIN users u ON s.user_id = u.id " +
                     "ORDER BY s.id DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Student s = new Student();
                s.setId(rs.getInt("id"));
                s.setUserId(rs.getInt("user_id"));
                s.setRollNumber(rs.getString("roll_number"));
                s.setFullName(rs.getString("full_name"));
                s.setEmail(rs.getString("email"));
                s.setPhone(rs.getString("phone"));
                s.setDeptId(rs.getInt("dept_id"));
                s.setDeptName(rs.getString("dept_name"));
                s.setSemester(rs.getInt("semester"));
                s.setUsername(rs.getString("username"));
                list.add(s);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Student getStudentById(int id) {
        String sql = "SELECT s.id, s.user_id, s.roll_number, s.full_name, s.email, s.phone, s.dept_id, s.semester, d.dept_name " +
                     "FROM students s LEFT JOIN departments d ON s.dept_id = d.id WHERE s.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Student s = new Student();
                    s.setId(rs.getInt("id"));
                    s.setUserId(rs.getInt("user_id"));
                    s.setRollNumber(rs.getString("roll_number"));
                    s.setFullName(rs.getString("full_name"));
                    s.setEmail(rs.getString("email"));
                    s.setPhone(rs.getString("phone"));
                    s.setDeptId(rs.getInt("dept_id"));
                    s.setDeptName(rs.getString("dept_name"));
                    s.setSemester(rs.getInt("semester"));
                    return s;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateStudent(Student s) {
        String sql = "UPDATE students SET full_name=?, email=?, phone=?, dept_id=?, semester=? WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, s.getFullName());
            ps.setString(2, s.getEmail());
            ps.setString(3, s.getPhone());
            ps.setInt(4, s.getDeptId());
            ps.setInt(5, s.getSemester());
            ps.setInt(6, s.getId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteStudent(int studentId, int userId) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            // Delete student record first
            try (PreparedStatement ps1 = conn.prepareStatement("DELETE FROM students WHERE id = ?")) {
                ps1.setInt(1, studentId);
                ps1.executeUpdate();
            }

            // Delete associated user record
            if (userId > 0) {
                try (PreparedStatement ps2 = conn.prepareStatement("DELETE FROM users WHERE id = ?")) {
                    ps2.setInt(1, userId);
                    ps2.executeUpdate();
                }
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

    public List<Student> searchStudents(String query) {
        List<Student> list = new ArrayList<>();
        String sql = "SELECT s.id, s.user_id, s.roll_number, s.full_name, s.email, s.phone, s.dept_id, s.semester, d.dept_name " +
                     "FROM students s LEFT JOIN departments d ON s.dept_id = d.id " +
                     "WHERE s.full_name LIKE ? OR s.roll_number LIKE ? ORDER BY s.id DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            String pattern = "%" + query + "%";
            ps.setString(1, pattern);
            ps.setString(2, pattern);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Student s = new Student();
                    s.setId(rs.getInt("id"));
                    s.setUserId(rs.getInt("user_id"));
                    s.setRollNumber(rs.getString("roll_number"));
                    s.setFullName(rs.getString("full_name"));
                    s.setEmail(rs.getString("email"));
                    s.setPhone(rs.getString("phone"));
                    s.setDeptId(rs.getInt("dept_id"));
                    s.setDeptName(rs.getString("dept_name"));
                    s.setSemester(rs.getInt("semester"));
                    list.add(s);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int getStudentCount() {
        String sql = "SELECT COUNT(*) FROM students";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}
