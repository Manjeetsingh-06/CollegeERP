package servlet;

import dao.ComplaintDAO;
import model.Complaint;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/complaints")
public class ComplaintServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ComplaintDAO complaintDAO;

    @Override
    public void init() throws ServletException {
        complaintDAO = new ComplaintDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User user = (User) session.getAttribute("loggedUser");
        String action = request.getParameter("action");

        if ("resolve".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            String adminResponse = request.getParameter("adminResponse");
            complaintDAO.resolveComplaint(id, adminResponse);
            response.sendRedirect("complaints?msg=Complaint+Resolved");
            return;
        }

        List<Complaint> complaintList;
        if ("ADMIN".equals(user.getRole()) || "FACULTY".equals(user.getRole())) {
            complaintList = complaintDAO.getAllComplaints();
        } else {
            // For students, need their student ID — stored in session
            Integer studentId = (Integer) session.getAttribute("studentId");
            if (studentId == null) studentId = 0;
            complaintList = complaintDAO.getComplaintsByStudent(studentId);
        }

        request.setAttribute("complaintList", complaintList);
        request.getRequestDispatcher("complaints.jsp").forward(request, response);
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

        if ("submit".equals(action)) {
            Integer studentId = (Integer) session.getAttribute("studentId");
            if (studentId == null) studentId = 1; // fallback for admin/faculty testing
            String subjectTitle = request.getParameter("subjectTitle");
            String description = request.getParameter("description");
            complaintDAO.submitComplaint(studentId, subjectTitle, description);
            response.sendRedirect("complaints?msg=Complaint+Submitted+Successfully");
        } else if ("resolve".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            String adminResponse = request.getParameter("adminResponse");
            complaintDAO.resolveComplaint(id, adminResponse);
            response.sendRedirect("complaints?msg=Complaint+Resolved+Successfully");
        }
    }
}
