package dao;

import model.FeeStructure;
import model.Payment;
import util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class FeeDAO {

    public boolean saveFeeStructure(FeeStructure fee) {
        String sql = "INSERT INTO fee_structure (dept_id, semester, tuition_fee, exam_fee, other_fee) " +
                     "VALUES (?, ?, ?, ?, ?) " +
                     "ON DUPLICATE KEY UPDATE tuition_fee = VALUES(tuition_fee), exam_fee = VALUES(exam_fee), other_fee = VALUES(other_fee)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, fee.getDeptId());
            ps.setInt(2, fee.getSemester());
            ps.setDouble(3, fee.getTuitionFee());
            ps.setDouble(4, fee.getExamFee());
            ps.setDouble(5, fee.getOtherFee());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<FeeStructure> getAllFeeStructures() {
        List<FeeStructure> list = new ArrayList<>();
        String sql = "SELECT f.id, f.dept_id, f.semester, f.tuition_fee, f.exam_fee, f.other_fee, f.total_fee, d.dept_name " +
                     "FROM fee_structure f JOIN departments d ON f.dept_id = d.id ORDER BY f.dept_id, f.semester";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                FeeStructure fs = new FeeStructure();
                fs.setId(rs.getInt("id"));
                fs.setDeptId(rs.getInt("dept_id"));
                fs.setDeptName(rs.getString("dept_name"));
                fs.setSemester(rs.getInt("semester"));
                fs.setTuitionFee(rs.getDouble("tuition_fee"));
                fs.setExamFee(rs.getDouble("exam_fee"));
                fs.setOtherFee(rs.getDouble("other_fee"));
                fs.setTotalFee(rs.getDouble("total_fee"));
                list.add(fs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public String recordPayment(Payment p) {
        String receiptNo = "REC-" + System.currentTimeMillis() / 1000;
        String sql = "INSERT INTO payments (receipt_no, student_id, amount_paid, payment_date, payment_mode, transaction_id, remarks) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, receiptNo);
            ps.setInt(2, p.getStudentId());
            ps.setDouble(3, p.getAmountPaid());
            ps.setDate(4, p.getPaymentDate());
            ps.setString(5, p.getPaymentMode());
            ps.setString(6, p.getTransactionId());
            ps.setString(7, p.getRemarks());

            if (ps.executeUpdate() > 0) {
                return receiptNo;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public Payment getPaymentByReceipt(String receiptNo) {
        String sql = "SELECT p.id, p.receipt_no, p.student_id, p.amount_paid, p.payment_date, p.payment_mode, p.transaction_id, p.remarks, " +
                     "s.full_name, s.roll_number, d.dept_name, s.semester " +
                     "FROM payments p " +
                     "JOIN students s ON p.student_id = s.id " +
                     "LEFT JOIN departments d ON s.dept_id = d.id " +
                     "WHERE p.receipt_no = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, receiptNo);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Payment p = new Payment();
                    p.setId(rs.getInt("id"));
                    p.setReceiptNo(rs.getString("receipt_no"));
                    p.setStudentId(rs.getInt("student_id"));
                    p.setStudentName(rs.getString("full_name"));
                    p.setRollNumber(rs.getString("roll_number"));
                    p.setDeptName(rs.getString("dept_name"));
                    p.setSemester(rs.getInt("semester"));
                    p.setAmountPaid(rs.getDouble("amount_paid"));
                    p.setPaymentDate(rs.getDate("payment_date"));
                    p.setPaymentMode(rs.getString("payment_mode"));
                    p.setTransactionId(rs.getString("transaction_id"));
                    p.setRemarks(rs.getString("remarks"));
                    return p;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Map<String, Object>> getPendingFeeReport() {
        List<Map<String, Object>> report = new ArrayList<>();
        String sql = "SELECT s.id, s.roll_number, s.full_name, d.dept_name, s.semester, " +
                     "COALESCE(fs.total_fee, 0.00) AS total_fee, " +
                     "COALESCE(SUM(p.amount_paid), 0.00) AS total_paid " +
                     "FROM students s " +
                     "LEFT JOIN departments d ON s.dept_id = d.id " +
                     "LEFT JOIN fee_structure fs ON s.dept_id = fs.dept_id AND s.semester = fs.semester " +
                     "LEFT JOIN payments p ON s.id = p.student_id " +
                     "GROUP BY s.id, s.roll_number, s.full_name, d.dept_name, s.semester, fs.total_fee " +
                     "ORDER BY s.id DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("studentId", rs.getInt("id"));
                map.put("rollNumber", rs.getString("roll_number"));
                map.put("fullName", rs.getString("full_name"));
                map.put("deptName", rs.getString("dept_name"));
                map.put("semester", rs.getInt("semester"));

                double totalFee = rs.getDouble("total_fee");
                double totalPaid = rs.getDouble("total_paid");
                double pendingBalance = totalFee - totalPaid;

                map.put("totalFee", totalFee);
                map.put("totalPaid", totalPaid);
                map.put("pendingBalance", pendingBalance > 0 ? pendingBalance : 0.00);

                report.add(map);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return report;
    }
}
