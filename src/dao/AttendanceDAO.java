package dao;

import model.Attendance;
import util.DBConnection;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class AttendanceDAO {

    public boolean markAttendanceBatch(List<Attendance> attendanceList) {
        String sql = "INSERT INTO attendance (student_id, subject_id, attendance_date, status, marked_by) " +
                     "VALUES (?, ?, ?, ?, ?) " +
                     "ON DUPLICATE KEY UPDATE status = VALUES(status), marked_by = VALUES(marked_by)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            for (Attendance att : attendanceList) {
                ps.setInt(1, att.getStudentId());
                ps.setInt(2, att.getSubjectId());
                ps.setDate(3, att.getAttendanceDate());
                ps.setString(4, att.getStatus());
                ps.setString(5, att.getMarkedBy());
                ps.addBatch();
            }

            int[] results = ps.executeBatch();
            return results.length > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Map<String, Object>> getStudentAttendanceSummary(int studentId) {
        List<Map<String, Object>> report = new ArrayList<>();
        String sql = "SELECT sub.subject_code, sub.subject_name, " +
                     "COUNT(a.id) AS total_classes, " +
                     "SUM(CASE WHEN a.status = 'PRESENT' THEN 1 ELSE 0 END) AS present_classes " +
                     "FROM subjects sub " +
                     "LEFT JOIN attendance a ON sub.id = a.subject_id AND a.student_id = ? " +
                     "GROUP BY sub.id, sub.subject_code, sub.subject_name";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, studentId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("subjectCode", rs.getString("subject_code"));
                    map.put("subjectName", rs.getString("subject_name"));
                    int total = rs.getInt("total_classes");
                    int present = rs.getInt("present_classes");
                    double percentage = (total > 0) ? ((double) present / total) * 100.0 : 0.0;

                    map.put("totalClasses", total);
                    map.put("presentClasses", present);
                    map.put("percentage", Math.round(percentage * 10.0) / 10.0);
                    report.add(map);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return report;
    }
}
