<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Subject" %>
<%@ page import="model.Student" %>
<%@ page import="model.User" %>
<%
    User loggedUser = (User) session.getAttribute("loggedUser");
    if (loggedUser == null) { response.sendRedirect("login.jsp"); return; }
    List<Subject> subjectList = (List<Subject>) request.getAttribute("subjectList");
    List<Student> studentList = (List<Student>) request.getAttribute("studentList");
    String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Marks Entry - University of Lucknow ERP</title>
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
                    <h2>📝 Student Marks & Result Entry</h2>
                    <p>Enter internal and external examination marks for class students.</p>
                </div>
                <a href="marks?action=marksheet" class="btn-secondary" style="text-decoration:none;">
                    <i class="fa-solid fa-file-invoice"></i> Student Marksheet
                </a>
            </header>

            <% if (msg != null) { %>
                <div class="alert alert-success">
                    <i class="fa-solid fa-circle-check"></i>
                    <span><%= msg %></span>
                </div>
            <% } %>

            <form action="marks" method="POST">
                <div class="glass-card" style="padding: 24px; margin-bottom: 24px;">
                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px;">
                        <div class="form-group" style="margin: 0;">
                            <label>Select Subject</label>
                            <select name="subjectId" class="form-control" style="padding-left: 14px;" required>
                                <option value="">-- Choose Subject --</option>
                                <% if (subjectList != null) { for (Subject s : subjectList) { %>
                                    <option value="<%= s.getId() %>"><%= s.getSubjectCode() %> - <%= s.getSubjectName() %></option>
                                <% } } %>
                            </select>
                        </div>

                        <div class="form-group" style="margin: 0;">
                            <label>Select Student</label>
                            <select name="studentId" class="form-control" style="padding-left: 14px;" required>
                                <option value="">-- Choose Student --</option>
                                <% if (studentList != null) { for (Student st : studentList) { %>
                                    <option value="<%= st.getId() %>"><%= st.getRollNumber() %> - <%= st.getFullName() %></option>
                                <% } } %>
                            </select>
                        </div>
                    </div>
                </div>

                <div class="glass-card" style="padding: 28px; max-width: 700px;">
                    <h3 style="font-size: 1.1rem; font-weight: 800; color: var(--text-primary); margin-bottom: 20px;">
                        <i class="fa-solid fa-award" style="color: var(--gold); margin-right: 8px;"></i>Examination Marks Evaluation
                    </h3>

                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px;">
                        <div class="form-group">
                            <label>Internal Marks (Max 40)</label>
                            <div class="input-wrapper">
                                <input type="number" step="0.5" name="internalMarks" class="form-control" placeholder="0 - 40" min="0" max="40" required>
                                <i class="fa-solid fa-pen-clip"></i>
                            </div>
                        </div>

                        <div class="form-group">
                            <label>External Marks (Max 60)</label>
                            <div class="input-wrapper">
                                <input type="number" step="0.5" name="externalMarks" class="form-control" placeholder="0 - 60" min="0" max="60" required>
                                <i class="fa-solid fa-graduation-cap"></i>
                            </div>
                        </div>
                    </div>

                    <button type="submit" class="btn-primary" style="margin-top: 10px; width: auto; padding: 14px 32px;">
                        <i class="fa-solid fa-check"></i> Submit Student Marks
                    </button>
                </div>
            </form>
        </main>
    </div>
</body>
</html>
