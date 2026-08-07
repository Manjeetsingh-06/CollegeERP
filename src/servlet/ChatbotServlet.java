package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Locale;

@WebServlet("/chatbot")
public class ChatbotServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            out.print("{\"reply\":\"⚠️ Session expired. Please login again to ask assistant.\"}");
            return;
        }

        String message = request.getParameter("message");
        if (message == null || message.trim().isEmpty()) {
            out.print("{\"reply\":\"Please ask a valid question! I am your University Assistant.\"}");
            return;
        }

        String query = message.trim().toLowerCase(Locale.ROOT);
        String reply = generateSmartReply(query);

        // Escape JSON double quotes safely
        String jsonReply = reply.replace("\"", "\\\"");
        out.print("{\"reply\":\"" + jsonReply + "\"}");
    }

    private String generateSmartReply(String q) {
        if (q.contains("hello") || q.contains("hi") || q.contains("hey") || q.contains("namaste") || q.contains("kaise")) {
            return "👋 Hello! I am <strong>Lucknow University ERP AI Assistant</strong>. How can I help you today?";
        }

        if (q.contains("fee") || q.contains("pay") || q.contains("dues") || q.contains("tuition") || q.contains("receipt") || q.contains("paisa")) {
            return "💳 <strong>Fees & Payment Info:</strong><br>• Go to <strong>Pay Fees / Pending Fees</strong> from the left menu.<br>• Students can view semester breakdown and pay online.<br>• Admins can generate fee ledgers and official receipts.<br>👉 <a href='fees?action=pay' style='color:#ffd700;font-weight:700;'>Click here to Pay Fees</a>";
        }

        if (q.contains("mark") || q.contains("result") || q.contains("marksheet") || q.contains("grade") || q.contains("exam") || q.contains("score")) {
            return "📝 <strong>Marks & Marksheet:</strong><br>• Go to <strong>My Results / Marksheet</strong> in sidebar.<br>• Official A4 format marksheet displays Internal (40) and External (60) marks with cumulative grade.<br>👉 <a href='marks?action=marksheet' style='color:#ffd700;font-weight:700;'>View Official Marksheet</a>";
        }

        if (q.contains("attendance") || q.contains("absent") || q.contains("present") || q.contains("leave")) {
            return "📊 <strong>Attendance Management:</strong><br>• Faculty can mark subject-wise daily attendance.<br>• Students can check subject attendance percentage.<br>👉 <a href='attendance' style='color:#ffd700;font-weight:700;'>Check Attendance</a>";
        }

        if (q.contains("book") || q.contains("library") || q.contains("issue") || q.contains("isbn") || q.contains("author")) {
            return "📚 <strong>Library Management:</strong><br>• Check available books, authors, and ISBN numbers.<br>• Students can view issued books and due dates.<br>👉 <a href='library' style='color:#ffd700;font-weight:700;'>Open Library Portal</a>";
        }

        if (q.contains("notice") || q.contains("circular") || q.contains("news") || q.contains("event") || q.contains("update")) {
            return "📢 <strong>University Notices:</strong><br>• Important announcements posted by University Admin and Faculty appear here.<br>👉 <a href='notices' style='color:#ffd700;font-weight:700;'>View All Notices</a>";
        }

        if (q.contains("timetable") || q.contains("schedule") || q.contains("routine") || q.contains("class")) {
            return "📅 <strong>Class Timetable:</strong><br>• View weekly lecture schedules and room allocations department-wise.<br>👉 <a href='timetable' style='color:#ffd700;font-weight:700;'>View Timetable</a>";
        }

        if (q.contains("complaint") || q.contains("help") || q.contains("support") || q.contains("issue") || q.contains("problem")) {
            return "💬 <strong>Help & Complaints:</strong><br>• Submit student or faculty queries directly to administration.<br>👉 <a href='complaints' style='color:#ffd700;font-weight:700;'>Submit a Complaint</a>";
        }

        if (q.contains("who made") || q.contains("developer") || q.contains("manjeet") || q.contains("creator") || q.contains("built")) {
            return "⭐ <strong>Development Info:</strong><br>This ERP System was developed by <strong>Manjeet Singh</strong> for University of Lucknow.";
        }

        if (q.contains("department") || q.contains("course") || q.contains("subject") || q.contains("faculty")) {
            return "🏛️ <strong>Courses & Faculty:</strong><br>• Admins can manage departments (B.Tech, BCA, MCA) and assign course credits.";
        }

        return "🤖 I am your ERP Assistant! You can ask me about <strong>Fees Payment, Marksheets, Attendance, Library Books, Notices, or Timetables</strong>.<br>Or click one of the quick suggestions below!";
    }
}
