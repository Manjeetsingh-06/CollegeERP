package servlet;

import dao.DepartmentDAO;
import dao.StudentDAO;
import model.Department;
import model.Student;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/students")
public class StudentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private StudentDAO studentDAO;
    private DepartmentDAO departmentDAO;

    @Override
    public void init() throws ServletException {
        studentDAO = new StudentDAO();
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
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteStudent(request, response);
                break;
            case "search":
                searchStudents(request, response);
                break;
            case "list":
            default:
                listStudents(request, response);
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

        String action = request.getParameter("action");
        if ("insert".equals(action)) {
            insertStudent(request, response);
        } else if ("update".equals(action)) {
            updateStudent(request, response);
        }
    }

    private void listStudents(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        List<Student> studentList = studentDAO.getAllStudents();
        request.setAttribute("studentList", studentList);
        request.getRequestDispatcher("students.jsp").forward(request, response);
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        List<Department> deptList = departmentDAO.getAllDepartments();
        request.setAttribute("deptList", deptList);
        request.getRequestDispatcher("add-student.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Student student = studentDAO.getStudentById(id);
        List<Department> deptList = departmentDAO.getAllDepartments();
        request.setAttribute("student", student);
        request.setAttribute("deptList", deptList);
        request.getRequestDispatcher("edit-student.jsp").forward(request, response);
    }

    private void insertStudent(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String rollNumber = request.getParameter("rollNumber");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        int deptId = Integer.parseInt(request.getParameter("deptId"));
        int semester = Integer.parseInt(request.getParameter("semester"));
        String password = request.getParameter("password");

        Student s = new Student(0, 0, rollNumber, fullName, email, phone, deptId, semester);
        boolean success = studentDAO.addStudent(s, password);

        if (success) {
            response.sendRedirect("students?msg=Student+Added+Successfully");
        } else {
            request.setAttribute("errorMessage", "Failed to add student. Roll number may already exist.");
            showAddForm(request, response);
        }
    }

    private void updateStudent(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        int deptId = Integer.parseInt(request.getParameter("deptId"));
        int semester = Integer.parseInt(request.getParameter("semester"));

        Student s = new Student();
        s.setId(id);
        s.setFullName(fullName);
        s.setEmail(email);
        s.setPhone(phone);
        s.setDeptId(deptId);
        s.setSemester(semester);

        boolean success = studentDAO.updateStudent(s);
        if (success) {
            response.sendRedirect("students?msg=Student+Updated+Successfully");
        } else {
            request.setAttribute("errorMessage", "Failed to update student.");
            showEditForm(request, response);
        }
    }

    private void deleteStudent(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        int studentId = Integer.parseInt(request.getParameter("id"));
        int userId = Integer.parseInt(request.getParameter("userId"));
        studentDAO.deleteStudent(studentId, userId);
        response.sendRedirect("students?msg=Student+Deleted+Successfully");
    }

    private void searchStudents(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String query = request.getParameter("query");
        List<Student> studentList = studentDAO.searchStudents(query);
        request.setAttribute("studentList", studentList);
        request.setAttribute("searchQuery", query);
        request.getRequestDispatcher("students.jsp").forward(request, response);
    }
}
