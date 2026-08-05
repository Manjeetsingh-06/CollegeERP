<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User, model.Book, model.Student, java.util.List" %>
<%
    User loggedUser = (User) session.getAttribute("loggedUser");
    if (loggedUser == null) { response.sendRedirect("login.jsp"); return; }
    String userRole = loggedUser.getRole();
    List<Book> bookList = (List<Book>) request.getAttribute("bookList");
    List<Student> studentList = (List<Student>) request.getAttribute("studentList");
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Issue Book - University of Lucknow ERP</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="css/style.css">
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
                    <h2><i class="fa-solid fa-hand-holding-heart" style="color:var(--gold-light);margin-right:10px;"></i>Issue Book</h2>
                    <p>Issue a library book to a registered student.</p>
                </div>
                <a href="library" class="btn-demo" style="padding:10px 18px;text-decoration:none;"><i class="fa-solid fa-arrow-left"></i> Back to Library</a>
            </header>

            <% if(error != null) { %>
            <div class="alert alert-danger"><i class="fa-solid fa-circle-exclamation"></i> <span><%=error%></span></div>
            <% } %>

            <div class="glass-card" style="max-width:600px;padding:28px;border-color:var(--border-gold);">
                <h3 style="font-size:1.05rem;font-weight:700;color:var(--text-primary);margin-bottom:20px;">
                    <i class="fa-solid fa-book-medical" style="color:var(--gold);margin-right:8px;"></i>Book Circulation Form
                </h3>
                <form action="library" method="post">
                    <input type="hidden" name="action" value="issueBook">
                    <div class="form-group">
                        <label class="form-label">Select Book</label>
                        <select name="bookId" class="form-control" style="padding-left:14px;" required>
                            <option value="">-- Choose Book --</option>
                            <% if(bookList != null) { for(Book b : bookList) { if(b.getAvailableCopies() > 0) { %>
                            <option value="<%=b.getId()%>"><%=b.getTitle()%> — <%=b.getAuthor()%> (<%=b.getAvailableCopies()%> available)</option>
                            <% } } } %>
                        </select>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Select Student</label>
                        <select name="studentId" class="form-control" style="padding-left:14px;" required>
                            <option value="">-- Choose Student --</option>
                            <% if(studentList != null) { for(Student s : studentList) { %>
                            <option value="<%=s.getId()%>"><%=s.getRollNumber()%> — <%=s.getFullName()%></option>
                            <% } } %>
                        </select>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Issue Date</label>
                        <div class="input-wrapper">
                            <input type="text" class="form-control" value="Today (Auto-assigned)" disabled style="color:var(--text-muted);">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Due Return Date</label>
                        <div class="input-wrapper">
                            <input type="text" class="form-control" value="Auto: 14 days from today" disabled style="color:var(--text-muted);">
                        </div>
                    </div>
                    <button type="submit" class="btn-primary" style="width:100%;margin-top:8px;">
                        <i class="fa-solid fa-check-circle"></i> Issue Book to Student
                    </button>
                </form>
            </div>
        </main>
    </div>
</body>
</html>
