<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Department" %>
<%@ page import="model.User" %>
<%
    User loggedUser = (User) session.getAttribute("loggedUser");
    if (loggedUser == null) { response.sendRedirect("login.jsp"); return; }
    String userRole = loggedUser.getRole();
    boolean isAdmin = "ADMIN".equals(userRole);
    List<Department> deptList = (List<Department>) request.getAttribute("deptList");
    String msg = request.getParameter("msg");
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Department Management - University of Lucknow ERP</title>
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
                    <h2>🏢 Department Management</h2>
                    <p><%= isAdmin ? "Configure institutional academic departments." : "View active college departments." %></p>
                </div>
            </header>

            <% if (msg != null) { %>
                <div class="alert alert-success">
                    <i class="fa-solid fa-circle-check"></i>
                    <span><%= msg %></span>
                </div>
            <% } %>
            <% if (error != null) { %>
                <div class="alert alert-danger">
                    <i class="fa-solid fa-triangle-exclamation"></i>
                    <span><%= error %></span>
                </div>
            <% } %>

            <div class="content-grid" style="<%= isAdmin ? "" : "grid-template-columns: 1fr;" %>">
                
                <!-- Add Department Form (ADMIN ONLY) -->
                <% if (isAdmin) { %>
                <div class="glass-card" style="padding: 24px;">
                    <div class="card-title" style="margin-bottom: 20px;">
                        <i class="fa-solid fa-plus-circle" style="color: var(--gold);"></i>
                        <span style="font-weight: 800; font-size: 1.1rem;">Add New Department</span>
                    </div>

                    <form action="departments" method="POST">
                        <div class="form-group">
                            <label>Department Code</label>
                            <div class="input-wrapper">
                                <input type="text" name="deptCode" class="form-control" placeholder="e.g. CSE, ECE, ME" required style="text-transform: uppercase;">
                                <i class="fa-solid fa-barcode"></i>
                            </div>
                        </div>

                        <div class="form-group">
                            <label>Department Name</label>
                            <div class="input-wrapper">
                                <input type="text" name="deptName" class="form-control" placeholder="e.g. Computer Science Engineering" required>
                                <i class="fa-solid fa-building"></i>
                            </div>
                        </div>

                        <button type="submit" class="btn-primary">
                            <i class="fa-solid fa-check"></i> Add Department
                        </button>
                    </form>
                </div>
                <% } %>

                <!-- Department Directory Table -->
                <div class="glass-card" style="padding: 24px; overflow-x: auto;">
                    <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:16px;">
                        <h3 style="font-size:1.1rem;font-weight:800;color:var(--text-primary);"><i class="fa-solid fa-building-columns" style="color:var(--gold);margin-right:8px;"></i>Active Departments</h3>
                        <span class="badge-gold"><%= deptList != null ? deptList.size() : 0 %> Departments</span>
                    </div>

                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Dept Code</th>
                                <th>Department Name</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% 
                                if (deptList != null && !deptList.isEmpty()) {
                                    for (Department d : deptList) {
                            %>
                                <tr>
                                    <td>#<%= d.getId() %></td>
                                    <td style="font-weight: 800; color: var(--gold-light);"><%= d.getDeptCode() %></td>
                                    <td style="font-weight: 600;"><%= d.getDeptName() %></td>
                                </tr>
                            <% 
                                    }
                                } else {
                            %>
                                <tr>
                                    <td colspan="3" style="padding: 40px; text-align: center; color: var(--text-muted);">
                                        No departments registered yet.
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>

            </div>

        </main>
    </div>
</body>
</html>
