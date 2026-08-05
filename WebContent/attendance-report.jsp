<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="model.Student" %>
<%@ page import="model.User" %>
<%
    User loggedUser = (User) session.getAttribute("loggedUser");
    if (loggedUser == null) { response.sendRedirect("login.jsp"); return; }
    List<Student> studentList = (List<Student>) request.getAttribute("studentList");
    Student selectedStudent = (Student) request.getAttribute("selectedStudent");
    List<Map<String, Object>> summary = (List<Map<String, Object>>) request.getAttribute("summary");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Attendance Report - University of Lucknow ERP</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="css/style.css?v=6.0">
</head>
<body>
    <div class="bg-glow-1"></div>
    <div class="bg-glow-2"></div>
    <div class="app-container glass-container">
        
        <%@ include file="sidebar.jsp" %>

        <main class="main-content">
            <header class="top-navbar">
                <button type="button" class="mobile-toggle-btn" id="mobileMenuToggle"><i class="fa-solid fa-bars"></i></button>
                <div class="welcome-title">
                    <h2>📊 Attendance Analytics & Percentage Report</h2>
                    <p>Subject-wise attendance summary and warning thresholds.</p>
                </div>
            </header>

            <div class="glass-card" style="padding: 24px; margin-bottom: 24px;">
                <form action="attendance" method="GET" style="display: flex; gap: 16px; align-items: flex-end; flex-wrap: wrap;">
                    <input type="hidden" name="action" value="report">
                    <div class="form-group" style="flex: 1; margin: 0; min-width: 250px;">
                        <label>Select Student</label>
                        <select name="studentId" class="form-control" style="padding-left: 14px;" required>
                            <option value="">-- Choose Student --</option>
                            <% if (studentList != null) { for (Student s : studentList) { %>
                                <option value="<%= s.getId() %>" <%= selectedStudent != null && selectedStudent.getId() == s.getId() ? "selected" : "" %>>
                                    <%= s.getRollNumber() %> - <%= s.getFullName() %>
                                </option>
                            <% } } %>
                        </select>
                    </div>
                    <button type="submit" class="btn-primary" style="width: auto; padding: 13px 28px; margin: 0;">
                        <i class="fa-solid fa-chart-line"></i> Generate Report
                    </button>
                </form>
            </div>

            <% if (selectedStudent != null) { %>
            <div class="glass-card" style="padding: 24px; margin-bottom: 24px; display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 16px;">
                <div>
                    <h3 style="font-size: 1.2rem; font-weight: 800; color: var(--text-primary);"><%= selectedStudent.getFullName() %></h3>
                    <p style="color: var(--text-muted); font-size: 0.9rem;">Roll No: <strong style="color: var(--gold-light);"><%= selectedStudent.getRollNumber() %></strong> | Dept: <%= selectedStudent.getDeptName() %></p>
                </div>
                <span class="badge-gold" style="font-size: 0.9rem; padding: 8px 18px;">Semester <%= selectedStudent.getSemester() %></span>
            </div>
            <% } %>

            <div class="glass-card" style="padding: 24px; overflow-x: auto;">
                <h3 style="font-size: 1.05rem; font-weight: 800; color: var(--text-primary); margin-bottom: 16px;">
                    <i class="fa-solid fa-list-check" style="color: var(--gold); margin-right: 8px;"></i>Subject Analytics Breakdown
                </h3>

                <table class="data-table">
                    <thead>
                        <tr>
                            <th>Subject</th>
                            <th>Total Classes</th>
                            <th>Attended</th>
                            <th>Percentage</th>
                            <th>Status Warning</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                            if (summary != null && !summary.isEmpty()) {
                                for (Map<String, Object> row : summary) {
                                    int total = row.get("totalClasses") != null ? (int) row.get("totalClasses") : 0;
                                    int attended = row.get("presentClasses") != null ? (int) row.get("presentClasses") : 0;
                                    double percentage = (double) row.get("percentage");
                                    boolean lowAttendance = percentage < 75.0;
                        %>
                            <tr>
                                <td style="font-weight: 700; color: var(--text-primary);"><%= row.get("subjectName") %></td>
                                <td><%= total %></td>
                                <td style="color: var(--success); font-weight: 700;"><%= attended %></td>
                                <td style="font-weight: 800; font-size: 1rem; color: <%= lowAttendance ? "#ef4444" : "var(--gold-light)" %>;">
                                    <%= String.format("%.1f", percentage) %>%
                                </td>
                                <td>
                                    <% if (lowAttendance) { %>
                                        <span class="btn-danger" style="display: inline-block; padding: 4px 12px; font-weight: 800;">
                                            <i class="fa-solid fa-triangle-exclamation"></i> Low Attendance (<75%)
                                        </span>
                                    <% } else { %>
                                        <span class="badge-gold" style="background: rgba(16, 185, 129, 0.2); color: #34d399; border-color: rgba(16, 185, 129, 0.4);">
                                            <i class="fa-solid fa-circle-check"></i> Good Standing
                                        </span>
                                    <% } %>
                                </td>
                            </tr>
                        <% 
                                }
                            } else {
                        %>
                            <tr>
                                <td colspan="5" style="padding: 40px; text-align: center; color: var(--text-muted);">
                                    Select a student above to generate attendance analytics.
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </main>
    </div>
</body>
</html>
