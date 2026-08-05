package dao;

import model.Timetable;
import util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class TimetableDAO {

    public boolean addEntry(Timetable t) {
        String sql = "INSERT INTO timetable (dept_id, semester, day_of_week, subject_id, time_slot, room_no) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, t.getDeptId());
            ps.setInt(2, t.getSemester());
            ps.setString(3, t.getDayOfWeek());
            ps.setInt(4, t.getSubjectId());
            ps.setString(5, t.getTimeSlot());
            ps.setString(6, t.getRoomNo());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Timetable> getTimetableByDeptAndSem(int deptId, int semester) {
        List<Timetable> list = new ArrayList<>();
        String sql = "SELECT t.id, t.dept_id, t.semester, t.day_of_week, t.subject_id, t.time_slot, t.room_no, " +
                     "d.dept_name, s.subject_code, s.subject_name " +
                     "FROM timetable t " +
                     "JOIN departments d ON t.dept_id = d.id " +
                     "JOIN subjects s ON t.subject_id = s.id " +
                     "WHERE t.dept_id = ? AND t.semester = ? " +
                     "ORDER BY FIELD(t.day_of_week,'Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'), t.time_slot";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, deptId);
            ps.setInt(2, semester);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Timetable t = new Timetable();
                    t.setId(rs.getInt("id"));
                    t.setDeptId(rs.getInt("dept_id"));
                    t.setDeptName(rs.getString("dept_name"));
                    t.setSemester(rs.getInt("semester"));
                    t.setDayOfWeek(rs.getString("day_of_week"));
                    t.setSubjectId(rs.getInt("subject_id"));
                    t.setSubjectCode(rs.getString("subject_code"));
                    t.setSubjectName(rs.getString("subject_name"));
                    t.setTimeSlot(rs.getString("time_slot"));
                    t.setRoomNo(rs.getString("room_no"));
                    list.add(t);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean deleteEntry(int id) {
        String sql = "DELETE FROM timetable WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
