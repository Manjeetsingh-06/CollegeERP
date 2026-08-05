package dao;

import model.Faculty;
import util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class FacultyDAO {

    public boolean addFaculty(Faculty faculty, String password) {
        Connection conn = null;
        PreparedStatement psUser = null;
        PreparedStatement psFaculty = null;
        ResultSet rsUser = null;

        String userSql = "INSERT INTO users (username, password, role) VALUES (?, ?, 'FACULTY')";
        String facultySql = "INSERT INTO faculty (user_id, emp_code, full_name, email, phone, dept_id) VALUES (?, ?, ?, ?, ?, ?)";

        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // Transaction

            // 1. Create User Login
            psUser = conn.prepareStatement(userSql, Statement.RETURN_GENERATED_KEYS);
            psUser.setString(1, faculty.getEmpCode().toLowerCase());
            psUser.setString(2, password);
            psUser.executeUpdate();

            rsUser = psUser.getGeneratedKeys();
            int userId = 0;
            if (rsUser.next()) {
                userId = rsUser.getInt(1);
            }

            // 2. Insert Faculty Record
            psFaculty = conn.prepareStatement(facultySql);
            psFaculty.setInt(1, userId);
            psFaculty.setString(2, faculty.getEmpCode());
            psFaculty.setString(3, faculty.getFullName());
            psFaculty.setString(4, faculty.getEmail());
            psFaculty.setString(5, faculty.getPhone());
            psFaculty.setInt(6, faculty.getDeptId());

            int rows = psFaculty.executeUpdate();
            conn.commit();
            return rows > 0;

        } catch (SQLException e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            e.printStackTrace();
        } finally {
            try {
                if (rsUser != null) rsUser.close();
                if (psUser != null) psUser.close();
                if (psFaculty != null) psFaculty.close();
                if (conn != null) conn.close();
            } catch (SQLException e) { e.printStackTrace(); }
        }
        return false;
    }

    public List<Faculty> getAllFaculty() {
        List<Faculty> list = new ArrayList<>();
        String sql = "SELECT f.id, f.user_id, f.emp_code, f.full_name, f.email, f.phone, f.dept_id, d.dept_name, u.username " +
                     "FROM faculty f " +
                     "LEFT JOIN departments d ON f.dept_id = d.id " +
                     "LEFT JOIN users u ON f.user_id = u.id " +
                     "ORDER BY f.id DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Faculty f = new Faculty();
                f.setId(rs.getInt("id"));
                f.setUserId(rs.getInt("user_id"));
                f.setEmpCode(rs.getString("emp_code"));
                f.setFullName(rs.getString("full_name"));
                f.setEmail(rs.getString("email"));
                f.setPhone(rs.getString("phone"));
                f.setDeptId(rs.getInt("dept_id"));
                f.setDeptName(rs.getString("dept_name"));
                f.setUsername(rs.getString("username"));
                list.add(f);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean deleteFaculty(int facultyId, int userId) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            try (PreparedStatement ps1 = conn.prepareStatement("DELETE FROM faculty WHERE id = ?")) {
                ps1.setInt(1, facultyId);
                ps1.executeUpdate();
            }

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

    public int getFacultyCount() {
        String sql = "SELECT COUNT(*) FROM faculty";
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
