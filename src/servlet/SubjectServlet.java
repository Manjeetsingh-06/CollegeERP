package servlet;

import dao.DepartmentDAO;
import dao.SubjectDAO;
import model.Department;
import model.Subject;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/subjects")
public class SubjectServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private SubjectDAO subjectDAO;
    private DepartmentDAO departmentDAO;

    @Override
    public void init() throws ServletException {
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

        List<Subject> subjectList = subjectDAO.getAllSubjects();
        List<Department> deptList = departmentDAO.getAllDepartments();

        request.setAttribute("subjectList", subjectList);
        request.setAttribute("deptList", deptList);
        request.getRequestDispatcher("subjects.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        model.User user = (model.User) session.getAttribute("loggedUser");
        if (!"ADMIN".equals(user.getRole())) {
            response.sendRedirect("subjects?error=Only+Administrators+can+add+or+modify+courses");
            return;
        }

        String subjectCode = request.getParameter("subjectCode");
        String subjectName = request.getParameter("subjectName");
        int deptId = Integer.parseInt(request.getParameter("deptId"));
        int semester = Integer.parseInt(request.getParameter("semester"));

        Subject sub = new Subject(0, subjectCode, subjectName, deptId, semester);
        boolean success = subjectDAO.addSubject(sub);

        if (success) {
            response.sendRedirect("subjects?msg=Subject+Added+Successfully");
        } else {
            response.sendRedirect("subjects?error=Failed+to+add+subject");
        }
    }
}
