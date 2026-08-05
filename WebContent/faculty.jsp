<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Faculty" %>
<%@ page import="model.User" %>
<%
    User loggedUser = (User) session.getAttribute("loggedUser");
    if (loggedUser == null) { response.sendRedirect("login.jsp"); return; }
    String userRole = loggedUser.getRole();
    boolean isAdmin = "ADMIN".equals(userRole);
    List<Faculty> facultyList = (List<Faculty>) request.getAttribute("facultyList");
    String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Faculty Directory - University of Lucknow ERP</title>
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
                    <h2>👨‍🏫 Faculty Members Directory</h2>
                    <p>Academic faculty profiles and department assignments.</p>
                </div>
                <% if(isAdmin) { %>
                <a href="faculty?action=add" class="btn-primary" style="width: auto;">
                    <i class="fa-solid fa-user-plus"></i> Add Faculty Member
                </a>
                <% } %>
            </header>

            <% if (msg != null) { %>
                <div class="alert alert-success">
                    <i class="fa-solid fa-circle-check"></i>
                    <span><%= msg %></span>
                </div>
            <% } %>

            <!-- Faculty Directory Table -->
            <div class="glass-card" style="padding: 24px; overflow-x: auto;">
                <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:16px;">
                    <h3 style="font-size:1.1rem;font-weight:800;color:var(--text-primary);"><i class="fa-solid fa-chalkboard-user" style="color:var(--gold);margin-right:8px;"></i>Faculty Members</h3>
                    <span class="badge-gold"><%= facultyList != null ? facultyList.size() : 0 %> Members</span>
                </div>

                <table class="data-table">
                    <thead>
                        <tr>
                            <th>Emp Code</th>
                            <th>Full Name</th>
                            <th>Email</th>
                            <th>Phone</th>
                            <th>Department</th>
                            <% if(isAdmin) { %><th>Actions</th><% } %>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                            if (facultyList != null && !facultyList.isEmpty()) {
                                for (Faculty f : facultyList) {
                        %>
                            <tr>
                                <td style="font-weight: 800; color: var(--gold-light);"><%= f.getEmpCode() %></td>
                                <td style="font-weight: 600;"><%= f.getFullName() %></td>
                                <td><%= f.getEmail() %></td>
                                <td><%= f.getPhone() != null ? f.getPhone() : "N/A" %></td>
                                <td><span class="badge-violet"><%= f.getDeptName() != null ? f.getDeptName() : "General" %></span></td>
                                <% if(isAdmin) { %>
                                <td>
                                    <a href="faculty?action=delete&id=<%= f.getId() %>&userId=<%= f.getUserId() %>" onclick="return confirm('Delete faculty member?')" class="btn-danger" style="text-decoration:none;display:inline-block;padding:6px 12px;"><i class="fa-solid fa-trash"></i> Delete</a>
                                </td>
                                <% } %>
                            </tr>
                        <% 
                                }
                            } else {
                        %>
                            <tr>
                                <td colspan="<%= isAdmin ? "6" : "5" %>" style="padding: 40px; text-align: center; color: var(--text-muted);">
                                    <i class="fa-solid fa-chalkboard-user" style="font-size: 3rem; display: block; margin-bottom: 12px; opacity: 0.25;"></i>
                                    No faculty members registered yet.
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
