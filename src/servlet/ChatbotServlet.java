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
        
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json; charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            out.print("{\"reply\":\"⚠️ Session expired. Please refresh and login again.\"}");
            return;
        }

        String message = request.getParameter("message");
        if (message == null || message.trim().isEmpty()) {
            out.print("{\"reply\":\"Please enter a question to ask the ERP Assistant.\"}");
            return;
        }

        String rawQuery = message.trim();
        String query = rawQuery.toLowerCase(Locale.ROOT);
        String reply = generateSmartReply(query, rawQuery);

        // Sanitize string for valid JSON output
        String safeReply = reply.replace("\\", "\\\\")
                               .replace("\"", "\\\"")
                               .replace("\r", "")
                               .replace("\n", "<br>");

        out.print("{\"reply\":\"" + safeReply + "\"}");
    }

    private String generateSmartReply(String q, String original) {
        // Tokenize query into words for token-matching
        String[] tokens = q.split("[\\s,?.!]+");

        boolean hasFee = containsAny(tokens, "fee", "fees", "pay", "payment", "due", "dues", "tuition", "challan", "receipt", "paisa", "rupee", "money");
        boolean hasMark = containsAny(tokens, "mark", "marks", "result", "results", "marksheet", "grade", "grades", "exam", "score", "cgpa", "percentage");
        boolean hasAtt = containsAny(tokens, "attendance", "absent", "present", "bunk", "leave", "percent");
        boolean hasLib = containsAny(tokens, "book", "books", "library", "issue", "return", "fine", "author", "isbn");
        boolean hasNotice = containsAny(tokens, "notice", "notices", "circular", "event", "news", "announcement", "holiday");
        boolean hasTime = containsAny(tokens, "timetable", "schedule", "routine", "class", "classes", "period", "slot");
        boolean hasComp = containsAny(tokens, "complaint", "complaints", "help", "support", "issue", "problem", "query", "error", "bug");
        boolean hasUser = containsAny(tokens, "student", "students", "faculty", "teacher", "admin", "department", "subject", "course");
        boolean hasHi = containsAny(tokens, "hi", "hello", "hey", "namaste", "kaise", "who", "bot", "assistant");

        if (hasHi && tokens.length <= 3) {
            return "👋 <strong>Hello! I am Lucknow University ERP Assistant.</strong><br>"
                 + "I am here to guide you with any ERP details. Ask me anything about Fees, Results, Attendance, Library, or Notices!";
        }

        if (hasFee) {
            return "💳 <strong>Fees & Payment Help:</strong><br>"
                 + "• <strong>Pay Fees Online:</strong> Navigate to <em>Pay Fees</em> from sidebar, select your semester and payment method (UPI/Card).<br>"
                 + "• <strong>Pending Dues Ledger:</strong> Admins can view complete unpaid fee lists under <em>Pending Fees Ledger</em>.<br>"
                 + "• <strong>Fee Structure:</strong> Admins can set tuition, exam, and library fees per course.<br>"
                 + "👉 <a href='fees?action=pay' style='color:#ffd700;font-weight:700;text-decoration:underline;'>Click here to Pay Fees</a>";
        }

        if (hasMark) {
            return "📝 <strong>Marks & Marksheet Guidance:</strong><br>"
                 + "• <strong>Enter Marks (Faculty):</strong> Teachers enter Internal (Max 40) and External (Max 60) marks.<br>"
                 + "• <strong>View / Download Marksheet (Student):</strong> Go to <em>My Results / Marksheet</em> to generate and print your official A4 transcript with grades.<br>"
                 + "👉 <a href='marks?action=marksheet' style='color:#ffd700;font-weight:700;text-decoration:underline;'>View Official Marksheet</a>";
        }

        if (hasAtt) {
            return "📊 <strong>Attendance Portal Help:</strong><br>"
                 + "• <strong>Mark Attendance:</strong> Faculty can mark students as Present, Absent, or Late daily.<br>"
                 + "• <strong>Attendance Percentage:</strong> Students can check subject-wise attendance logs.<br>"
                 + "👉 <a href='attendance' style='color:#ffd700;font-weight:700;text-decoration:underline;'>Check Attendance Log</a>";
        }

        if (hasLib) {
            return "📚 <strong>Library Services:</strong><br>"
                 + "• Search books by Title, Author, or ISBN number.<br>"
                 + "• Check issued books, return deadlines, and late fines.<br>"
                 + "👉 <a href='library' style='color:#ffd700;font-weight:700;text-decoration:underline;'>Open Library Catalog</a>";
        }

        if (hasTime) {
            return "📅 <strong>Class Timetable:</strong><br>"
                 + "• Check weekly day-wise schedule, time slots, and assigned lecture rooms.<br>"
                 + "👉 <a href='timetable' style='color:#ffd700;font-weight:700;text-decoration:underline;'>Open Weekly Timetable</a>";
        }

        if (hasNotice) {
            return "📢 <strong>Notices & Circulars:</strong><br>"
                 + "• Official announcements posted by University Admin and Faculty appear here.<br>"
                 + "👉 <a href='notices' style='color:#ffd700;font-weight:700;text-decoration:underline;'>Read Notices</a>";
        }

        if (hasComp) {
            return "💬 <strong>Helpdesk & Grievances:</strong><br>"
                 + "• Register complaints regarding academics, fees, or technical issues.<br>"
                 + "👉 <a href='complaints' style='color:#ffd700;font-weight:700;text-decoration:underline;'>Submit Complaint / Query</a>";
        }

        if (hasUser) {
            return "👥 <strong>User & Module Info:</strong><br>"
                 + "• <strong>Admin:</strong> Manages Students, Faculty, Departments, Courses & Fees.<br>"
                 + "• <strong>Faculty:</strong> Marks Attendance, Enters Marks, Posts Notices.<br>"
                 + "• <strong>Student:</strong> Pays Fees, Checks Marksheets & Attendance Logs.";
        }

        // Generic intelligent fallback for any typed text
        return "🤖 <strong>ERP AI Assistant Reply:</strong><br>"
             + "You asked: <em>\"" + original + "\"</em><br><br>"
             + "I can help you navigate the system! Where would you like to go?<br>"
             + "• 💳 <a href='fees?action=pay' style='color:#ffd700;font-weight:700;'>Pay Dues & Fees</a><br>"
             + "• 📝 <a href='marks?action=marksheet' style='color:#ffd700;font-weight:700;'>Check Marksheet</a><br>"
             + "• 📊 <a href='attendance' style='color:#ffd700;font-weight:700;'>View Attendance Log</a><br>"
             + "• 📚 <a href='library' style='color:#ffd700;font-weight:700;'>Library Books</a><br>"
             + "• 💬 <a href='complaints' style='color:#ffd700;font-weight:700;'>Contact Support</a>";
    }

    private boolean containsAny(String[] tokens, String... keywords) {
        for (String t : tokens) {
            for (String kw : keywords) {
                if (t.equalsIgnoreCase(kw) || t.contains(kw) || kw.contains(t)) {
                    return true;
                }
            }
        }
        return false;
    }
}
