package servlet;

import dao.NoticeDAO;
import model.Notice;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/notices")
public class NoticeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private NoticeDAO noticeDAO;

    @Override
    public void init() throws ServletException {
        noticeDAO = new NoticeDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        List<Notice> noticeList = noticeDAO.getAllNotices();
        request.setAttribute("noticeList", noticeList);
        request.getRequestDispatcher("notices.jsp").forward(request, response);
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
        String title = request.getParameter("title");
        String content = request.getParameter("content");
        String targetRole = request.getParameter("targetRole");

        Notice notice = new Notice(0, title, content, user.getUsername(), targetRole, null);
        noticeDAO.addNotice(notice);
        response.sendRedirect("notices?msg=Notice+Posted+Successfully");
    }
}
