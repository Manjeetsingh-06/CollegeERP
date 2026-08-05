<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Student" %>
<%@ page import="model.User" %>
<%
    User loggedUser = (User) session.getAttribute("loggedUser");
    if (loggedUser == null) { response.sendRedirect("login.jsp"); return; }
    String userRole = loggedUser.getRole();
    boolean isAdmin = "ADMIN".equals(userRole);
    List<Student> studentList = (List<Student>) request.getAttribute("studentList");
    String searchQuery = (String) request.getAttribute("searchQuery");
    String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Directory - University of Lucknow ERP</title>
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
                    <h2>🎓 Student Management & Directory</h2>
                    <p>Search, manage, and view student records.</p>
                </div>
                <% if(isAdmin) { %>
                <a href="students?action=add" class="btn-primary" style="width: auto;">
                    <i class="fa-solid fa-user-plus"></i> Add New Student
                </a>
                <% } %>
            </header>

            <% if (msg != null) { %>
                <div class="alert alert-success">
                    <i class="fa-solid fa-circle-check"></i>
                    <span><%= msg %></span>
                </div>
            <% } %>

            <!-- Search Bar -->
            <div class="glass-card" style="padding: 22px; margin-bottom: 24px;">
                <form action="students" method="GET" style="display: flex; gap: 14px; align-items: center; flex-wrap: wrap;">
                    <input type="hidden" name="action" value="search">
                    <div class="input-wrapper" style="flex: 1; min-width: 250px;">
                        <input type="text" name="query" class="form-control" placeholder="Search by student name or roll number..." value="<%= searchQuery != null ? searchQuery : "" %>">
                        <i class="fa-solid fa-magnifying-glass"></i>
                    </div>
                    <button type="submit" class="btn-primary" style="width: auto; padding: 12px 24px;">Search Directory</button>
                    <% if (searchQuery != null && !searchQuery.isEmpty()) { %>
                        <a href="students" class="btn-demo" style="padding: 12px; text-decoration: none;">Reset Filter</a>
                    <% } %>
                </form>
            </div>

            <!-- Student Directory Table -->
            <div class="glass-card" style="padding: 24px; overflow-x: auto;">
                <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:16px;">
                    <h3 style="font-size:1.1rem;font-weight:800;color:var(--text-primary);"><i class="fa-solid fa-users" style="color:var(--gold);margin-right:8px;"></i>Registered Students</h3>
                    <span class="badge-gold"><%= studentList != null ? studentList.size() : 0 %> Students</span>
                </div>

                <table class="data-table">
                    <thead>
                        <tr>
                            <th>Roll Number</th>
                            <th>Full Name</th>
                            <th>Email</th>
                            <th>Phone</th>
                            <th>Department</th>
                            <th>Semester</th>
                            <% if(isAdmin) { %><th>Actions</th><% } %>
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
                                <td><%= s.getEmail() %></td>
                                <td><%= s.getPhone() != null ? s.getPhone() : "N/A" %></td>
                                <td><span class="badge-violet"><%= s.getDeptName() != null ? s.getDeptName() : "General" %></span></td>
                                <td>Semester <%= s.getSemester() %></td>
                                <% if(isAdmin) { %>
                                <td>
                                    <a href="students?action=edit&id=<%= s.getId() %>" class="btn-demo" style="padding: 6px 12px;"><i class="fa-solid fa-pen-to-square"></i> Edit</a>
                                    <a href="students?action=delete&id=<%= s.getId() %>&userId=<%= s.getUserId() %>" onclick="return confirm('Delete student?')" class="btn-danger" style="text-decoration:none;display:inline-block;padding:6px 12px;"><i class="fa-solid fa-trash"></i> Delete</a>
                                </td>
                                <% } %>
                            </tr>
                        <% 
                                }
                            } else {
                        %>
                            <tr>
                                <td colspan="<%= isAdmin ? "7" : "6" %>" style="padding: 40px; text-align: center; color: var(--text-muted);">
                                    <i class="fa-solid fa-user-graduate" style="font-size: 3rem; display: block; margin-bottom: 12px; opacity: 0.25;"></i>
                                    No students found matching your criteria.
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
