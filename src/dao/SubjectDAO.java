package dao;

import model.Subject;
import util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class SubjectDAO {

    public boolean addSubject(Subject subject) {
        String sql = "INSERT INTO subjects (subject_code, subject_name, dept_id, semester) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, subject.getSubjectCode().toUpperCase());
            ps.setString(2, subject.getSubjectName());
            ps.setInt(3, subject.getDeptId());
            ps.setInt(4, subject.getSemester());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Subject> getAllSubjects() {
        List<Subject> list = new ArrayList<>();
        String sql = "SELECT s.id, s.subject_code, s.subject_name, s.dept_id, s.semester, d.dept_name " +
                     "FROM subjects s LEFT JOIN departments d ON s.dept_id = d.id ORDER BY s.dept_id, s.semester";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Subject sub = new Subject();
                sub.setId(rs.getInt("id"));
                sub.setSubjectCode(rs.getString("subject_code"));
                sub.setSubjectName(rs.getString("subject_name"));
                sub.setDeptId(rs.getInt("dept_id"));
                sub.setDeptName(rs.getString("dept_name"));
                sub.setSemester(rs.getInt("semester"));
                list.add(sub);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Subject> getSubjectsByDeptAndSem(int deptId, int semester) {
        List<Subject> list = new ArrayList<>();
        String sql = "SELECT s.id, s.subject_code, s.subject_name, s.dept_id, s.semester, d.dept_name " +
                     "FROM subjects s LEFT JOIN departments d ON s.dept_id = d.id " +
                     "WHERE s.dept_id = ? AND s.semester = ? ORDER BY s.subject_code";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, deptId);
            ps.setInt(2, semester);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Subject sub = new Subject();
                    sub.setId(rs.getInt("id"));
                    sub.setSubjectCode(rs.getString("subject_code"));
                    sub.setSubjectName(rs.getString("subject_name"));
                    sub.setDeptId(rs.getInt("dept_id"));
                    sub.setDeptName(rs.getString("dept_name"));
                    sub.setSemester(rs.getInt("semester"));
                    list.add(sub);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
