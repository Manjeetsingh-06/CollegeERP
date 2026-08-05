<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User, model.Timetable, model.Department, model.Subject, java.util.List, java.util.LinkedHashMap, java.util.LinkedHashSet" %>
<%
    User loggedUser = (User) session.getAttribute("loggedUser");
    if (loggedUser == null) { response.sendRedirect("login.jsp"); return; }
    String userRole = loggedUser.getRole();
    List<Department> deptList = (List<Department>) request.getAttribute("deptList");
    List<Subject> subjectList = (List<Subject>) request.getAttribute("subjectList");
    List<Timetable> timetableList = (List<Timetable>) request.getAttribute("timetableList");
    Integer selectedDeptId = (Integer) request.getAttribute("selectedDeptId");
    Integer selectedSem = (Integer) request.getAttribute("selectedSem");
    String msg = request.getParameter("msg");
    String[] days = {"Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"};
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Timetable - University of Lucknow ERP</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="css/style.css?v=6.0">
    <style>
        .tt-filter { display:flex; gap:14px; align-items:flex-end; flex-wrap:wrap; margin-bottom:20px; }
        .tt-grid { display:grid; grid-template-columns:110px repeat(6,1fr); border:1px solid var(--border-glass); border-radius:14px; min-width:720px; overflow:hidden; }
        .tt-head { background:rgba(251,191,36,0.18); padding:12px; text-align:center; font-weight:700; font-size:0.82rem; color:var(--gold-light); border-bottom:1px solid var(--border-glass); }
        .tt-timecell { background:rgba(255,255,255,0.03); padding:10px; text-align:center; font-size:0.75rem; color:var(--text-muted); font-weight:700; border-bottom:1px solid rgba(255,255,255,0.04); display:flex;align-items:center;justify-content:center; }
        .tt-cell { background:rgba(255,255,255,0.02); padding:6px; border-left:1px solid rgba(255,255,255,0.05); border-bottom:1px solid rgba(255,255,255,0.04); min-height:64px; display:flex;align-items:center;justify-content:center; }
        .slot-box { background:linear-gradient(135deg,rgba(251,191,36,0.15),rgba(99,102,241,0.15)); border:1px solid rgba(251,191,36,0.3); border-radius:10px; padding:8px 10px; font-size:0.78rem; text-align:center; width:100%; }
        .slot-code { font-weight:800; color:var(--gold-light); }
        .slot-name { color:var(--text-secondary); font-size:0.7rem; }
        .slot-room { color:var(--text-muted); font-size:0.68rem; margin-top:2px; }
        .add-panel { background:linear-gradient(135deg,rgba(251,191,36,0.08),rgba(99,102,241,0.08)); border:1px solid var(--border-gold); border-radius:16px; padding:22px; margin-bottom:24px; }
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
                    <h2><i class="fa-solid fa-calendar-week" style="color:var(--gold-light);margin-right:10px;"></i>Timetable Schedule</h2>
                    <p>Weekly class schedule management.</p>
                </div>
            </header>

            <% if(msg != null) { %><div class="alert alert-success"><i class="fa-solid fa-circle-check"></i> <span><%=msg%></span></div><% } %>

            <!-- Filter -->
            <form method="get" action="timetable" class="tt-filter">
                <div class="form-group" style="margin:0;">
                    <label class="form-label">Department</label>
                    <select name="deptId" class="form-control" style="min-width:180px;padding-left:14px;">
                        <option value="">-- Select Department --</option>
                        <% if(deptList != null) { for(Department d : deptList) { %>
                        <option value="<%=d.getId()%>" <%=selectedDeptId != null && selectedDeptId == d.getId() ? "selected" : ""%>><%=d.getDeptName()%></option>
                        <% } } %>
                    </select>
                </div>
                <div class="form-group" style="margin:0;">
                    <label class="form-label">Semester</label>
                    <select name="semester" class="form-control" style="padding-left:14px;">
                        <% for(int i=1;i<=8;i++) { %>
                        <option value="<%=i%>" <%=selectedSem != null && selectedSem == i ? "selected" : ""%>>Semester <%=i%></option>
                        <% } %>
                    </select>
                </div>
                <button type="submit" class="btn-primary" style="width:auto;padding:10px 22px;margin:0 0 1px;">
                    <i class="fa-solid fa-magnifying-glass"></i> View Schedule
                </button>
            </form>

            <!-- Add Entry Panel (ADMIN ONLY) -->
            <% if("ADMIN".equals(userRole)) { %>
            <div class="add-panel">
                <h3 style="font-size:0.95rem;font-weight:700;color:var(--text-primary);margin-bottom:16px;">
                    <i class="fa-solid fa-plus-circle" style="color:var(--gold);margin-right:8px;"></i>Add Schedule Entry (Admin Only)
                </h3>
                <form action="timetable" method="post">
                    <div style="display:grid;grid-template-columns:repeat(auto-fit,minmax(140px,1fr));gap:12px;align-items:flex-end;">
                        <div class="form-group" style="margin:0;">
                            <label class="form-label">Department</label>
                            <select name="deptId" class="form-control" style="padding-left:12px;" required>
                                <% if(deptList != null) { for(Department d : deptList) { %>
                                <option value="<%=d.getId()%>"><%=d.getDeptName()%></option>
                                <% } } %>
                            </select>
                        </div>
                        <div class="form-group" style="margin:0;">
                            <label class="form-label">Semester</label>
                            <select name="semester" class="form-control" style="padding-left:12px;" required>
                                <% for(int i=1;i<=8;i++) { %><option value="<%=i%>">Sem <%=i%></option><% } %>
                            </select>
                        </div>
                        <div class="form-group" style="margin:0;">
                            <label class="form-label">Day</label>
                            <select name="dayOfWeek" class="form-control" style="padding-left:12px;" required>
                                <% for(String d : days) { %><option><%=d%></option><% } %>
                            </select>
                        </div>
                        <div class="form-group" style="margin:0;">
                            <label class="form-label">Subject</label>
                            <select name="subjectId" class="form-control" style="padding-left:12px;" required>
                                <% if(subjectList != null) { for(Subject s : subjectList) { %>
                                <option value="<%=s.getId()%>"><%=s.getSubjectCode()%></option>
                                <% } } %>
                            </select>
                        </div>
                        <div class="form-group" style="margin:0;">
                            <label class="form-label">Time Slot</label>
                            <select name="timeSlot" class="form-control" style="padding-left:12px;" required>
                                <option>09:00 - 10:00</option><option>10:00 - 11:00</option>
                                <option>11:00 - 12:00</option><option>12:00 - 13:00</option>
                                <option>14:00 - 15:00</option><option>15:00 - 16:00</option>
                                <option>16:00 - 17:00</option>
                            </select>
                        </div>
                        <div class="form-group" style="margin:0;">
                            <label class="form-label">Room No.</label>
                            <input type="text" name="roomNo" class="form-control" placeholder="A-101" required style="padding-left:12px;">
                        </div>
                        <button type="submit" class="btn-primary" style="width:auto;padding:10px 20px;margin:0 0 1px;">
                            <i class="fa-solid fa-plus"></i> Add Entry
                        </button>
                    </div>
                </form>
            </div>
            <% } %>

            <!-- Timetable Grid -->
            <% if(timetableList != null && !timetableList.isEmpty()) {
                LinkedHashMap<String, LinkedHashMap<String, Timetable>> schedule = new LinkedHashMap<>();
                LinkedHashSet<String> timeSlots = new LinkedHashSet<>();
                for(String d : days) schedule.put(d, new LinkedHashMap<>());
                for(Timetable t : timetableList) {
                    timeSlots.add(t.getTimeSlot());
                    if(schedule.containsKey(t.getDayOfWeek()))
                        schedule.get(t.getDayOfWeek()).put(t.getTimeSlot(), t);
                }
            %>
            <div class="glass-card" style="padding:0;">
                <div style="padding:18px 22px;border-bottom:1px solid var(--border-glass);">
                    <h3 style="font-size:1rem;font-weight:700;color:var(--text-primary);">
                        <i class="fa-solid fa-table" style="color:var(--gold);margin-right:8px;"></i>Weekly Schedule Grid
                    </h3>
                </div>
                <div style="padding:16px;overflow-x:auto;">
                    <div class="tt-grid">
                        <div class="tt-head">Time</div>
                        <% for(String d : days) { %><div class="tt-head"><%=d%></div><% } %>

                        <% for(String slot : timeSlots) { %>
                        <div class="tt-timecell"><%=slot%></div>
                        <% for(String d : days) {
                            Timetable entry = schedule.get(d).get(slot);
                        %>
                        <div class="tt-cell">
                            <% if(entry != null) { %>
                            <div class="slot-box">
                                <div class="slot-code"><%=entry.getSubjectCode() != null ? entry.getSubjectCode() : ""%></div>
                                <div class="slot-name"><%=entry.getSubjectName() != null ? entry.getSubjectName() : ""%></div>
                                <div class="slot-room"><i class="fa-solid fa-door-open"></i> <%=entry.getRoomNo()%></div>
                                <% if("ADMIN".equals(userRole)) { %>
                                <a href="timetable?action=delete&id=<%=entry.getId()%>"
                                   onclick="return confirm('Delete this entry?')"
                                   style="font-size:0.65rem;color:#ef4444;display:block;margin-top:4px;text-decoration:none;">
                                    <i class="fa-solid fa-trash"></i> Remove
                                </a>
                                <% } %>
                            </div>
                            <% } %>
                        </div>
                        <% } %>
                        <% } %>
                    </div>
                </div>
            </div>
            <% } else if(selectedDeptId != null) { %>
            <div style="text-align:center;padding:60px 20px;color:var(--text-muted);">
                <i class="fa-solid fa-calendar-xmark" style="font-size:3rem;display:block;margin-bottom:14px;opacity:0.25;"></i>
                No schedule entries found.
            </div>
            <% } else { %>
            <div style="text-align:center;padding:60px 20px;color:var(--text-muted);">
                <i class="fa-solid fa-calendar-week" style="font-size:3rem;display:block;margin-bottom:14px;opacity:0.25;"></i>
                Select a Department and Semester above to view the timetable.
            </div>
            <% } %>
        </main>
    </div>
</body>
</html>
