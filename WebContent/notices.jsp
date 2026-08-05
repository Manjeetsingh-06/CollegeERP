<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User, model.Notice, java.util.List" %>
<%
    User loggedUser = (User) session.getAttribute("loggedUser");
    if (loggedUser == null) { response.sendRedirect("login.jsp"); return; }
    String userRole = loggedUser.getRole();
    List<Notice> noticeList = (List<Notice>) request.getAttribute("noticeList");
    String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Notice Board - University of Lucknow ERP</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="css/style.css?v=6.0">
    <style>
        .notice-card {
            background: var(--bg-card);
            backdrop-filter: blur(25px);
            border: 1px solid var(--gold-border);
            border-radius: 18px;
            padding: 24px 28px;
            margin-bottom: 18px;
            transition: var(--transition);
            border-left: 5px solid var(--gold);
        }
        .notice-card:hover { border-color: var(--gold); box-shadow: 0 15px 40px rgba(255, 215, 0, 0.2); }
        .notice-title { font-family: 'Outfit', sans-serif; font-size: 1.15rem; font-weight: 800; color: var(--text-primary); margin: 12px 0 8px; }
        .notice-content { color: var(--text-secondary); font-size: 0.92rem; line-height: 1.7; }
        .compose-panel { background: linear-gradient(135deg, rgba(255, 215, 0, 0.1), rgba(99, 102, 241, 0.12)); border: 2px solid var(--gold-border); border-radius: 20px; padding: 28px; margin-bottom: 28px; box-shadow: var(--shadow-soft); }
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
                    <h2><i class="fa-solid fa-bullhorn" style="color:var(--gold);margin-right:10px;"></i>Notice Board & Announcements</h2>
                    <p>Institutional circulars, events, and official updates.</p>
                </div>
            </header>

            <% if(msg != null) { %><div class="alert alert-success"><i class="fa-solid fa-circle-check"></i> <span><%=msg%></span></div><% } %>

            <!-- Post Notice Form — Admin & Faculty -->
            <% if("ADMIN".equals(userRole) || "FACULTY".equals(userRole)) { %>
            <div class="compose-panel">
                <h3 style="font-family:'Outfit',sans-serif;font-size:1.1rem;font-weight:800;color:var(--text-primary);margin-bottom:18px;">
                    <i class="fa-solid fa-pen-to-square" style="color:var(--gold);margin-right:8px;"></i>Post Announcement / Notice
                </h3>
                <form action="notices" method="post">
                    <div style="display:grid;grid-template-columns:1fr 1fr;gap:16px;margin-bottom:14px;">
                        <div class="form-group" style="margin:0;">
                            <label class="form-label">Notice Title</label>
                            <input type="text" name="title" class="form-control" placeholder="Announcement subject..." required style="padding-left:14px;">
                        </div>
                        <div class="form-group" style="margin:0;">
                            <label class="form-label">Target Audience</label>
                            <select name="targetRole" class="form-control" style="padding-left:14px;">
                                <option value="ALL">Everyone</option>
                                <option value="STUDENT">Students Only</option>
                                <option value="FACULTY">Faculty Only</option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" style="margin-bottom:16px;">
                        <label class="form-label">Notice Details</label>
                        <textarea name="content" class="form-control" rows="3" placeholder="Write message details..." required style="padding-left:14px;"></textarea>
                    </div>
                    <button type="submit" class="btn-primary" style="width:auto;padding:12px 30px;">
                        <i class="fa-solid fa-paper-plane"></i> Publish Announcement
                    </button>
                </form>
            </div>
            <% } %>

            <!-- Notices Timeline Grid -->
            <div style="display:flex;flex-direction:column;gap:14px;">
                <% if(noticeList != null && !noticeList.isEmpty()) {
                    for(Notice n : noticeList) {
                        String tagLabel = "ALL".equals(n.getTargetRole()) ? "Everyone" :
                                          "STUDENT".equals(n.getTargetRole()) ? "Students" : "Faculty";
                %>
                <div class="notice-card">
                    <div style="display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:8px;">
                        <span class="badge-gold"><i class="fa-solid fa-users" style="margin-right:6px;"></i> Audience: <%=tagLabel%></span>
                        <span style="font-size:0.8rem;color:var(--text-muted);"><i class="fa-regular fa-clock" style="color:var(--gold);margin-right:5px;"></i><%=n.getCreatedAt() != null ? n.getCreatedAt() : ""%></span>
                    </div>
                    <div class="notice-title"><%=n.getTitle()%></div>
                    <div class="notice-content"><%=n.getContent()%></div>
                    <div style="margin-top:16px;padding-top:12px;border-top:1px solid rgba(255,255,255,0.06);font-size:0.82rem;color:var(--text-muted);display:flex;align-items:center;gap:8px;">
                        <i class="fa-solid fa-user-shield" style="color:var(--gold);"></i> Posted by: <strong style="color:var(--text-secondary);"><%=n.getPostedBy()%></strong>
                    </div>
                </div>
                <% } } else { %>
                <div class="glass-card" style="text-align:center;padding:60px 20px;color:var(--text-muted);">
                    <i class="fa-solid fa-bullhorn" style="font-size:3.5rem;display:block;margin-bottom:16px;color:var(--gold);opacity:0.3;"></i>
                    No announcements posted yet.
                </div>
                <% } %>
            </div>
        </main>
    </div>
</body>
</html>
