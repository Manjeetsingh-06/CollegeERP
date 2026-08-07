<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Marks" %>
<%@ page import="model.Student" %>
<%@ page import="model.User" %>
<%
    User loggedUser = (User) session.getAttribute("loggedUser");
    if (loggedUser == null) { response.sendRedirect("login.jsp"); return; }
    List<Student> studentList = (List<Student>) request.getAttribute("studentList");
    Student selectedStudent = (Student) request.getAttribute("selectedStudent");
    List<Marks> marksheetList = (List<Marks>) request.getAttribute("marksheetList");
    Double totalObtained = (Double) request.getAttribute("totalObtained");
    Double totalMax = (Double) request.getAttribute("totalMax");
    Double overallPercentage = (Double) request.getAttribute("overallPercentage");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Official Academic Marksheet - University of Lucknow</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="css/style.css?v=6.0">
    <style>
        .print-only { display: none; }

        @media print {
            @page { margin: 12mm 15mm; size: A4 portrait; }

            html, body {
                background: #ffffff !important;
                color: #000000 !important;
                font-family: 'Times New Roman', Times, serif !important;
                margin: 0 !important; padding: 0 !important;
                overflow: visible !important;
            }

            .sidebar, .sidebar-overlay, .bg-glow-1, .bg-glow-2,
            .top-navbar, .no-print, .mobile-toggle-btn,
            .mobile-close-btn, #aiChatbotTrigger, #aiChatbotWidget,
            .chatbot-flag-bubble { display: none !important; }

            .app-container, .glass-container { display: block !important; border: none !important; box-shadow: none !important; }
            .main-content { width: 100% !important; padding: 0 !important; margin: 0 !important; }

            .glass-card {
                background: #ffffff !important;
                border: 3px double #000000 !important;
                border-radius: 0 !important;
                box-shadow: none !important;
                padding: 24px !important;
                color: #000000 !important;
                margin-bottom: 0 !important;
            }

            .print-only { display: block !important; }
            .screen-only { display: none !important; }

            /* OFFICIAL UNIVERSITY PRINT HEADER */
            .print-header {
                text-align: center;
                border-bottom: 2px solid #000;
                padding-bottom: 12px;
                margin-bottom: 16px;
            }
            .print-header .univ-title {
                font-size: 22pt;
                font-weight: bold;
                text-transform: uppercase;
                letter-spacing: 1.5px;
                color: #000;
                font-family: 'Times New Roman', serif;
            }
            .print-header .univ-sub {
                font-size: 11pt;
                font-weight: bold;
                color: #222;
                margin-top: 2px;
            }
            .print-header .doc-title-badge {
                font-size: 13pt;
                font-weight: bold;
                text-transform: uppercase;
                margin-top: 10px;
                border: 2px solid #000;
                display: inline-block;
                padding: 4px 28px;
                letter-spacing: 2px;
                background: #f8f8f8 !important;
            }

            /* STUDENT METADATA GRID FOR PRINT */
            .info-print-grid {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 6px 20px;
                border: 1px solid #000;
                padding: 10px 14px;
                margin-bottom: 16px;
                font-size: 10.5pt;
                background: #fbfbfb !important;
            }
            .info-print-grid p {
                color: #000 !important;
                margin: 2px 0;
            }
            .info-print-grid strong { color: #000 !important; }

            /* MARKS TABLE PRINT STYLING */
            .data-table, table {
                width: 100% !important;
                border-collapse: collapse !important;
                margin-top: 12px !important;
                font-family: 'Times New Roman', serif !important;
            }
            .data-table th, table th {
                background: #e5e5e5 !important;
                color: #000000 !important;
                border: 1.5px solid #000 !important;
                padding: 7px 8px !important;
                font-size: 9.5pt !important;
                font-weight: bold !important;
                text-align: center !important;
                word-break: normal !important;
                white-space: nowrap !important;
            }
            .data-table td, table td {
                border: 1px solid #000 !important;
                padding: 6px 8px !important;
                font-size: 9.5pt !important;
                color: #000000 !important;
                vertical-align: middle !important;
                word-break: break-word !important;
            }
            .data-table tr { page-break-inside: avoid; }
            .badge-gold {
                background: none !important;
                border: 1.5px solid #000 !important;
                color: #000 !important;
                padding: 2px 6px !important;
                font-size: 9pt !important;
                font-weight: bold !important;
                display: inline-block !important;
                white-space: nowrap !important;
            }

            /* PRINT SUMMARY & SIGNATURES */
            .summary-bar-print {
                display: flex;
                justify-content: space-between;
                border: 2px solid #000;
                padding: 10px 16px;
                margin-top: 16px;
                background: #f5f5f5 !important;
                font-size: 11pt;
            }
            .summary-bar-print strong { font-weight: bold; font-size: 12pt; }

            .signature-row {
                display: flex !important;
                justify-content: space-between;
                margin-top: 50px;
                font-size: 10pt;
                font-weight: bold;
            }
            .signature-row div {
                text-align: center;
                width: 180px;
                border-top: 1.5px solid #000;
                padding-top: 6px;
            }
            .print-footer-note {
                margin-top: 24px;
                text-align: center;
                font-size: 8.5pt;
                color: #444;
                border-top: 1px dashed #999;
                padding-top: 6px;
            }
        }
    </style>
</head>
<body>
    <div class="bg-glow-1"></div>
    <div class="bg-glow-2"></div>
    <div class="app-container glass-container">
        
        <%@ include file="sidebar.jsp" %>

        <main class="main-content">
            <!-- ======= SCREEN TOP NAV ======= -->
            <header class="top-navbar no-print">
                <button type="button" class="mobile-toggle-btn" id="mobileMenuToggle"><i class="fa-solid fa-bars"></i></button>
                <div class="welcome-title">
                    <h2>🎓 Academic Marksheet Transcript</h2>
                    <p>Generate and print official semester marksheets for any student.</p>
                </div>
                <% if (selectedStudent != null) { %>
                <div class="no-print" style="display:flex;gap:10px;align-items:center;flex-wrap:wrap;">
                    <!-- Orientation Toggle -->
                    <div style="display:flex;gap:6px;background:rgba(255,215,0,0.08);border:1px solid var(--gold-border);border-radius:8px;padding:4px;">
                        <button type="button" id="btnPortrait" onclick="setOrientation('portrait')" 
                            style="padding:6px 14px;border-radius:6px;font-size:12px;font-weight:700;border:none;cursor:pointer;background:var(--gold);color:#090d16;">
                            <i class="fa-solid fa-rectangle-portrait"></i> Portrait
                        </button>
                        <button type="button" id="btnLandscape" onclick="setOrientation('landscape')"
                            style="padding:6px 14px;border-radius:6px;font-size:12px;font-weight:700;border:none;cursor:pointer;background:transparent;color:var(--gold-light);">
                            <i class="fa-solid fa-rectangle-landscape"></i> Landscape
                        </button>
                    </div>
                    <button onclick="window.print()" class="btn-primary" style="width:auto;">
                        <i class="fa-solid fa-print"></i> Print Official Marksheet
                    </button>
                </div>
                <% } %>
            </header>

            <!-- ======= STUDENT SELECTOR ======= -->
            <div class="glass-card no-print" style="padding: 24px; margin-bottom: 24px;">
                <form action="marks" method="GET" style="display: flex; gap: 16px; align-items: flex-end; flex-wrap: wrap;">
                    <input type="hidden" name="action" value="marksheet">
                    <div class="form-group" style="flex: 1; margin: 0; min-width: 250px;">
                        <label>Select Student</label>
                        <select name="studentId" class="form-control" style="padding-left: 14px;" required>
                            <option value="">-- Choose Student --</option>
                            <% if (studentList != null) { for (Student s : studentList) { %>
                                <option value="<%= s.getId() %>" <%= selectedStudent != null && selectedStudent.getId() == s.getId() ? "selected" : "" %>>
                                    <%= s.getRollNumber() %> - <%= s.getFullName() %>
                                </option>
                            <% } } %>
                        </select>
                    </div>
                    <button type="submit" class="btn-primary" style="width: auto; padding: 13px 28px; margin: 0;">
                        <i class="fa-solid fa-magnifying-glass"></i> View Marksheet
                    </button>
                </form>
            </div>

            <!-- ======= MARKSHEET CARD ======= -->
            <% if (selectedStudent != null) { %>
            <div class="glass-card" style="padding: 32px; margin-bottom: 24px;" id="marksheetPrintArea">

                <!-- ---- PRINT HEADER ---- -->
                <div class="print-only print-header">
                    <div class="univ-title">University of Lucknow, Lucknow</div>
                    <div class="univ-sub">Lucknow, Uttar Pradesh — Established 1867</div>
                    <div class="doc-title-badge">Statement of Marks / Grade Card</div>
                </div>

                <!-- ---- SCREEN HEADER ---- -->
                <div class="screen-only" style="text-align: center; margin-bottom: 24px; border-bottom: 2px solid var(--gold-border); padding-bottom: 16px;">
                    <i class="fa-solid fa-university" style="font-size: 2.5rem; color: var(--gold); display: block; margin-bottom: 8px;"></i>
                    <h2 style="font-family: 'Outfit', sans-serif; font-size: 1.8rem; font-weight: 800; color: #ffffff; margin-bottom: 6px;">UNIVERSITY OF LUCKNOW, LUCKNOW</h2>
                    <p style="color: var(--gold-light); font-size: 0.95rem; font-weight: 700; letter-spacing: 1px;">OFFICIAL ACADEMIC TRANSCRIPT / GRADE CARD</p>
                </div>

                <!-- ---- PRINT STUDENT METADATA ---- -->
                <div class="print-only info-print-grid">
                    <p>Student Name: <strong><%= selectedStudent.getFullName() %></strong></p>
                    <p>Roll Number: <strong><%= selectedStudent.getRollNumber() %></strong></p>
                    <p>Department: <strong><%= selectedStudent.getDeptName() %></strong></p>
                    <p>Semester: <strong>Semester <%= selectedStudent.getSemester() %></strong></p>
                    <p>Examination Session: <strong>Academic Year 2025-2026</strong></p>
                    <p>Date of Issue: <strong><%= java.time.LocalDate.now() %></strong></p>
                </div>

                <!-- ---- SCREEN STUDENT METADATA ---- -->
                <div class="screen-only" style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px; margin-bottom: 24px; font-size: 0.95rem;">
                    <div>
                        <p style="color: var(--text-muted);">Student Name: <strong style="color: #ffffff;"><%= selectedStudent.getFullName() %></strong></p>
                        <p style="color: var(--text-muted); margin-top: 6px;">Roll Number: <strong style="color: var(--gold-light);"><%= selectedStudent.getRollNumber() %></strong></p>
                        <p style="color: var(--text-muted); margin-top: 6px;">Email: <strong style="color: #ffffff;"><%= selectedStudent.getEmail() != null ? selectedStudent.getEmail() : "—" %></strong></p>
                    </div>
                    <div style="text-align: right;">
                        <p style="color: var(--text-muted);">Department: <strong style="color: #ffffff;"><%= selectedStudent.getDeptName() %></strong></p>
                        <p style="color: var(--text-muted); margin-top: 6px;">Semester: <strong style="color: var(--gold-light);">Semester <%= selectedStudent.getSemester() %></strong></p>
                        <p style="color: var(--text-muted); margin-top: 6px;">Issue Date: <strong style="color: #ffffff;"><%= java.time.LocalDate.now() %></strong></p>
                    </div>
                </div>

                <!-- ---- MARKS TABLE ---- -->
                <div class="table-responsive">
                <table class="data-table">
                    <colgroup>
                        <col style="width:13%;">
                        <col style="width:34%;">
                        <col style="width:15%;">
                        <col style="width:12%;">
                        <col style="width:12%;">
                        <col style="width:14%;">
                    </colgroup>
                    <thead>
                        <tr>
                            <th>Sub. Code</th>
                            <th style="text-align: left;">Subject Name</th>
                            <th>Exam Type</th>
                            <th>Max Marks</th>
                            <th>Obtained</th>
                            <th>Grade</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                            if (marksheetList != null && !marksheetList.isEmpty()) {
                                for (Marks m : marksheetList) {
                        %>
                            <tr>
                                <td style="font-weight: 800; color: var(--gold-light); text-align: center;"><%= m.getSubjectCode() %></td>
                                <td style="font-weight: 600;"><%= m.getSubjectName() %></td>
                                <td style="text-align: center;"><%= m.getExamType() != null ? m.getExamType() : "—" %></td>
                                <td style="text-align: center;"><%= String.format("%.1f", m.getMaxMarks()) %></td>
                                <td style="font-weight: 700; text-align: center;"><%= String.format("%.1f", m.getMarksObtained()) %></td>
                                <td style="text-align: center;"><span class="badge-gold"><%= m.getGrade() %></span></td>
                            </tr>
                        <% 
                                }
                            } else {
                        %>
                            <tr>
                                <td colspan="6" style="padding: 30px; text-align: center; color: var(--text-muted);">
                                    No marks recorded for this student yet.
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
                </div>

                <!-- ---- SUMMARY BAR (Screen) ---- -->
                <% if (overallPercentage != null) { %>
                <div class="screen-only" style="display: flex; justify-content: space-between; align-items: center; background: rgba(255,215,0,0.1); border: 1px solid var(--gold); padding: 18px 24px; border-radius: var(--radius-md); margin-top: 20px; flex-wrap: wrap; gap: 12px;">
                    <div>
                        <span style="font-size: 1rem; color: var(--text-secondary);">Overall Score: </span>
                        <strong style="font-size: 1.2rem; color: #ffffff;"><%= totalObtained != null ? String.format("%.1f", totalObtained) : "0" %> / <%= totalMax != null ? String.format("%.1f", totalMax) : "0" %> Marks</strong>
                    </div>
                    <div>
                        <span style="font-size: 1rem; color: var(--text-secondary);">Cumulative Percentage: </span>
                        <strong style="font-size: 1.5rem; color: var(--gold-light); font-weight: 800;"><%= String.format("%.2f", overallPercentage) %>%</strong>
                    </div>
                </div>

                <!-- ---- SUMMARY BAR (Print) ---- -->
                <div class="print-only summary-bar-print">
                    <div>
                        Total Score: <strong><%= totalObtained != null ? String.format("%.1f", totalObtained) : "0" %> / <%= totalMax != null ? String.format("%.1f", totalMax) : "0" %> Marks</strong>
                    </div>
                    <div>
                        Cumulative Percentage: <strong><%= String.format("%.2f", overallPercentage) %>%</strong>
                    </div>
                    <div>
                        Result Status: <strong><%= overallPercentage >= 50.0 ? "PASSED (FIRST DIVISION)" : "FAILED" %></strong>
                    </div>
                </div>

                <!-- ---- SIGNATURE ROW (Print) ---- -->
                <div class="print-only signature-row">
                    <div>Prepared &amp; Verified By</div>
                    <div>Checked By (HOD)</div>
                    <div>Controller of Examinations</div>
                </div>

                <div class="print-only print-footer-note">
                    Official Computer Generated Transcript • University of Lucknow • Valid without physical seal if verified online.
                </div>
                <% } %>
            </div>
            <% } %>
        </main>
    </div>

    <script src="js/main.js"></script>
    <script>
        // Dynamic Print Orientation Toggle
        var currentOrientation = 'portrait';
        var dynamicStyle = document.createElement('style');
        dynamicStyle.id = 'printOrientationStyle';
        dynamicStyle.innerHTML = '@page { size: A4 portrait; margin: 12mm 15mm; }';
        document.head.appendChild(dynamicStyle);

        function setOrientation(mode) {
            currentOrientation = mode;
            var margin = (mode === 'landscape') ? '10mm 12mm' : '12mm 15mm';
            document.getElementById('printOrientationStyle').innerHTML =
                '@page { size: A4 ' + mode + '; margin: ' + margin + '; }';

            // Update button styles
            document.getElementById('btnPortrait').style.background   = (mode === 'portrait')  ? 'var(--gold)' : 'transparent';
            document.getElementById('btnPortrait').style.color        = (mode === 'portrait')  ? '#090d16' : 'var(--gold-light)';
            document.getElementById('btnLandscape').style.background  = (mode === 'landscape') ? 'var(--gold)' : 'transparent';
            document.getElementById('btnLandscape').style.color       = (mode === 'landscape') ? '#090d16' : 'var(--gold-light)';
        }
    </script>
</body>
</html>
