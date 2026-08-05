<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Department" %>
<%@ page import="model.User" %>
<%
    User loggedUser = (User) session.getAttribute("loggedUser");
    if (loggedUser == null) { response.sendRedirect("login.jsp"); return; }
    List<Department> deptList = (List<Department>) request.getAttribute("deptList");
    String errorMessage = (String) request.getAttribute("errorMessage");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Faculty - University of Lucknow ERP</title>
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
                    <h2>👨‍🏫 Register Faculty Member</h2>
                    <p>Enter faculty credentials and department assignments.</p>
                </div>
                <a href="faculty" class="btn-demo" style="padding: 10px 18px; text-decoration: none;">
                    <i class="fa-solid fa-arrow-left"></i> Back to Faculty List
                </a>
            </header>

            <% if (errorMessage != null) { %>
                <div class="alert alert-danger">
                    <i class="fa-solid fa-circle-exclamation"></i>
                    <span><%= errorMessage %></span>
                </div>
            <% } %>

            <div class="glass-card" style="padding: 32px; max-width: 750px;">
                <form action="faculty" method="POST">
                    <input type="hidden" name="action" value="insert">

                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px;">
                        <div class="form-group">
                            <label>Employee Code</label>
                            <div class="input-wrapper">
                                <input type="text" name="empCode" class="form-control" placeholder="e.g. EMP101" required style="text-transform: uppercase;">
                                <i class="fa-solid fa-id-badge"></i>
                            </div>
                        </div>

                        <div class="form-group">
                            <label>Full Name</label>
                            <div class="input-wrapper">
                                <input type="text" name="fullName" class="form-control" placeholder="e.g. Prof. Sunita Verma" required>
                                <i class="fa-solid fa-user-tie"></i>
                            </div>
                        </div>
                    </div>

                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px;">
                        <div class="form-group">
                            <label>Email Address</label>
                            <div class="input-wrapper">
                                <input type="email" name="email" class="form-control" placeholder="sunita@college.edu" required>
                                <i class="fa-solid fa-envelope"></i>
                            </div>
                        </div>

                        <div class="form-group">
                            <label>Phone Number</label>
                            <div class="input-wrapper">
                                <input type="text" name="phone" class="form-control" placeholder="9876543210">
                                <i class="fa-solid fa-phone"></i>
                            </div>
                        </div>
                    </div>

                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px;">
                        <div class="form-group">
                            <label>Department</label>
                            <select name="deptId" class="form-control" style="padding-left: 14px;" required>
                                <option value="">-- Select Department --</option>
                                <% if (deptList != null) { for (Department d : deptList) { %>
                                    <option value="<%= d.getId() %>"><%= d.getDeptCode() %> - <%= d.getDeptName() %></option>
                                <% } } %>
                            </select>
                        </div>

                        <div class="form-group">
                            <label>Assign Password</label>
                            <div class="input-wrapper">
                                <input type="password" name="password" class="form-control" placeholder="Faculty password" required>
                                <i class="fa-solid fa-lock"></i>
                            </div>
                        </div>
                    </div>

                    <button type="submit" class="btn-primary" style="margin-top: 10px;">
                        <i class="fa-solid fa-user-check"></i> Register Faculty Member
                    </button>
                </form>
            </div>
        </main>
    </div>
</body>
</html>
