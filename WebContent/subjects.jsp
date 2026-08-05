<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Subject" %>
<%@ page import="model.Department" %>
<%@ page import="model.User" %>
<%
    User loggedUser = (User) session.getAttribute("loggedUser");
    if (loggedUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String userRole = loggedUser.getRole();
    boolean isAdmin = "ADMIN".equals(userRole);
    List<Subject> subjectList = (List<Subject>) request.getAttribute("subjectList");
    List<Department> deptList = (List<Department>) request.getAttribute("deptList");
    String msg = request.getParameter("msg");
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Subject Directory - University of Lucknow ERP</title>
    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="css/style.css?v=6.0">
</head>
<body>

    <div class="bg-glow-1"></div>
    <div class="bg-glow-2"></div>

    <div class="app-container glass-container">
        
        <aside class="sidebar">
            <div class="sidebar-brand">
                <div class="logo-icon"><i class="fa-solid fa-university"></i></div>
                <h2>University of Lucknow ERP</h2>
            </div>
            <ul class="nav-menu">
                <li class="nav-item"><a href="dashboard.jsp"><i class="fa-solid fa-chart-line"></i> <span>Dashboard</span></a></li>
                <% if ("ADMIN".equals(userRole)) { %>
                <li class="nav-item"><a href="students"><i class="fa-solid fa-user-graduate"></i> <span>Students</span></a></li>
                <li class="nav-item"><a href="faculty"><i class="fa-solid fa-chalkboard-user"></i> <span>Faculty</span></a></li>
                <li class="nav-item"><a href="departments"><i class="fa-solid fa-building-columns"></i> <span>Departments</span></a></li>
                <% } else if ("FACULTY".equals(userRole)) { %>
                <li class="nav-item"><a href="students"><i class="fa-solid fa-user-graduate"></i> <span>Class Students</span></a></li>
                <% } %>
                <li class="nav-item active"><a href="subjects"><i class="fa-solid fa-book-open"></i> <span>Subjects</span></a></li>
                <li class="nav-item"><a href="attendance"><i class="fa-solid fa-clipboard-user"></i> <span>Attendance</span></a></li>
                <li class="nav-item"><a href="marks"><i class="fa-solid fa-award"></i> <span>Marks & Results</span></a></li>
                <li class="nav-item"><a href="fees"><i class="fa-solid fa-indian-rupee-sign"></i> <span>Finance</span></a></li>
                <li class="nav-item"><a href="library"><i class="fa-solid fa-book"></i> <span>Library</span></a></li>
                <li class="nav-item"><a href="notices"><i class="fa-solid fa-bullhorn"></i> <span>Notices</span></a></li>
                <li class="nav-item"><a href="timetable"><i class="fa-solid fa-calendar-week"></i> <span>Timetable</span></a></li>
                <li class="nav-item"><a href="complaints"><i class="fa-solid fa-comments"></i> <span>Complaints</span></a></li>
                <li class="nav-item" style="margin-top: auto;">
                    <a href="logout" style="color: var(--danger);"><i class="fa-solid fa-right-from-bracket"></i> <span>Logout</span></a>
                </li>
            </ul>
        </aside>

        <main class="main-content">
            
            <header class="top-navbar">
                <button type="button" class="mobile-toggle-btn" id="mobileMenuToggle"><i class="fa-solid fa-bars"></i></button>
                <div class="welcome-title">
                    <h2>📚 Subject & Course Directory</h2>
                    <p><%= isAdmin ? "Manage and configure institutional courses." : "View assigned subjects and course catalog." %></p>
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
                
                <!-- Add Subject Form (ADMIN ONLY) -->
                <% if (isAdmin) { %>
                <div class="glass-card" style="padding: 24px;">
                    <div class="card-title">
                        <i class="fa-solid fa-plus-circle" style="color: var(--gold);"></i>
                        <span>Add New Subject</span>
                    </div>

                    <form action="subjects" method="POST">
                        <div class="form-group">
                            <label>Subject Code</label>
                            <div class="input-wrapper">
                                <input type="text" name="subjectCode" class="form-control" placeholder="e.g. CS101, EC201" required>
                                <i class="fa-solid fa-barcode"></i>
                            </div>
                        </div>

                        <div class="form-group">
                            <label>Subject Name</label>
                            <div class="input-wrapper">
                                <input type="text" name="subjectName" class="form-control" placeholder="e.g. Data Structures" required>
                                <i class="fa-solid fa-book"></i>
                            </div>
                        </div>

                        <div class="form-group">
                            <label>Department</label>
                            <select name="deptId" class="form-control" style="padding-left: 14px;" required>
                                <option value="">-- Select Department --</option>
                                <% 
                                    if (deptList != null) {
                                        for (Department d : deptList) {
                                %>
                                    <option value="<%= d.getId() %>"><%= d.getDeptCode() %> - <%= d.getDeptName() %></option>
                                <% 
                                        }
                                    } 
                                %>
                            </select>
                        </div>

                        <div class="form-group">
                            <label>Semester</label>
                            <select name="semester" class="form-control" style="padding-left: 14px;" required>
                                <% for (int i = 1; i <= 8; i++) { %>
                                    <option value="<%= i %>">Semester <%= i %></option>
                                <% } %>
                            </select>
                        </div>

                        <button type="submit" class="btn-primary">
                            <i class="fa-solid fa-check"></i> Add Subject
                        </button>
                    </form>
                </div>
                <% } %>

                <!-- Subjects Directory List -->
                <div class="glass-card" style="padding: 24px; overflow-x: auto;">
                    <div class="card-title" style="display:flex;justify-content:space-between;align-items:center;">
                        <div>
                            <i class="fa-solid fa-list-check" style="color: var(--gold-light);"></i>
                            <span>Course Directory (<%= subjectList != null ? subjectList.size() : 0 %>)</span>
                        </div>
                        <% if (!isAdmin) { %>
                        <span class="badge-gold"><i class="fa-solid fa-shield-halved"></i> Read-Only View</span>
                        <% } %>
                    </div>

                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Subject Code</th>
                                <th>Subject Name</th>
                                <th>Department</th>
                                <th>Semester</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% 
                                if (subjectList != null && !subjectList.isEmpty()) {
                                    for (Subject s : subjectList) {
                            %>
                                <tr>
                                    <td style="font-weight: 700; color: var(--gold-light);"><%= s.getSubjectCode() %></td>
                                    <td style="font-weight: 600;"><%= s.getSubjectName() %></td>
                                    <td>
                                        <span class="role-pill">
                                            <%= s.getDeptName() != null ? s.getDeptName() : "General" %>
                                        </span>
                                    </td>
                                    <td>Semester <%= s.getSemester() %></td>
                                </tr>
                            <% 
                                    }
                                } else {
                            %>
                                <tr>
                                    <td colspan="4" style="padding: 30px; text-align: center; color: var(--text-muted);">
                                        No subjects found.
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
