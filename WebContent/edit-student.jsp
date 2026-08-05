<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Department" %>
<%@ page import="model.Student" %>
<%@ page import="model.User" %>
<%
    User loggedUser = (User) session.getAttribute("loggedUser");
    if (loggedUser == null) { response.sendRedirect("login.jsp"); return; }
    Student student = (Student) request.getAttribute("student");
    List<Department> deptList = (List<Department>) request.getAttribute("deptList");
    if (student == null) { response.sendRedirect("students"); return; }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Student - University of Lucknow ERP</title>
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
                    <h2>✏️ Edit Student Profile</h2>
                    <p>Update student records for <strong><%= student.getFullName() %></strong></p>
                </div>
                <a href="students" class="btn-demo" style="padding: 10px 18px; text-decoration: none;">
                    <i class="fa-solid fa-arrow-left"></i> Back to Students List
                </a>
            </header>

            <div class="glass-card" style="padding: 32px; max-width: 750px;">
                <form action="students" method="POST">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="id" value="<%= student.getId() %>">

                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px;">
                        <div class="form-group">
                            <label>Roll Number</label>
                            <div class="input-wrapper">
                                <input type="text" class="form-control" value="<%= student.getRollNumber() %>" disabled style="color: var(--text-muted);">
                                <i class="fa-solid fa-id-card"></i>
                            </div>
                        </div>

                        <div class="form-group">
                            <label>Full Name</label>
                            <div class="input-wrapper">
                                <input type="text" name="fullName" class="form-control" value="<%= student.getFullName() %>" required>
                                <i class="fa-solid fa-user"></i>
                            </div>
                        </div>
                    </div>

                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px;">
                        <div class="form-group">
                            <label>Email Address</label>
                            <div class="input-wrapper">
                                <input type="email" name="email" class="form-control" value="<%= student.getEmail() %>" required>
                                <i class="fa-solid fa-envelope"></i>
                            </div>
                        </div>

                        <div class="form-group">
                            <label>Phone Number</label>
                            <div class="input-wrapper">
                                <input type="text" name="phone" class="form-control" value="<%= student.getPhone() != null ? student.getPhone() : "" %>">
                                <i class="fa-solid fa-phone"></i>
                            </div>
                        </div>
                    </div>

                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px;">
                        <div class="form-group">
                            <label>Department</label>
                            <select name="deptId" class="form-control" style="padding-left: 14px;" required>
                                <% if (deptList != null) { for (Department d : deptList) { %>
                                    <option value="<%= d.getId() %>" <%= d.getId() == student.getDeptId() ? "selected" : "" %>><%= d.getDeptCode() %> - <%= d.getDeptName() %></option>
                                <% } } %>
                            </select>
                        </div>

                        <div class="form-group">
                            <label>Semester</label>
                            <select name="semester" class="form-control" style="padding-left: 14px;" required>
                                <% for (int i = 1; i <= 8; i++) { %>
                                    <option value="<%= i %>" <%= i == student.getSemester() ? "selected" : "" %>>Semester <%= i %></option>
                                <% } %>
                            </select>
                        </div>
                    </div>

                    <button type="submit" class="btn-primary" style="margin-top: 10px;">
                        <i class="fa-solid fa-floppy-disk"></i> Update Student Profile
                    </button>
                </form>
            </div>
        </main>
    </div>
</body>
</html>
