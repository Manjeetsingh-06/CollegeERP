package servlet;

import dao.DepartmentDAO;
import dao.MarksDAO;
import dao.StudentDAO;
import dao.SubjectDAO;
import model.Department;
import model.Marks;
import model.Student;
import model.Subject;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/marks")
public class MarksServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private MarksDAO marksDAO;
    private StudentDAO studentDAO;
    private SubjectDAO subjectDAO;
    private DepartmentDAO departmentDAO;

    @Override
    public void init() throws ServletException {
        marksDAO = new MarksDAO();
        studentDAO = new StudentDAO();
        subjectDAO = new SubjectDAO();
        departmentDAO = new DepartmentDAO();
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
        if ("marksheet".equals(action)) {
            showMarksheet(request, response);
        } else {
            showEntryForm(request, response);
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

        int subjectId = Integer.parseInt(request.getParameter("subjectId"));
        String examType = request.getParameter("examType");
        double maxMarks = Double.parseDouble(request.getParameter("maxMarks"));
        String[] studentIds = request.getParameterValues("studentIds");

        List<Marks> batch = new ArrayList<>();
        if (studentIds != null) {
            for (String sId : studentIds) {
                int studentId = Integer.parseInt(sId);
                String marksStr = request.getParameter("marks_" + studentId);
                if (marksStr != null && !marksStr.trim().isEmpty()) {
                    double marksObtained = Double.parseDouble(marksStr.trim());
                    Marks m = new Marks(0, studentId, subjectId, examType, marksObtained, maxMarks);
                    batch.add(m);
                }
            }
        }

        marksDAO.saveMarksBatch(batch);
        response.sendRedirect("marks?msg=Examination+Marks+Saved+Successfully");
    }

    private void showEntryForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        List<Department> deptList = departmentDAO.getAllDepartments();
        List<Subject> subjectList = subjectDAO.getAllSubjects();
        List<Student> studentList = studentDAO.getAllStudents();

        request.setAttribute("deptList", deptList);
        request.setAttribute("subjectList", subjectList);
        request.setAttribute("studentList", studentList);

        request.getRequestDispatcher("marks-entry.jsp").forward(request, response);
    }

    private void showMarksheet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        List<Student> studentList = studentDAO.getAllStudents();
        request.setAttribute("studentList", studentList);

        String sIdParam = request.getParameter("studentId");
        if (sIdParam != null && !sIdParam.isEmpty()) {
            int studentId = Integer.parseInt(sIdParam);
            Student selectedStudent = studentDAO.getStudentById(studentId);
            List<Marks> marksheetList = marksDAO.getMarksheetByStudent(studentId);

            double totalObtained = 0;
            double totalMax = 0;
            for (Marks m : marksheetList) {
                totalObtained += m.getMarksObtained();
                totalMax += m.getMaxMarks();
            }

            double overallPercentage = (totalMax > 0) ? (totalObtained / totalMax) * 100 : 0;

            request.setAttribute("selectedStudent", selectedStudent);
            request.setAttribute("marksheetList", marksheetList);
            request.setAttribute("totalObtained", totalObtained);
            request.setAttribute("totalMax", totalMax);
            request.setAttribute("overallPercentage", Math.round(overallPercentage * 10.0) / 10.0);
        }

        request.getRequestDispatcher("marksheet.jsp").forward(request, response);
    }
}
