package servlet;

import dao.LibraryDAO;
import dao.StudentDAO;
import model.Book;
import model.BookIssue;
import model.Student;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;
import java.util.List;

@WebServlet("/library")
public class LibraryServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private LibraryDAO libraryDAO;
    private StudentDAO studentDAO;

    @Override
    public void init() throws ServletException {
        libraryDAO = new LibraryDAO();
        studentDAO = new StudentDAO();
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
        if (action == null) action = "books";

        switch (action) {
            case "issue":
                showIssueForm(request, response);
                break;
            case "issued":
                showIssuedBooks(request, response);
                break;
            case "return":
                returnBook(request, response);
                break;
            default:
                showBooks(request, response);
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
        if ("addBook".equals(action)) {
            addBook(request, response);
        } else if ("issueBook".equals(action)) {
            issueBook(request, response);
        }
    }

    private void showBooks(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Book> bookList = libraryDAO.getAllBooks();
        request.setAttribute("bookList", bookList);
        request.getRequestDispatcher("books.jsp").forward(request, response);
    }

    private void showIssueForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Book> bookList = libraryDAO.getAllBooks();
        List<Student> studentList = studentDAO.getAllStudents();
        request.setAttribute("bookList", bookList);
        request.setAttribute("studentList", studentList);
        request.getRequestDispatcher("issue-book.jsp").forward(request, response);
    }

    private void showIssuedBooks(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<BookIssue> issuedList = libraryDAO.getAllIssuedBooks();
        request.setAttribute("issuedList", issuedList);
        request.getRequestDispatcher("issued-books.jsp").forward(request, response);
    }

    private void addBook(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        model.User user = session != null ? (model.User) session.getAttribute("loggedUser") : null;
        if (user == null || !"ADMIN".equals(user.getRole())) {
            response.sendRedirect("library?msg=Only+Administrators+can+add+books");
            return;
        }
        Book book = new Book();
        book.setIsbn(request.getParameter("isbn"));
        book.setTitle(request.getParameter("title"));
        book.setAuthor(request.getParameter("author"));
        book.setCategory(request.getParameter("category"));
        book.setTotalCopies(Integer.parseInt(request.getParameter("totalCopies")));

        libraryDAO.addBook(book);
        response.sendRedirect("library?msg=Book+Added+Successfully");
    }

    private void issueBook(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int bookId = Integer.parseInt(request.getParameter("bookId"));
        int studentId = Integer.parseInt(request.getParameter("studentId"));
        Date issueDate = Date.valueOf(LocalDate.now());
        Date dueDate = Date.valueOf(LocalDate.now().plusDays(14)); // 14 days

        boolean success = libraryDAO.issueBook(bookId, studentId, issueDate, dueDate);
        if (success) {
            response.sendRedirect("library?action=issued&msg=Book+Issued+Successfully");
        } else {
            response.sendRedirect("library?action=issue&error=Failed+to+issue+book");
        }
    }

    private void returnBook(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int issueId = Integer.parseInt(request.getParameter("id"));
        Date returnDate = Date.valueOf(LocalDate.now());
        libraryDAO.returnBook(issueId, returnDate);
        response.sendRedirect("library?action=issued&msg=Book+Returned+Successfully");
    }
}
