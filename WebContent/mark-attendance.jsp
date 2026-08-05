<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Subject" %>
<%@ page import="model.Student" %>
<%@ page import="model.User" %>
<%@ page import="java.time.LocalDate" %>
<%
    User loggedUser = (User) session.getAttribute("loggedUser");
    if (loggedUser == null) { response.sendRedirect("login.jsp"); return; }
    List<Subject> subjectList = (List<Subject>) request.getAttribute("subjectList");
    List<Student> studentList = (List<Student>) request.getAttribute("studentList");
    String msg = request.getParameter("msg");
    String todayDate = LocalDate.now().toString();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mark Attendance - University of Lucknow ERP</title>
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
                    <h2>📋 Class Attendance Entry</h2>
                    <p>Mark daily attendance for class students by subject.</p>
                </div>
                <a href="attendance?action=report" class="btn-secondary" style="text-decoration:none;">
                    <i class="fa-solid fa-chart-pie"></i> Attendance Report
                </a>
            </header>

            <% if (msg != null) { %>
                <div class="alert alert-success">
                    <i class="fa-solid fa-circle-check"></i>
                    <span><%= msg %></span>
                </div>
            <% } %>

            <form action="attendance" method="POST">
                <div class="glass-card" style="padding: 24px; margin-bottom: 24px;">
                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px;">
                        <div class="form-group" style="margin: 0;">
                            <label>Subject</label>
                            <select name="subjectId" class="form-control" style="padding-left: 14px;" required>
                                <option value="">-- Select Subject --</option>
                                <% if (subjectList != null) { for (Subject s : subjectList) { %>
                                    <option value="<%= s.getId() %>"><%= s.getSubjectCode() %> - <%= s.getSubjectName() %></option>
                                <% } } %>
                            </select>
                        </div>

                        <div class="form-group" style="margin: 0;">
                            <label>Attendance Date</label>
                            <div class="input-wrapper">
                                <input type="date" name="attendanceDate" class="form-control" value="<%= todayDate %>" required style="padding-left: 14px;">
                            </div>
                        </div>
                    </div>
                </div>

                <div class="glass-card" style="padding: 24px; overflow-x: auto;">
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px;">
                        <h3 style="font-size: 1.1rem; font-weight: 800; color: var(--text-primary);">
                            <i class="fa-solid fa-users-viewfinder" style="color: var(--gold); margin-right: 8px;"></i>Student List (<%= studentList != null ? studentList.size() : 0 %>)
                        </h3>
                    </div>

                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Roll Number</th>
                                <th>Student Name</th>
                                <th>Department</th>
                                <th>Attendance Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% 
                                if (studentList != null && !studentList.isEmpty()) {
                                    for (Student s : studentList) {
                            %>
                                <tr>
                                    <td style="font-weight: 800; color: var(--gold-light);"><%= s.getRollNumber() %></td>
                                    <td style="font-weight: 600;"><%= s.getFullName() %></td>
                                    <td><span class="badge-violet"><%= s.getDeptName() != null ? s.getDeptName() : "Gen" %></span></td>
                                    <td>
                                        <div style="display: flex; gap: 16px;">
                                            <label style="display: flex; align-items: center; gap: 6px; cursor: pointer; color: var(--success); font-weight: 700;">
                                                <input type="radio" name="status_<%= s.getId() %>" value="PRESENT" checked> Present
                                            </label>
                                            <label style="display: flex; align-items: center; gap: 6px; cursor: pointer; color: var(--danger); font-weight: 700;">
                                                <input type="radio" name="status_<%= s.getId() %>" value="ABSENT"> Absent
                                            </label>
                                        </div>
                                    </td>
                                </tr>
                            <% 
                                    }
                                } else {
                            %>
                                <tr>
                                    <td colspan="4" style="padding: 40px; text-align: center; color: var(--text-muted);">
                                        No students available to mark attendance.
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>

                    <% if (studentList != null && !studentList.isEmpty()) { %>
                    <button type="submit" class="btn-primary" style="margin-top: 24px; width: auto; padding: 14px 32px;">
                        <i class="fa-solid fa-cloud-arrow-up"></i> Save Class Attendance
                    </button>
                    <% } %>
                </div>
            </form>
        </main>
    </div>
</body>
</html>
