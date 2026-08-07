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
        String jsonReply = reply.replace("\"", "\\\"").replace("\n", "");
        out.print("{\"reply\":\"" + jsonReply + "\"}");
    }

    private String generateSmartReply(String q) {
        // GREETINGS & INTRO
        if (q.contains("hello") || q.contains("hi") || q.contains("hey") || q.contains("namaste") || q.contains("kaise") || q.contains("who are you")) {
            return "👋 <strong>Namaste! Welcome to Lucknow University ERP AI Helpdesk.</strong><br><br>"
                 + "I have full knowledge of all 14 modules in this portal. You can ask me about:<br>"
                 + "• 💳 Fees & Payment Ledgers<br>"
                 + "• 📝 Marksheets & Examination Results<br>"
                 + "• 📊 Attendance Tracking<br>"
                 + "• 📚 Library Book Issue System<br>"
                 + "• 📢 Notices, Timetable & Complaints<br>"
                 + "• 🛡️ Admin, Faculty & Student Role Controls";
        }

        // FEES & PAYMENTS (SUPER DETAILED)
        if (q.contains("fee") || q.contains("pay") || q.contains("due") || q.contains("tuition") || q.contains("receipt") || q.contains("paisa") || q.contains("challan")) {
            return "💳 <strong>Comprehensive Fees & Finance Guide:</strong><br><br>"
                 + "1. <strong>Student Online Payment:</strong> Go to <em>Pay Fees</em> in sidebar. Select semester, enter amount, choose payment mode (UPI/Card/NetBanking), and submit to receive instant digital receipt.<br>"
                 + "2. <strong>Pending Fees Ledger (A4 Print):</strong> Admins can view complete unpaid balance list department-wise and print official university ledgers.<br>"
                 + "3. <strong>Fee Structure Management:</strong> Admins can configure Tuition, Development, Exam, and Library fee components for each department & semester.<br><br>"
                 + "👉 <a href='fees?action=pay' style='color:#ffd700;font-weight:700;'>Go to Pay Fees Portal</a>";
        }

        // MARKS & RESULTS (SUPER DETAILED)
        if (q.contains("mark") || q.contains("result") || q.contains("marksheet") || q.contains("grade") || q.contains("exam") || q.contains("score") || q.contains("cgpa")) {
            return "📝 <strong>Marks & Official Marksheet Guide:</strong><br><br>"
                 + "1. <strong>Faculty Evaluation:</strong> Teachers enter Internal Marks (Max 40) and External Exam Marks (Max 60) for subject students.<br>"
                 + "2. <strong>A4 Official Transcript Print:</strong> Students can generate official University of Lucknow Marksheets showing Subject Codes, Credits, Obtained Marks, Percentage, and letter Grades (A+, A, B, C, D, F).<br>"
                 + "3. <strong>Cumulative Score:</strong> System automatically calculates grand totals and percentage.<br><br>"
                 + "👉 <a href='marks?action=marksheet' style='color:#ffd700;font-weight:700;'>Generate Marksheet Now</a>";
        }

        // ATTENDANCE (SUPER DETAILED)
        if (q.contains("attendance") || q.contains("absent") || q.contains("present") || q.contains("percentage") || q.contains("bunk")) {
            return "📊 <strong>Attendance Tracking System:</strong><br><br>"
                 + "1. <strong>Faculty Entry:</strong> Teachers select department, semester, subject, date and mark students as Present, Absent, or Late.<br>"
                 + "2. <strong>Student Analytics:</strong> Students view subject-wise attendance logs and overall percentage eligibility for university exams.<br><br>"
                 + "👉 <a href='attendance' style='color:#ffd700;font-weight:700;'>View Attendance Log</a>";
        }

        // LIBRARY (SUPER DETAILED)
        if (q.contains("book") || q.contains("library") || q.contains("issue") || q.contains("return") || q.contains("fine") || q.contains("isbn")) {
            return "📚 <strong>Library Management System:</strong><br><br>"
                 + "1. <strong>Book Catalog:</strong> Admins can add books with Title, Author, Publisher, ISBN, and quantity.<br>"
                 + "2. <strong>Issue & Return Tracking:</strong> Library logs issue dates and due dates. Late returns auto-calculate fine amounts per day.<br>"
                 + "3. <strong>Student Portal:</strong> Check currently issued books and return deadlines.<br><br>"
                 + "👉 <a href='library' style='color:#ffd700;font-weight:700;'>Open Library Catalog</a>";
        }

        // TIMETABLE & NOTICES
        if (q.contains("timetable") || q.contains("schedule") || q.contains("routine") || q.contains("class") || q.contains("period")) {
            return "📅 <strong>Class Timetable & Room Allocation:</strong><br><br>"
                 + "• View weekly class schedules organized by Department, Semester, Day of Week, Time Slot, and Assigned Faculty.<br>"
                 + "👉 <a href='timetable' style='color:#ffd700;font-weight:700;'>View Weekly Timetable</a>";
        }

        if (q.contains("notice") || q.contains("circular") || q.contains("news") || q.contains("event") || q.contains("holiday") || q.contains("announcement")) {
            return "📢 <strong>Official University Notices:</strong><br><br>"
                 + "• Admins and Faculty broadcast notices for All Users, Students Only, or Faculty Only.<br>"
                 + "👉 <a href='notices' style='color:#ffd700;font-weight:700;'>Read Latest Notices</a>";
        }

        // COMPLAINTS & HELPDESK
        if (q.contains("complaint") || q.contains("help") || q.contains("support") || q.contains("issue") || q.contains("problem") || q.contains("query")) {
            return "💬 <strong>Grievance & Redressal Cell:</strong><br><br>"
                 + "1. <strong>Submit Query:</strong> Log academic or infrastructure complaints directly to administration.<br>"
                 + "2. <strong>Status Tracker:</strong> Track status (PENDING ➔ IN PROGRESS ➔ RESOLVED).<br><br>"
                 + "👉 <a href='complaints' style='color:#ffd700;font-weight:700;'>Submit Complaint / Query</a>";
        }

        // ADMIN CONTROLS
        if (q.contains("admin") || q.contains("control") || q.contains("permission") || q.contains("manage")) {
            return "🛡️ <strong>System Administrator Powers:</strong><br><br>"
                 + "• Manage Students (Add, Edit, Assign Roll Numbers & Semester)<br>"
                 + "• Manage Faculty Members & Department Heads<br>"
                 + "• Define Departments (B.Tech, BCA, MCA) & Subject Catalog<br>"
                 + "• Fee Structure Setup & Pending Dues Clearance<br>"
                 + "• Full Audit Access to Complaints & System Logs";
        }

        // STUDENT & FACULTY CONTROLS
        if (q.contains("student") || q.contains("faculty") || q.contains("teacher")) {
            return "👥 <strong>Role Privileges:</strong><br><br>"
                 + "👨‍🏫 <strong>Faculty:</strong> Mark class attendance, upload examination marks, broadcast notices.<br>"
                 + "🎓 <strong>Students:</strong> View attendance %, download printable marksheet, pay online fees, check library books & notices.";
        }

        // LOGIN / CREDS / TECH STACK
        if (q.contains("login") || q.contains("password") || q.contains("username") || q.contains("account")) {
            return "🔐 <strong>Login Information:</strong><br><br>"
                 + "• <strong>Admin:</strong> username <code>admin</code> / password <code>Manjeet@2007</code><br>"
                 + "• <strong>Faculty:</strong> username <code>faculty1</code> / password <code>Faculty@123</code><br>"
                 + "• <strong>Student:</strong> username <code>student1</code> / password <code>Student@123</code>";
        }

        if (q.contains("who made") || q.contains("developer") || q.contains("manjeet") || q.contains("creator") || q.contains("tech")) {
            return "🏛️ <strong>University ERP System Details:</strong><br><br>"
                 + "• <strong>Institution:</strong> University of Lucknow, Lucknow<br>"
                 + "• <strong>Developer:</strong> Manjeet Singh<br>"
                 + "• <strong>Architecture:</strong> Java 21, Jakarta EE 10, Servlet 6.0, Tomcat 10.1<br>"
                 + "• <strong>Cloud Stack:</strong> Render Web Service + Railway MySQL 8.0";
        }

        // DEFAULT HELP RESPONSE
        return "🤖 <strong>I am your University ERP AI Assistant!</strong><br><br>"
             + "I can help you step-by-step with:<br>"
             + "1. 💳 <strong>Fees:</strong> How to pay or check pending dues.<br>"
             + "2. 📝 <strong>Marks:</strong> How to generate A4 print marksheets.<br>"
             + "3. 📊 <strong>Attendance:</strong> Checking logs or entering class attendance.<br>"
             + "4. 📚 <strong>Library:</strong> Finding books and checking return dates.<br>"
             + "5. 📢 <strong>Notices & Timetable:</strong> Schedule & circulars.<br>"
             + "6. 🔑 <strong>Login & Roles:</strong> Admin, Faculty, and Student credentials.<br><br>"
             + "Try asking a question like <em>'How to pay fees?'</em> or <em>'Where is my marksheet?'</em>!";
    }
}
