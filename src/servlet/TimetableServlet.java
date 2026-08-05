package servlet;

import dao.DepartmentDAO;
import dao.SubjectDAO;
import dao.TimetableDAO;
import model.Department;
import model.Subject;
import model.Timetable;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/timetable")
public class TimetableServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private TimetableDAO timetableDAO;
    private DepartmentDAO departmentDAO;
    private SubjectDAO subjectDAO;

    @Override
    public void init() throws ServletException {
        timetableDAO = new TimetableDAO();
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

        List<Department> deptList = departmentDAO.getAllDepartments();
        List<Subject> subjectList = subjectDAO.getAllSubjects();
        request.setAttribute("deptList", deptList);
        request.setAttribute("subjectList", subjectList);

        String deptIdParam = request.getParameter("deptId");
        String semParam = request.getParameter("semester");

        if (deptIdParam != null && semParam != null) {
            int deptId = Integer.parseInt(deptIdParam);
            int semester = Integer.parseInt(semParam);
            List<Timetable> timetableList = timetableDAO.getTimetableByDeptAndSem(deptId, semester);
            request.setAttribute("timetableList", timetableList);
            request.setAttribute("selectedDeptId", deptId);
            request.setAttribute("selectedSem", semester);
        }

        String action = request.getParameter("action");
        if ("delete".equals(action)) {
            model.User user = (model.User) session.getAttribute("loggedUser");
            if (!"ADMIN".equals(user.getRole())) {
                response.sendRedirect("timetable?msg=Only+Administrators+can+delete+schedules");
                return;
            }
            int id = Integer.parseInt(request.getParameter("id"));
            timetableDAO.deleteEntry(id);
            response.sendRedirect("timetable?msg=Entry+Deleted");
            return;
        }

        request.getRequestDispatcher("timetable.jsp").forward(request, response);
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
            response.sendRedirect("timetable?msg=Only+Administrators+can+add+schedules");
            return;
        }

        int deptId = Integer.parseInt(request.getParameter("deptId"));
        int semester = Integer.parseInt(request.getParameter("semester"));
        String dayOfWeek = request.getParameter("dayOfWeek");
        int subjectId = Integer.parseInt(request.getParameter("subjectId"));
        String timeSlot = request.getParameter("timeSlot");
        String roomNo = request.getParameter("roomNo");

        Timetable t = new Timetable(0, deptId, semester, dayOfWeek, subjectId, timeSlot, roomNo);
        timetableDAO.addEntry(t);
        response.sendRedirect("timetable?msg=Schedule+Added+Successfully&deptId=" + deptId + "&semester=" + semester);
    }
}
