package dao;

import model.Complaint;
import util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ComplaintDAO {

    public boolean submitComplaint(int studentId, String subjectTitle, String description) {
        String sql = "INSERT INTO complaints (student_id, subject_title, description, status) VALUES (?, ?, ?, 'PENDING')";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ps.setString(2, subjectTitle);
            ps.setString(3, description);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Complaint> getAllComplaints() {
        List<Complaint> list = new ArrayList<>();
        String sql = "SELECT c.id, c.student_id, c.subject_title, c.description, c.status, c.admin_response, c.created_at, " +
                     "s.full_name, s.roll_number " +
                     "FROM complaints c JOIN students s ON c.student_id = s.id ORDER BY c.id DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Complaint c = new Complaint();
                c.setId(rs.getInt("id"));
                c.setStudentId(rs.getInt("student_id"));
                c.setStudentName(rs.getString("full_name"));
                c.setRollNumber(rs.getString("roll_number"));
                c.setSubjectTitle(rs.getString("subject_title"));
                c.setDescription(rs.getString("description"));
                c.setStatus(rs.getString("status"));
                c.setAdminResponse(rs.getString("admin_response"));
                c.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(c);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Complaint> getComplaintsByStudent(int studentId) {
        List<Complaint> list = new ArrayList<>();
        String sql = "SELECT id, student_id, subject_title, description, status, admin_response, created_at " +
                     "FROM complaints WHERE student_id = ? ORDER BY id DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Complaint c = new Complaint();
                    c.setId(rs.getInt("id"));
                    c.setStudentId(rs.getInt("student_id"));
                    c.setSubjectTitle(rs.getString("subject_title"));
                    c.setDescription(rs.getString("description"));
                    c.setStatus(rs.getString("status"));
                    c.setAdminResponse(rs.getString("admin_response"));
                    c.setCreatedAt(rs.getTimestamp("created_at"));
                    list.add(c);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean resolveComplaint(int id, String adminResponse) {
        String sql = "UPDATE complaints SET status='RESOLVED', admin_response=? WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, adminResponse);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
