<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User, model.BookIssue, java.util.List, java.sql.Date, java.time.LocalDate" %>
<%
    User loggedUser = (User) session.getAttribute("loggedUser");
    if (loggedUser == null) { response.sendRedirect("login.jsp"); return; }
    String userRole = loggedUser.getRole();
    List<BookIssue> issuedList = (List<BookIssue>) request.getAttribute("issuedList");
    String msg = request.getParameter("msg");
    Date today = Date.valueOf(LocalDate.now());
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Issued Books - University of Lucknow ERP</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="css/style.css">
    <style>
        .overdue-row { background: rgba(239,68,68,0.08) !important; border-left: 4px solid #ef4444; }
        .badge-overdue { background:rgba(239,68,68,0.18);color:#fca5a5;border:1px solid rgba(239,68,68,0.3);padding:4px 12px;border-radius:20px;font-size:0.75rem;font-weight:700; }
        .badge-active { background:rgba(251,191,36,0.18);color:#fbbf24;border:1px solid rgba(251,191,36,0.3);padding:4px 12px;border-radius:20px;font-size:0.75rem;font-weight:700; }
        .badge-returned { background:rgba(16,185,129,0.18);color:#34d399;border:1px solid rgba(16,185,129,0.3);padding:4px 12px;border-radius:20px;font-size:0.75rem;font-weight:700; }
    </style>
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
                    <h2><i class="fa-solid fa-bookmark" style="color:var(--gold-light);margin-right:10px;"></i>Issued Books</h2>
                    <p>Track active issues, due dates, and overdue returns.</p>
                </div>
                <a href="library" class="btn-demo" style="padding:10px 18px;text-decoration:none;"><i class="fa-solid fa-arrow-left"></i> Back to Library</a>
            </header>

            <% if(msg != null) { %><div class="alert alert-success"><i class="fa-solid fa-circle-check"></i> <span><%=msg%></span></div><% } %>

            <div class="glass-card" style="padding:0;">
                <div style="padding:20px 24px;border-bottom:1px solid var(--border-glass);display:flex;justify-content:space-between;align-items:center;">
                    <h3 style="font-size:1.05rem;font-weight:700;color:var(--text-primary);">Book Circulation Records</h3>
                    <span class="badge-gold"><%=issuedList != null ? issuedList.size() : 0%> Total Circulation Records</span>
                </div>
                <div style="overflow-x:auto;">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Book Title</th>
                                <th>Student</th>
                                <th>Issue Date</th>
                                <th>Due Date</th>
                                <th>Status</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                        <% if(issuedList != null && !issuedList.isEmpty()) {
                            int sr = 1;
                            for(BookIssue bi : issuedList) {
                                boolean isOverdue = bi.getReturnDate() == null && bi.getDueDate() != null && bi.getDueDate().before(today);
                        %>
                        <tr class="<%=isOverdue ? "overdue-row" : ""%>">
                            <td><%=sr++%></td>
                            <td><strong style="color:var(--text-primary);"><%=bi.getBookTitle() != null ? bi.getBookTitle() : "—"%></strong></td>
                            <td>
                                <div style="color:var(--text-primary);font-weight:600;"><%=bi.getStudentName() != null ? bi.getStudentName() : "—"%></div>
                                <div style="color:var(--text-muted);font-size:0.78rem;"><%=bi.getRollNumber() != null ? bi.getRollNumber() : ""%></div>
                            </td>
                            <td><%=bi.getIssueDate()%></td>
                            <td>
                                <span style="color:<%=isOverdue ? "#fca5a5" : "var(--text-secondary)"%>;"><%=bi.getDueDate()%></span>
                                <% if(isOverdue) { %><br><small style="color:#ef4444;font-size:0.73rem;"><i class="fa-solid fa-triangle-exclamation"></i> Overdue</small><% } %>
                            </td>
                            <td>
                                <% if(bi.getReturnDate() != null) { %>
                                    <span class="badge-returned"><i class="fa-solid fa-check"></i> Returned</span>
                                <% } else if(isOverdue) { %>
                                    <span class="badge-overdue"><i class="fa-solid fa-clock"></i> Overdue</span>
                                <% } else { %>
                                    <span class="badge-active"><i class="fa-solid fa-circle"></i> Active</span>
                                <% } %>
                            </td>
                            <td>
                                <% if(bi.getReturnDate() == null) { %>
                                <a href="library?action=return&id=<%=bi.getId()%>"
                                   onclick="return confirm('Mark this book as returned?')"
                                   style="background:rgba(239,68,68,0.15);color:#fca5a5;border:1px solid rgba(239,68,68,0.3);padding:6px 14px;border-radius:8px;font-size:0.8rem;text-decoration:none;display:inline-flex;align-items:center;gap:6px;">
                                    <i class="fa-solid fa-undo"></i> Return Book
                                </a>
                                <% } else { %>
                                <span style="color:var(--text-muted);font-size:0.8rem;"><i class="fa-solid fa-check-double"></i> Completed</span>
                                <% } %>
                                <% if(bi.getFineAmount() > 0) { %>
                                <br><small style="color:var(--gold-light);font-weight:700;">Fine: ₹<%=bi.getFineAmount()%></small>
                                <% } %>
                            </td>
                        </tr>
                        <% } } else { %>
                        <tr><td colspan="7" style="text-align:center;padding:40px;color:var(--text-muted);">
                            <i class="fa-solid fa-bookmark" style="font-size:2rem;display:block;margin-bottom:10px;opacity:0.3;"></i>
                            No books currently issued.
                        </td></tr>
                        <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </main>
    </div>
</body>
</html>
