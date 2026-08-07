<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%
    User sUser = (User) session.getAttribute("loggedUser");
    String sRole = (sUser != null) ? sUser.getRole() : "";
    String currentPage = request.getRequestURI();
    String actionParam = request.getParameter("action");
%>
<!-- Mobile Overlay -->
<div class="sidebar-overlay" id="sidebarOverlay"></div>

<aside class="sidebar">
    <div class="sidebar-brand">
        <div class="logo-icon"><i class="fa-solid fa-university"></i></div>
        <div>
            <h2 style="font-size:15px;line-height:1.2;">University of Lucknow</h2>
            <span style="font-size:10px;color:var(--gold-light);font-weight:600;letter-spacing:0.5px;">ERP MANAGEMENT SYSTEM</span>
        </div>
        <button type="button" class="mobile-close-btn" id="mobileMenuClose"
            onclick="document.querySelector('.sidebar').classList.remove('show-mobile');document.getElementById('sidebarOverlay').classList.remove('show');">
            <i class="fa-solid fa-xmark"></i>
        </button>
    </div>

    <ul class="nav-menu">
        <li class="nav-item <%= currentPage.contains("dashboard") ? "active" : "" %>">
            <a href="dashboard.jsp"><i class="fa-solid fa-chart-line"></i> <span>Dashboard</span></a>
        </li>

        <% if ("ADMIN".equals(sRole)) { %>
            <li class="nav-item <%= currentPage.contains("student") ? "active" : "" %>">
                <a href="students"><i class="fa-solid fa-user-graduate"></i> <span>Students</span></a>
            </li>
            <li class="nav-item <%= currentPage.contains("faculty") ? "active" : "" %>">
                <a href="faculty"><i class="fa-solid fa-chalkboard-user"></i> <span>Faculty</span></a>
            </li>
            <li class="nav-item <%= currentPage.contains("departments") ? "active" : "" %>">
                <a href="departments"><i class="fa-solid fa-building-columns"></i> <span>Departments</span></a>
            </li>
            <li class="nav-item <%= currentPage.contains("subjects") ? "active" : "" %>">
                <a href="subjects"><i class="fa-solid fa-book-open"></i> <span>Courses & Subjects</span></a>
            </li>
            <li class="nav-item <%= currentPage.contains("attendance") ? "active" : "" %>">
                <a href="attendance"><i class="fa-solid fa-clipboard-user"></i> <span>Attendance</span></a>
            </li>
            <li class="nav-item <%= currentPage.contains("marks") ? "active" : "" %>">
                <a href="marks"><i class="fa-solid fa-award"></i> <span>Marks & Results</span></a>
            </li>

            <!-- DEDICATED FINANCE & FEE OPTIONS FOR ADMIN -->
            <li class="nav-item <%= currentPage.contains("fees") && "structure".equals(actionParam) ? "active" : "" %>">
                <a href="fees?action=structure"><i class="fa-solid fa-gears"></i> <span>Fee Structure</span></a>
            </li>
            <li class="nav-item <%= currentPage.contains("fees") && ("pending".equals(actionParam) || actionParam == null) ? "active" : "" %>">
                <a href="fees?action=pending"><i class="fa-solid fa-receipt"></i> <span>Pending Fees Ledger</span></a>
            </li>
            <li class="nav-item <%= currentPage.contains("fees") && "pay".equals(actionParam) ? "active" : "" %>">
                <a href="fees?action=pay"><i class="fa-solid fa-credit-card"></i> <span>Pay Student Fees</span></a>
            </li>

            <li class="nav-item <%= currentPage.contains("library") || currentPage.contains("book") ? "active" : "" %>">
                <a href="library"><i class="fa-solid fa-book"></i> <span>Library</span></a>
            </li>

        <% } else if ("FACULTY".equals(sRole)) { %>
            <li class="nav-item <%= currentPage.contains("student") ? "active" : "" %>">
                <a href="students"><i class="fa-solid fa-user-graduate"></i> <span>Class Students</span></a>
            </li>
            <li class="nav-item <%= currentPage.contains("subjects") ? "active" : "" %>">
                <a href="subjects"><i class="fa-solid fa-book-open"></i> <span>Course Catalog</span></a>
            </li>
            <li class="nav-item <%= currentPage.contains("attendance") ? "active" : "" %>">
                <a href="attendance"><i class="fa-solid fa-clipboard-user"></i> <span>Mark Class Attendance</span></a>
            </li>
            <li class="nav-item <%= currentPage.contains("marks") ? "active" : "" %>">
                <a href="marks"><i class="fa-solid fa-award"></i> <span>Enter Class Marks</span></a>
            </li>

        <% } else { %>
            <li class="nav-item <%= currentPage.contains("attendance") ? "active" : "" %>">
                <a href="attendance?action=report"><i class="fa-solid fa-clipboard-user"></i> <span>My Attendance</span></a>
            </li>
            <li class="nav-item <%= currentPage.contains("marks") ? "active" : "" %>">
                <a href="marks?action=marksheet"><i class="fa-solid fa-award"></i> <span>My Results</span></a>
            </li>
            <li class="nav-item <%= currentPage.contains("fees") ? "active" : "" %>">
                <a href="fees?action=pay"><i class="fa-solid fa-indian-rupee-sign"></i> <span>Pay Fees</span></a>
            </li>
            <li class="nav-item <%= currentPage.contains("library") || currentPage.contains("book") ? "active" : "" %>">
                <a href="library"><i class="fa-solid fa-book"></i> <span>Library Books</span></a>
            </li>
        <% } %>

        <!-- COMMON MODULES -->
        <li class="nav-item <%= currentPage.contains("notices") ? "active" : "" %>">
            <a href="notices"><i class="fa-solid fa-bullhorn"></i> <span>Notices</span></a>
        </li>
        <li class="nav-item <%= currentPage.contains("timetable") ? "active" : "" %>">
            <a href="timetable"><i class="fa-solid fa-calendar-week"></i> <span>Timetable</span></a>
        </li>
        <li class="nav-item <%= currentPage.contains("complaints") ? "active" : "" %>">
            <a href="complaints"><i class="fa-solid fa-comments"></i> <span>Complaints & Help</span></a>
        </li>

        <li class="nav-item" style="margin-top: auto;">
            <a href="logout" style="color: #f87171;"><i class="fa-solid fa-right-from-bracket"></i> <span>Logout</span></a>
        </li>
    </ul>

    <!-- SIDEBAR FOOTER -->
    <div class="sidebar-footer">
        <i class="fa-solid fa-university" style="color:var(--gold);margin-bottom:6px;font-size:18px;"></i>
        <p style="font-size:11px;font-weight:700;color:var(--gold-light);margin-bottom:2px;">University of Lucknow, Lucknow</p>
        <p style="font-size:10px;color:var(--text-muted);">&copy; 2025 <strong>University of Lucknow, Lucknow</strong>. All Rights Reserved.</p>
        <p style="font-size:10px;color:var(--text-muted);">Developed by <strong style="color:var(--gold-light);">Manjeet Singh</strong></p>
    </div>
</aside>
