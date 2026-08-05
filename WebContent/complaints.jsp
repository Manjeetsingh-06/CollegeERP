<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User, model.Complaint, java.util.List" %>
<%
    User loggedUser = (User) session.getAttribute("loggedUser");
    if (loggedUser == null) { response.sendRedirect("login.jsp"); return; }
    String userRole = loggedUser.getRole();
    List<Complaint> complaintList = (List<Complaint>) request.getAttribute("complaintList");
    String msg = request.getParameter("msg");
    boolean isAdmin = "ADMIN".equals(userRole) || "FACULTY".equals(userRole);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Complaints & Help - University of Lucknow ERP</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="css/style.css?v=6.0">
    <style>
        .complaint-card {
            background: var(--bg-card);
            border: 1px solid var(--border-glass);
            border-radius: 16px;
            padding: 20px 24px;
            margin-bottom: 16px;
            transition: var(--transition);
        }
        .complaint-card.pending { border-left: 4px solid var(--gold); }
        .complaint-card.resolved { border-left: 4px solid var(--success); }
        .complaint-card:hover { border-color: var(--border-gold); }
        .badge-pending { background:rgba(251,191,36,0.18);color:#fbbf24;border:1px solid rgba(251,191,36,0.3);padding:4px 12px;border-radius:20px;font-size:0.75rem;font-weight:700; }
        .badge-resolved { background:rgba(16,185,129,0.18);color:#34d399;border:1px solid rgba(16,185,129,0.3);padding:4px 12px;border-radius:20px;font-size:0.75rem;font-weight:700; }
        .resolve-form { background:rgba(255,255,255,0.03); border:1px solid var(--border-glass); border-radius:12px; padding:16px; margin-top:14px; display:none; }
        .resolve-form.open { display:block; }
        .submit-panel { background:linear-gradient(135deg,rgba(251,191,36,0.08),rgba(99,102,241,0.08)); border:1px solid var(--border-gold); border-radius:18px; padding:24px; margin-bottom:26px; }
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
                    <h2><i class="fa-solid fa-comments" style="color:var(--gold-light);margin-right:10px;"></i>Grievance & Help Desk</h2>
                    <p>Submit complaints and track resolution status.</p>
                </div>
            </header>

            <% if(msg != null) { %><div class="alert alert-success"><i class="fa-solid fa-circle-check"></i> <span><%=msg%></span></div><% } %>

            <!-- Submit Complaint Panel -->
            <div class="submit-panel">
                <h3 style="font-size:1rem;font-weight:700;color:var(--text-primary);margin-bottom:16px;">
                    <i class="fa-solid fa-plus-circle" style="color:var(--gold);margin-right:8px;"></i>Submit a Complaint / Grievance
                </h3>
                <form action="complaints" method="post">
                    <input type="hidden" name="action" value="submit">
                    <div style="display:grid;grid-template-columns:1fr 2fr auto;gap:14px;align-items:flex-end;">
                        <div class="form-group" style="margin:0;">
                            <label class="form-label">Subject / Topic</label>
                            <input type="text" name="subjectTitle" class="form-control" placeholder="e.g., Fee query, Class issue..." required style="padding-left:14px;">
                        </div>
                        <div class="form-group" style="margin:0;">
                            <label class="form-label">Description</label>
                            <input type="text" name="description" class="form-control" placeholder="Describe issue in detail..." required style="padding-left:14px;">
                        </div>
                        <button type="submit" class="btn-primary" style="width:auto;padding:12px 24px;margin:0 0 1px;">
                            <i class="fa-solid fa-paper-plane"></i> Submit Ticket
                        </button>
                    </div>
                </form>
            </div>

            <!-- Complaint List -->
            <div class="glass-card" style="padding:0;">
                <div style="padding:20px 24px;border-bottom:1px solid var(--border-glass);display:flex;justify-content:space-between;align-items:center;">
                    <h3 style="font-size:1.05rem;font-weight:700;color:var(--text-primary);">
                        <% if(isAdmin) { %>All Student Grievances<% } else { %>My Submitted Tickets<% } %>
                    </h3>
                    <span class="badge-gold"><%=complaintList != null ? complaintList.size() : 0%> Records</span>
                </div>
                <div style="padding:20px;">
                    <% if(complaintList != null && !complaintList.isEmpty()) {
                        for(Complaint c : complaintList) {
                            boolean pending = "PENDING".equals(c.getStatus());
                    %>
                    <div class="complaint-card <%=pending ? "pending" : "resolved"%>">
                        <div style="display:flex;justify-content:space-between;align-items:flex-start;flex-wrap:wrap;gap:8px;">
                            <div>
                                <% if(isAdmin) { %>
                                <small style="color:var(--text-muted);display:block;margin-bottom:4px;">
                                    <i class="fa-solid fa-user" style="color:var(--gold);"></i>
                                    <%=c.getStudentName() != null ? c.getStudentName() : "Student"%>
                                    <% if(c.getRollNumber() != null) { %>(<%=c.getRollNumber()%>)<% } %>
                                </small>
                                <% } %>
                                <strong style="color:var(--text-primary);font-size:1rem;"><%=c.getSubjectTitle()%></strong>
                            </div>
                            <div style="display:flex;align-items:center;gap:10px;">
                                <span style="font-size:0.77rem;color:var(--text-muted);"><%=c.getCreatedAt() != null ? c.getCreatedAt().toString().substring(0,10) : ""%></span>
                                <% if(pending) { %>
                                    <span class="badge-pending"><i class="fa-solid fa-clock"></i> Pending</span>
                                <% } else { %>
                                    <span class="badge-resolved"><i class="fa-solid fa-check-circle"></i> Resolved</span>
                                <% } %>
                            </div>
                        </div>
                        <p style="color:var(--text-secondary);margin:12px 0 0;font-size:0.9rem;line-height:1.65;"><%=c.getDescription()%></p>

                        <% if(!pending && c.getAdminResponse() != null) { %>
                        <div style="background:rgba(16,185,129,0.08);border:1px solid rgba(16,185,129,0.25);border-radius:10px;padding:12px 16px;margin-top:14px;">
                            <small style="color:#34d399;font-weight:700;"><i class="fa-solid fa-reply"></i> Resolution Response:</small>
                            <p style="color:var(--text-secondary);margin:4px 0 0;font-size:0.88rem;"><%=c.getAdminResponse()%></p>
                        </div>
                        <% } %>

                        <% if(isAdmin && pending) { %>
                        <div style="margin-top:14px;">
                            <button onclick="toggleResolve('rf_<%=c.getId()%>')" class="btn-demo" style="padding:8px 16px;">
                                <i class="fa-solid fa-check"></i> Respond / Resolve Ticket
                            </button>
                            <form action="complaints" method="post" id="rf_<%=c.getId()%>" class="resolve-form">
                                <input type="hidden" name="action" value="resolve">
                                <input type="hidden" name="id" value="<%=c.getId()%>">
                                <div class="form-group" style="margin-bottom:12px;">
                                    <label class="form-label">Resolution Note</label>
                                    <textarea name="adminResponse" class="form-control" rows="2" placeholder="Write response details..." required style="padding-left:14px;"></textarea>
                                </div>
                                <button type="submit" class="btn-primary" style="width:auto;padding:10px 22px;">
                                    <i class="fa-solid fa-check-circle"></i> Mark as Resolved
                                </button>
                            </form>
                        </div>
                        <% } %>
                    </div>
                    <% } } else { %>
                    <div style="text-align:center;padding:50px 20px;color:var(--text-muted);">
                        <i class="fa-solid fa-comments" style="font-size:3rem;display:block;margin-bottom:14px;opacity:0.25;"></i>
                        No complaints logged.
                    </div>
                    <% } %>
                </div>
            </div>
        </main>
    </div>
    <script>
    function toggleResolve(id) {
        const el = document.getElementById(id);
        el.classList.toggle('open');
    }
    </script>
</body>
</html>
