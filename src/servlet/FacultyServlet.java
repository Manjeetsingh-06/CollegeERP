package servlet;

import dao.DepartmentDAO;
import dao.FacultyDAO;
import model.Department;
import model.Faculty;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/faculty")
public class FacultyServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private FacultyDAO facultyDAO;
    private DepartmentDAO departmentDAO;

    @Override
    public void init() throws ServletException {
        facultyDAO = new FacultyDAO();
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
        if (action == null) action = "list";

        switch (action) {
            case "add":
                showAddForm(request, response);
                break;
            case "delete":
                deleteFaculty(request, response);
                break;
            case "list":
            default:
                listFaculty(request, response);
                break;
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

        model.User user = (model.User) session.getAttribute("loggedUser");
        if (!"ADMIN".equals(user.getRole())) {
            response.sendRedirect("faculty?msg=Only+Administrators+can+manage+faculty");
            return;
        }

        String action = request.getParameter("action");
        if ("insert".equals(action)) {
            insertFaculty(request, response);
        }
    }

    private void listFaculty(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        List<Faculty> facultyList = facultyDAO.getAllFaculty();
        request.setAttribute("facultyList", facultyList);
        request.getRequestDispatcher("faculty.jsp").forward(request, response);
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        List<Department> deptList = departmentDAO.getAllDepartments();
        request.setAttribute("deptList", deptList);
        request.getRequestDispatcher("add-faculty.jsp").forward(request, response);
    }

    private void insertFaculty(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String empCode = request.getParameter("empCode");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        int deptId = Integer.parseInt(request.getParameter("deptId"));
        String password = request.getParameter("password");

        Faculty f = new Faculty(0, 0, empCode, fullName, email, phone, deptId);
        boolean success = facultyDAO.addFaculty(f, password);

        if (success) {
            response.sendRedirect("faculty?msg=Faculty+Member+Added+Successfully");
        } else {
            request.setAttribute("errorMessage", "Failed to add faculty member.");
            showAddForm(request, response);
        }
    }

    private void deleteFaculty(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        int facultyId = Integer.parseInt(request.getParameter("id"));
        int userId = Integer.parseInt(request.getParameter("userId"));
        facultyDAO.deleteFaculty(facultyId, userId);
        response.sendRedirect("faculty?msg=Faculty+Deleted+Successfully");
    }
}
