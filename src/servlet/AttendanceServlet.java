package servlet;

import dao.AttendanceDAO;
import dao.DepartmentDAO;
import dao.StudentDAO;
import dao.SubjectDAO;
import model.Attendance;
import model.Department;
import model.Student;
import model.Subject;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@WebServlet("/attendance")
public class AttendanceServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private AttendanceDAO attendanceDAO;
    private StudentDAO studentDAO;
    private DepartmentDAO departmentDAO;
    private SubjectDAO subjectDAO;

    @Override
    public void init() throws ServletException {
        attendanceDAO = new AttendanceDAO();
        studentDAO = new StudentDAO();
        departmentDAO = new DepartmentDAO();
        subjectDAO = new SubjectDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if ("report".equals(action)) {
            showReport(request, response);
        } else {
            showForm(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User user = (User) session.getAttribute("loggedUser");
        int subjectId = Integer.parseInt(request.getParameter("subjectId"));
        Date attDate = Date.valueOf(request.getParameter("attendanceDate"));
        String[] studentIds = request.getParameterValues("studentIds");

        List<Attendance> batch = new ArrayList<>();
        if (studentIds != null) {
            for (String sId : studentIds) {
                int studentId = Integer.parseInt(sId);
                String status = request.getParameter("status_" + studentId);
                if (status == null) status = "ABSENT";

                Attendance att = new Attendance(0, studentId, subjectId, attDate, status, user.getUsername());
                batch.add(att);
            }
        }

        attendanceDAO.markAttendanceBatch(batch);
        response.sendRedirect("attendance?msg=Attendance+Recorded+Successfully");
    }

    private void showForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        List<Department> deptList = departmentDAO.getAllDepartments();
        List<Subject> subjectList = subjectDAO.getAllSubjects();
        List<Student> studentList = studentDAO.getAllStudents();

        request.setAttribute("deptList", deptList);
        request.setAttribute("subjectList", subjectList);
        request.setAttribute("studentList", studentList);

        request.getRequestDispatcher("mark-attendance.jsp").forward(request, response);
    }

    private void showReport(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        List<Student> studentList = studentDAO.getAllStudents();
        request.setAttribute("studentList", studentList);

        String sIdParam = request.getParameter("studentId");
        if (sIdParam != null && !sIdParam.isEmpty()) {
            int studentId = Integer.parseInt(sIdParam);
            List<Map<String, Object>> summary = attendanceDAO.getStudentAttendanceSummary(studentId);
            Student selectedStudent = studentDAO.getStudentById(studentId);

            request.setAttribute("selectedStudent", selectedStudent);
            request.setAttribute("summary", summary);
        }

        request.getRequestDispatcher("attendance-report.jsp").forward(request, response);
    }
}
