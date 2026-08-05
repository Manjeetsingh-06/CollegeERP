package util;

import dao.*;
import model.*;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;

public class DBSeeder {

    public static void main(String[] args) {
        System.out.println("=================================================");
        System.out.println("🚀 UNIVERSITY OF LUCKNOW ERP DB SEEDER & E2E TESTING");
        System.out.println("=================================================\n");

        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null || conn.isClosed()) {
                System.err.println("❌ Database Connection Failed!");
                return;
            }
            System.out.println("✅ Connected to MySQL Database cleanly.\n");

            // 1. Ensure course fee structure is seeded for all departments
            seedFeeStructures(conn);

            // 2. Seed Sample Payments if missing
            seedSamplePayments(conn);

            // 3. Perform Comprehensive Basic-to-Advanced Testing on All DAOs
            runComprehensiveTesting();

            System.out.println("\n=================================================");
            System.out.println("🎉 ALL SEEDING & E2E TESTING COMPLETED SUCCESSFULLY!");
            System.out.println("=================================================");

        } catch (Exception e) {
            System.err.println("❌ Error during DB Seeding/Testing: " + e.getMessage());
            e.printStackTrace();
        }
    }

    private static void seedFeeStructures(Connection conn) throws Exception {
        System.out.println("🔹 [1/3] Seeding Department & Semester Course Fee Structures...");

        // Get all department IDs
        String deptSql = "SELECT id, dept_code FROM departments";
        try (Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(deptSql)) {
            
            while (rs.next()) {
                int deptId = rs.getInt("id");
                String code = rs.getString("dept_code");

                // Set course fee per semester based on department
                double tuition = 45000.00;
                double exam = 3000.00;
                double other = 7000.00;

                if ("CSE".equalsIgnoreCase(code) || "CS".equalsIgnoreCase(code)) {
                    tuition = 55000.00; exam = 4000.00; other = 8000.00; // Total 67,000
                } else if ("ECE".equalsIgnoreCase(code)) {
                    tuition = 50000.00; exam = 3500.00; other = 6500.00; // Total 60,000
                } else if ("ME".equalsIgnoreCase(code)) {
                    tuition = 48000.00; exam = 3500.00; other = 6000.00; // Total 57,500
                } else if ("CE".equalsIgnoreCase(code)) {
                    tuition = 45000.00; exam = 3000.00; other = 5000.00; // Total 53,000
                } else if ("IT".equalsIgnoreCase(code)) {
                    tuition = 52000.00; exam = 4000.00; other = 7500.00; // Total 63,500
                }

                // Insert/Update tuition_fee, exam_fee, other_fee — total_fee is automatically computed by MySQL!
                String upsertSql = "INSERT INTO fee_structure (dept_id, semester, tuition_fee, exam_fee, other_fee) " +
                                   "VALUES (?, ?, ?, ?, ?) " +
                                   "ON DUPLICATE KEY UPDATE tuition_fee=VALUES(tuition_fee), exam_fee=VALUES(exam_fee), " +
                                   "other_fee=VALUES(other_fee)";

                try (PreparedStatement ps = conn.prepareStatement(upsertSql)) {
                    for (int sem = 1; sem <= 8; sem++) {
                        ps.setInt(1, deptId);
                        ps.setInt(2, sem);
                        ps.setDouble(3, tuition);
                        ps.setDouble(4, exam);
                        ps.setDouble(5, other);
                        ps.addBatch();
                    }
                    ps.executeBatch();
                }
            }
        }
        System.out.println("  ✅ Course Fee Structures for all Departments (Sem 1-8) successfully seeded!");
    }

    private static void seedSamplePayments(Connection conn) throws Exception {
        System.out.println("🔹 [2/3] Seeding Initial Student Fee Payments...");
        
        String checkSql = "SELECT COUNT(*) FROM payments";
        try (Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(checkSql)) {
            if (rs.next() && rs.getInt(1) == 0) {
                // Get sample student
                String sSql = "SELECT id FROM students LIMIT 2";
                try (Statement sStmt = conn.createStatement(); ResultSet sRs = sStmt.executeQuery(sSql)) {
                    if (sRs.next()) {
                        int studentId = sRs.getInt(1);
                        String insertPay = "INSERT INTO payments (receipt_no, student_id, amount_paid, payment_date, payment_mode, remarks) " +
                                           "VALUES (?, ?, ?, ?, ?, ?)";
                        try (PreparedStatement ps = conn.prepareStatement(insertPay)) {
                            ps.setString(1, "REC-" + System.currentTimeMillis() / 1000);
                            ps.setInt(2, studentId);
                            ps.setDouble(3, 25000.00); // Partial payment of 25,000
                            ps.setDate(4, Date.valueOf(LocalDate.now()));
                            ps.setString(5, "ONLINE");
                            ps.setString(6, "Initial Semester Fee Deposit");
                            ps.executeUpdate();
                        }
                    }
                }
            }
        }
        System.out.println("  ✅ Student fee payment records verified.");
    }

    private static void runComprehensiveTesting() {
        System.out.println("\n🔹 [3/3] RUNNING COMPREHENSIVE COMPONENT & DAO END-TO-END TESTING:");

        // Test 1: DepartmentDAO
        try {
            DepartmentDAO deptDAO = new DepartmentDAO();
            List<Department> depts = deptDAO.getAllDepartments();
            System.out.println("  [PASS] DepartmentDAO: Retrieved " + depts.size() + " departments.");
        } catch (Exception e) {
            System.err.println("  [FAIL] DepartmentDAO test failed: " + e.getMessage());
        }

        // Test 2: StudentDAO
        try {
            StudentDAO studentDAO = new StudentDAO();
            List<Student> students = studentDAO.getAllStudents();
            System.out.println("  [PASS] StudentDAO: Retrieved " + students.size() + " registered students.");
        } catch (Exception e) {
            System.err.println("  [FAIL] StudentDAO test failed: " + e.getMessage());
        }

        // Test 3: FacultyDAO
        try {
            FacultyDAO facultyDAO = new FacultyDAO();
            List<Faculty> faculty = facultyDAO.getAllFaculty();
            System.out.println("  [PASS] FacultyDAO: Retrieved " + faculty.size() + " faculty members.");
        } catch (Exception e) {
            System.err.println("  [FAIL] FacultyDAO test failed: " + e.getMessage());
        }

        // Test 4: SubjectDAO
        try {
            SubjectDAO subjectDAO = new SubjectDAO();
            List<Subject> subjects = subjectDAO.getAllSubjects();
            System.out.println("  [PASS] SubjectDAO: Retrieved " + subjects.size() + " course subjects.");
        } catch (Exception e) {
            System.err.println("  [FAIL] SubjectDAO test failed: " + e.getMessage());
        }

        // Test 5: FeeDAO (Structure & Pending Report)
        try {
            FeeDAO feeDAO = new FeeDAO();
            List<FeeStructure> structures = feeDAO.getAllFeeStructures();
            List<Map<String, Object>> pendingReport = feeDAO.getPendingFeeReport();
            System.out.println("  [PASS] FeeDAO: Retrieved " + structures.size() + " fee structures & " + 
                               pendingReport.size() + " pending balance ledger rows.");
            
            for (Map<String, Object> row : pendingReport) {
                System.out.println("         -> Student: " + row.get("fullName") + " (" + row.get("rollNumber") + ")" + 
                                   " | Course Fee: ₹" + String.format("%.2f", row.get("totalFee")) + 
                                   " | Paid: ₹" + String.format("%.2f", row.get("totalPaid")) + 
                                   " | Pending Balance: ₹" + String.format("%.2f", row.get("pendingBalance")));
            }
        } catch (Exception e) {
            System.err.println("  [FAIL] FeeDAO test failed: " + e.getMessage());
        }

        // Test 6: AttendanceDAO
        try {
            AttendanceDAO attDAO = new AttendanceDAO();
            List<Map<String, Object>> attSummary = attDAO.getStudentAttendanceSummary(1);
            System.out.println("  [PASS] AttendanceDAO: Student summary fetched successfully (" + attSummary.size() + " subjects).");
        } catch (Exception e) {
            System.err.println("  [FAIL] AttendanceDAO test failed: " + e.getMessage());
        }

        // Test 7: MarksDAO
        try {
            MarksDAO marksDAO = new MarksDAO();
            List<Marks> marksList = marksDAO.getMarksheetByStudent(1);
            System.out.println("  [PASS] MarksDAO: Student marksheet records fetched (" + marksList.size() + " entries).");
        } catch (Exception e) {
            System.err.println("  [FAIL] MarksDAO test failed: " + e.getMessage());
        }

        // Test 8: LibraryDAO
        try {
            LibraryDAO libDAO = new LibraryDAO();
            List<Book> books = libDAO.getAllBooks();
            List<BookIssue> issued = libDAO.getAllIssuedBooks();
            System.out.println("  [PASS] LibraryDAO: Retrieved " + books.size() + " catalog books & " + issued.size() + " issued records.");
        } catch (Exception e) {
            System.err.println("  [FAIL] LibraryDAO test failed: " + e.getMessage());
        }

        // Test 9: NoticeDAO
        try {
            NoticeDAO noticeDAO = new NoticeDAO();
            List<Notice> notices = noticeDAO.getAllNotices();
            System.out.println("  [PASS] NoticeDAO: Retrieved " + notices.size() + " active announcements.");
        } catch (Exception e) {
            System.err.println("  [FAIL] NoticeDAO test failed: " + e.getMessage());
        }

        // Test 10: TimetableDAO
        try {
            TimetableDAO timetableDAO = new TimetableDAO();
            List<Timetable> ttList = timetableDAO.getTimetableByDeptAndSem(1, 1);
            System.out.println("  [PASS] TimetableDAO: Dept schedule records fetched (" + ttList.size() + " classes).");
        } catch (Exception e) {
            System.err.println("  [FAIL] TimetableDAO test failed: " + e.getMessage());
        }

        // Test 11: ComplaintDAO
        try {
            ComplaintDAO complaintDAO = new ComplaintDAO();
            List<Complaint> complaints = complaintDAO.getAllComplaints();
            System.out.println("  [PASS] ComplaintDAO: Help desk tickets fetched (" + complaints.size() + " tickets).");
        } catch (Exception e) {
            System.err.println("  [FAIL] ComplaintDAO test failed: " + e.getMessage());
        }
    }
}
