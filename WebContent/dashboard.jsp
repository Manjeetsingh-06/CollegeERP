<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%@ page import="dao.StudentDAO" %>
<%@ page import="dao.FacultyDAO" %>
<%@ page import="dao.DepartmentDAO" %>
<%
    User loggedUser = (User) session.getAttribute("loggedUser");
    if (loggedUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String userRole = loggedUser.getRole();
    String username = loggedUser.getUsername();

    // Live Database Statistics
    StudentDAO studentDAO = new StudentDAO();
    FacultyDAO facultyDAO = new FacultyDAO();
    DepartmentDAO departmentDAO = new DepartmentDAO();

    int studentCount = studentDAO.getStudentCount();
    int facultyCount = facultyDAO.getFacultyCount();
    int departmentCount = departmentDAO.getDepartmentCount();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= userRole %> Dashboard - University of Lucknow ERP System</title>
    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="css/style.css?v=6.0">
</head>
<body>

    <div class="bg-glow-1"></div>
    <div class="bg-glow-2"></div>

    <div class="app-container glass-container">
        
        <!-- Sidebar Navigation -->
        <%@ include file="sidebar.jsp" %>

        <!-- Main Content Area -->
        <main class="main-content">
            
            <!-- Top Navbar Header -->
            <header class="top-navbar">
                <div style="display:flex;align-items:center;gap:14px;">
                    <button type="button" class="mobile-toggle-btn" id="mobileMenuToggle">
                        <i class="fa-solid fa-bars"></i>
                    </button>
                    <div class="welcome-title">
                        <h2>Welcome back, <%= username %>! 👋</h2>
                        <p><%= userRole %> Portal Overview | <span id="liveClock">--:--:--</span></p>
                    </div>
                </div>

                <div class="user-profile-badge">
                    <div class="avatar"><%= username.substring(0, 1).toUpperCase() %></div>
                    <div>
                        <div style="font-weight: 700; font-size: 14px;"><%= username %></div>
                        <span class="role-pill"><%= userRole %></span>
                    </div>
                </div>
            </header>

            <!-- Statistics Overview Cards -->
            <section class="stats-grid">
                <div class="glass-card stat-card">
                    <div class="stat-icon icon-blue">
                        <i class="fa-solid fa-users"></i>
                    </div>
                    <div class="stat-value"><%= studentCount %></div>
                    <div class="stat-label">Total Registered Students</div>
                </div>

                <div class="glass-card stat-card">
                    <div class="stat-icon icon-cyan">
                        <i class="fa-solid fa-user-tie"></i>
                    </div>
                    <div class="stat-value"><%= facultyCount %></div>
                    <div class="stat-label">Faculty Members</div>
                </div>

                <div class="glass-card stat-card">
                    <div class="stat-icon icon-emerald">
                        <i class="fa-solid fa-graduation-cap"></i>
                    </div>
                    <div class="stat-value"><%= departmentCount %></div>
                    <div class="stat-label">Active Departments</div>
                </div>

                <div class="glass-card stat-card">
                    <div class="stat-icon icon-amber">
                        <i class="fa-solid fa-percent"></i>
                    </div>
                    <div class="stat-value">94.2%</div>
                    <div class="stat-label">Average Attendance Rate</div>
                </div>
            </section>

            <!-- Content Grid Section -->
            <section class="content-grid">
                
                <!-- Recent Notices Board -->
                <div class="glass-card" style="padding: 24px;">
                    <div class="card-title">
                        <i class="fa-solid fa-bullhorn" style="color: var(--accent);"></i>
                        <span>Recent Campus Notices</span>
                    </div>

                    <div class="notice-list">
                        <div class="notice-item">
                            <div class="notice-meta">
                                <span><i class="fa-solid fa-user-gear"></i> Admin</span>
                                <span><i class="fa-regular fa-clock"></i> Today</span>
                            </div>
                            <h4>Phase 2 Admin Module Live</h4>
                            <p>Student CRUD Management, Faculty Registration, and Department mapping are now active in the ERP portal.</p>
                        </div>

                        <div class="notice-item">
                            <div class="notice-meta">
                                <span><i class="fa-solid fa-building-columns"></i> Exam Cell</span>
                                <span><i class="fa-regular fa-clock"></i> Yesterday</span>
                            </div>
                            <h4>Mid-Semester Examination Schedule</h4>
                            <p>Mid-Semester examinations start from 15th August. Detailed timetable is available in your department tab.</p>
                        </div>
                    </div>
                </div>

                <!-- Quick Actions Panel -->
                <div class="glass-card" style="padding: 24px;">
                    <div class="card-title">
                        <i class="fa-solid fa-bolt" style="color: var(--warning);"></i>
                        <span>Quick Actions</span>
                    </div>

                    <div style="display: flex; flex-direction: column; gap: 12px;">
                        <% if ("ADMIN".equals(userRole)) { %>
                        <a href="students?action=add" class="btn-primary" style="font-size: 13px; padding: 10px; text-decoration: none;">
                            <i class="fa-solid fa-user-plus"></i> Add New Student
                        </a>
                        <a href="faculty?action=add" class="btn-primary" style="background: linear-gradient(135deg, #06b6d4, #0284c7); font-size: 13px; padding: 10px; text-decoration: none;">
                            <i class="fa-solid fa-user-shield"></i> Add Faculty Member
                        </a>
                        <a href="departments" class="btn-primary" style="background: linear-gradient(135deg, #10b981, #059669); font-size: 13px; padding: 10px; text-decoration: none;">
                            <i class="fa-solid fa-building"></i> Manage Departments
                        </a>
                        <% } else if ("FACULTY".equals(userRole)) { %>
                        <a href="students" class="btn-primary" style="font-size: 13px; padding: 10px; text-decoration: none;">
                            <i class="fa-solid fa-users"></i> View Students List
                        </a>
                        <% } else { %>
                        <button class="btn-primary" style="font-size: 13px; padding: 10px;">
                            <i class="fa-solid fa-file-pdf"></i> Download Marksheet
                        </button>
                        <% } %>
                    </div>
                </div>

            </section>

        </main>
    </div>

    <script src="js/main.js"></script>
</body>
</html>
