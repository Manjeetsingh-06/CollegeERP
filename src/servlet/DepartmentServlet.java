package servlet;

import dao.DepartmentDAO;
import model.Department;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/departments")
public class DepartmentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private DepartmentDAO departmentDAO;

    @Override
    public void init() throws ServletException {
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

        List<Department> deptList = departmentDAO.getAllDepartments();
        request.setAttribute("deptList", deptList);
        request.getRequestDispatcher("departments.jsp").forward(request, response);
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
            response.sendRedirect("departments?error=Only+Administrators+can+manage+departments");
            return;
        }

        String deptCode = request.getParameter("deptCode");
        String deptName = request.getParameter("deptName");

        if (deptCode != null && deptName != null) {
            Department d = new Department(0, deptCode.trim().toUpperCase(), deptName.trim());
            departmentDAO.addDepartment(d);
        }
        response.sendRedirect("departments?msg=Department+Added+Successfully");
    }
}
