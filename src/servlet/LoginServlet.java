package servlet;

import dao.UserDAO;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Redirect to dashboard if already logged in
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("loggedUser") != null) {
            response.sendRedirect("dashboard.jsp");
            return;
        }
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String selectedRole = request.getParameter("role");

        if (username == null || username.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Username and Password are required!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        User user = userDAO.authenticateUser(username.trim(), password.trim());

        if (user != null) {
            // Check if role matches if role was selected
            if (selectedRole != null && !selectedRole.equalsIgnoreCase("ALL") && !user.getRole().equalsIgnoreCase(selectedRole)) {
                request.setAttribute("errorMessage", "Role mismatch! User is registered as " + user.getRole() + ".");
                request.getRequestDispatcher("login.jsp").forward(request, response);
                return;
            }

            // Create HTTP Session
            HttpSession session = request.getSession();
            session.setAttribute("loggedUser", user);
            session.setAttribute("username", user.getUsername());
            session.setAttribute("userRole", user.getRole());

            // Redirect to Dashboard
            response.sendRedirect("dashboard.jsp");
        } else {
            request.setAttribute("errorMessage", "Invalid Username or Password!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}
