package dao;

import model.Marks;
import util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class MarksDAO {

    public boolean saveMarksBatch(List<Marks> marksList) {
        String sql = "INSERT INTO marks (student_id, subject_id, exam_type, marks_obtained, max_marks) " +
                     "VALUES (?, ?, ?, ?, ?) " +
                     "ON DUPLICATE KEY UPDATE marks_obtained = VALUES(marks_obtained), max_marks = VALUES(max_marks)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            for (Marks m : marksList) {
                ps.setInt(1, m.getStudentId());
                ps.setInt(2, m.getSubjectId());
                ps.setString(3, m.getExamType());
                ps.setDouble(4, m.getMarksObtained());
                ps.setDouble(5, m.getMaxMarks());
                ps.addBatch();
            }

            int[] results = ps.executeBatch();
            return results.length > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Marks> getMarksheetByStudent(int studentId) {
        List<Marks> list = new ArrayList<>();
        String sql = "SELECT m.id, m.student_id, m.subject_id, m.exam_type, m.marks_obtained, m.max_marks, " +
                     "s.subject_code, s.subject_name " +
                     "FROM marks m JOIN subjects s ON m.subject_id = s.id " +
                     "WHERE m.student_id = ? ORDER BY s.subject_code, m.exam_type";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, studentId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Marks m = new Marks();
                    m.setId(rs.getInt("id"));
                    m.setStudentId(rs.getInt("student_id"));
                    m.setSubjectId(rs.getInt("subject_id"));
                    m.setExamType(rs.getString("exam_type"));
                    m.setMarksObtained(rs.getDouble("marks_obtained"));
                    m.setMaxMarks(rs.getDouble("max_marks"));
                    m.setSubjectCode(rs.getString("subject_code"));
                    m.setSubjectName(rs.getString("subject_name"));
                    list.add(m);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
