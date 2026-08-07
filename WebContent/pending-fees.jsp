<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="model.User" %>
<%
    User loggedUser = (User) session.getAttribute("loggedUser");
    if (loggedUser == null) { response.sendRedirect("login.jsp"); return; }
    List<Map<String, Object>> pendingList = (List<Map<String, Object>>) request.getAttribute("pendingList");

    int totalStudents = (pendingList != null) ? pendingList.size() : 0;
    int paidCount = 0;
    int pendingCount = 0;
    double totalCollected = 0.0;
    double totalPendingAmt = 0.0;

    if (pendingList != null) {
        for (Map<String, Object> row : pendingList) {
            double pending = (double) row.get("pendingBalance");
            double paid = row.get("totalPaid") != null ? (double) row.get("totalPaid") : 0.0;
            totalCollected += paid;
            if (pending <= 0 && paid > 0) {
                paidCount++;
            } else {
                pendingCount++;
                totalPendingAmt += pending;
            }
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Fee Status & Ledger - University of Lucknow</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="css/style.css?v=6.0">
    <style>
        .print-only { display: none; }

        @media print {
            @page { margin: 10mm 12mm; size: A4 landscape; }

            html, body {
                background: #ffffff !important;
                color: #000000 !important;
                font-family: 'Times New Roman', Times, serif !important;
                margin: 0 !important; padding: 0 !important;
                overflow: visible !important;
            }

            .sidebar, .sidebar-overlay, .bg-glow-1, .bg-glow-2,
            .top-navbar, .no-print, .mobile-toggle-btn,
            .stats-grid, #aiChatbotTrigger, #aiChatbotWidget,
            .chatbot-flag-bubble { display: none !important; }

            .app-container, .glass-container { display: block !important; border: none !important; box-shadow: none !important; }
            .main-content { width: 100% !important; padding: 0 !important; margin: 0 !important; }

            .glass-card {
                background: #ffffff !important;
                border: 2px solid #000000 !important;
                border-radius: 0 !important;
                box-shadow: none !important;
                padding: 16px !important;
                color: #000000 !important;
                margin-bottom: 0 !important;
            }

            .print-only { display: block !important; }

            .print-header {
                text-align: center;
                border-bottom: 2px solid #000;
                padding-bottom: 10px;
                margin-bottom: 12px;
            }
            .print-header .univ-name { font-size: 20pt; font-weight: bold; text-transform: uppercase; color: #000; font-family: 'Times New Roman', serif; }
            .print-header .univ-sub { font-size: 10pt; font-weight: bold; color: #222; margin-top: 2px; }
            .print-header .doc-title { font-size: 12.5pt; font-weight: bold; text-transform: uppercase; margin-top: 6px; border: 2px solid #000; display: inline-block; padding: 3px 20px; letter-spacing: 1.5px; background: #f8f8f8 !important; }

            .print-summary-bar {
                display: flex !important;
                justify-content: space-between;
                border: 1px solid #000;
                padding: 8px 12px;
                margin-bottom: 12px;
                font-size: 10pt;
                background: #f5f5f5 !important;
            }
            .print-summary-bar div { color: #000 !important; }

            .data-table, table { width: 100% !important; border-collapse: collapse !important; font-family: 'Times New Roman', serif !important; }
            .data-table th, table th {
                background: #e5e5e5 !important; color: #000 !important;
                border: 1.5px solid #000 !important;
                padding: 7px 8px !important; font-size: 9.5pt !important; font-weight: bold !important;
                text-align: center !important;
            }
            .data-table td, table td {
                border: 1px solid #000 !important; color: #000 !important;
                padding: 6px 8px !important; font-size: 9pt !important;
            }
            .data-table tr { page-break-inside: avoid; }
            .badge-gold, .badge-violet { background: none !important; border: 1px solid #000 !important; color: #000 !important; padding: 1px 6px !important; font-size: 8pt !important; font-weight: bold !important; }
            
            .print-footer-signatures {
                display: flex !important;
                justify-content: space-between;
                margin-top: 40px;
                font-size: 9.5pt;
                font-weight: bold;
            }
            .print-footer-signatures div {
                text-align: center;
                width: 170px;
                border-top: 1.5px solid #000;
                padding-top: 4px;
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
            <header class="top-navbar no-print">
                <button type="button" class="mobile-toggle-btn" id="mobileMenuToggle"><i class="fa-solid fa-bars"></i></button>
                <div class="welcome-title">
                    <h2>💰 Master Student Fee Ledger</h2>
                    <p>Complete status report of students who have submitted fees vs pending dues.</p>
                </div>
                <div style="display:flex;gap:10px;flex-wrap:wrap;align-items:center;">
                    <!-- Orientation Toggle -->
                    <div style="display:flex;gap:6px;background:rgba(255,215,0,0.08);border:1px solid var(--gold-border);border-radius:8px;padding:4px;">
                        <button type="button" id="btnPortrait" onclick="setOrientation('portrait')"
                            style="padding:6px 14px;border-radius:6px;font-size:12px;font-weight:700;border:none;cursor:pointer;background:transparent;color:var(--gold-light);">
                            <i class="fa-solid fa-rectangle-portrait"></i> Portrait
                        </button>
                        <button type="button" id="btnLandscape" onclick="setOrientation('landscape')"
                            style="padding:6px 14px;border-radius:6px;font-size:12px;font-weight:700;border:none;cursor:pointer;background:var(--gold);color:#090d16;">
                            <i class="fa-solid fa-rectangle-landscape"></i> Landscape
                        </button>
                    </div>
                    <button onclick="window.print()" class="btn-primary" style="width:auto;">
                        <i class="fa-solid fa-print"></i> Print Official Ledger
                    </button>
                    <a href="fees?action=pay" class="btn-secondary" style="width:auto;text-decoration:none;">
                        <i class="fa-solid fa-credit-card"></i> Process Payment
                    </a>
                </div>
            </header>

            <!-- Printable Official Header (print only) -->
            <div class="print-only print-header">
                <div class="univ-name">University of Lucknow, Lucknow</div>
                <div class="univ-sub">FINANCE &amp; ACCOUNTS DIVISION • ESTABLISHED 1867</div>
                <div class="doc-title">Master Student Fee Balance &amp; Audit Ledger</div>
            </div>

            <div class="print-only print-summary-bar">
                <div>Date of Audit: <strong><%= java.time.LocalDate.now() %></strong></div>
                <div>Total Enrolled: <strong><%= totalStudents %> Students</strong></div>
                <div>Fee Cleared: <strong><%= paidCount %></strong></div>
                <div>Pending Dues: <strong><%= pendingCount %></strong></div>
                <div>Total Outstanding: <strong>₹<%= String.format("%.2f", totalPendingAmt) %></strong></div>
            </div>

            <!-- Summary Overview Cards (screen only) -->
            <section class="stats-grid no-print" style="margin-bottom: 24px;">
                <div class="glass-card stat-card">
                    <div class="stat-icon" style="background: rgba(255, 215, 0, 0.15); color: var(--gold);">
                        <i class="fa-solid fa-users"></i>
                    </div>
                    <div class="stat-value"><%= totalStudents %></div>
                    <div class="stat-label">Total Students</div>
                </div>

                <div class="glass-card stat-card">
                    <div class="stat-icon" style="background: rgba(16, 185, 129, 0.15); color: #34d399;">
                        <i class="fa-solid fa-circle-check"></i>
                    </div>
                    <div class="stat-value" style="color: #34d399;"><%= paidCount %></div>
                    <div class="stat-label">Fee Submitted (Paid)</div>
                </div>

                <div class="glass-card stat-card">
                    <div class="stat-icon" style="background: rgba(239, 68, 68, 0.15); color: #f87171;">
                        <i class="fa-solid fa-clock-rotate-left"></i>
                    </div>
                    <div class="stat-value" style="color: #f87171;"><%= pendingCount %></div>
                    <div class="stat-label">Fee Pending (Dues)</div>
                </div>

                <div class="glass-card stat-card">
                    <div class="stat-icon" style="background: rgba(99, 102, 241, 0.15); color: #a5b4fc;">
                        <i class="fa-solid fa-indian-rupee-sign"></i>
                    </div>
                    <div class="stat-value" style="font-size: 22px;">₹<%= String.format("%.2f", totalCollected) %></div>
                    <div class="stat-label">Total Collected Amount</div>
                </div>
            </section>

            <!-- Main Ledger Card -->
            <div class="glass-card" style="padding: 24px; overflow-x: auto;">
                
                <!-- Filter Tabs (screen only) -->
                <div class="no-print" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; flex-wrap: wrap; gap: 12px;">
                    <h3 style="font-size: 1.1rem; font-weight: 800; color: var(--text-primary);">
                        <i class="fa-solid fa-receipt" style="color: var(--gold); margin-right: 8px;"></i>Student Balance Ledger Directory
                    </h3>
                    
                    <div style="display: flex; gap: 8px;">
                        <button type="button" class="btn-demo active-filter" onclick="filterTable('all', this)">
                            <i class="fa-solid fa-list"></i> All (<%= totalStudents %>)
                        </button>
                        <button type="button" class="btn-demo" onclick="filterTable('paid', this)">
                            <i class="fa-solid fa-circle-check" style="color:#34d399;"></i> Fee Submitted (<%= paidCount %>)
                        </button>
                        <button type="button" class="btn-demo" onclick="filterTable('pending', this)">
                            <i class="fa-solid fa-circle-exclamation" style="color:#f87171;"></i> Fee Pending (<%= pendingCount %>)
                        </button>
                    </div>
                </div>

                <table class="data-table" id="feeLedgerTable">
                    <thead>
                        <tr>
                            <th>Roll Number</th>
                            <th style="text-align: left;">Student Name</th>
                            <th>Department</th>
                            <th>Semester</th>
                            <th style="text-align: right;">Total Fee (₹)</th>
                            <th style="text-align: right;">Paid (₹)</th>
                            <th style="text-align: right;">Pending (₹)</th>
                            <th>Status</th>
                            <th class="no-print">Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                            if (pendingList != null && !pendingList.isEmpty()) {
                                for (Map<String, Object> row : pendingList) {
                                    double pending = (double) row.get("pendingBalance");
                                    double paid = row.get("totalPaid") != null ? (double) row.get("totalPaid") : 0.0;
                                    boolean isSubmitted = (pending <= 0 && paid > 0);
                        %>
                            <tr class="ledger-row" data-status="<%= isSubmitted ? "paid" : "pending" %>">
                                <td style="font-weight: 800; color: var(--gold-light); text-align: center;"><%= row.get("rollNumber") %></td>
                                <td style="font-weight: 600;"><%= row.get("fullName") %></td>
                                <td style="text-align: center;"><span class="badge-violet"><%= row.get("deptName") %></span></td>
                                <td style="text-align: center;">Semester <%= row.get("semester") %></td>
                                <td style="text-align: right;">₹<%= String.format("%.2f", (double) row.get("totalFee")) %></td>
                                <td style="color: #34d399; font-weight: 700; text-align: right;">₹<%= String.format("%.2f", paid) %></td>
                                <td style="font-weight: 800; color: <%= isSubmitted ? "#34d399" : "#f87171" %>; text-align: right;">
                                    ₹<%= String.format("%.2f", pending) %>
                                </td>
                                <td style="text-align: center;">
                                    <% if (isSubmitted) { %>
                                        <span class="badge-gold" style="background: rgba(16, 185, 129, 0.2); color: #34d399; border-color: rgba(16, 185, 129, 0.4);">
                                            SUBMITTED
                                        </span>
                                    <% } else { %>
                                        <span class="badge-gold" style="background: rgba(239, 68, 68, 0.2); color: #f87171; border-color: rgba(239, 68, 68, 0.4);">
                                            PENDING
                                        </span>
                                    <% } %>
                                </td>
                                <td class="no-print" style="text-align: center;">
                                    <% if (!isSubmitted) { %>
                                        <a href="fees?action=pay&studentId=<%= row.get("studentId") %>" class="btn-demo" style="padding: 6px 12px; font-size: 12px; text-decoration: none;">
                                            <i class="fa-solid fa-credit-card"></i> Pay Now
                                        </a>
                                    <% } else { %>
                                        <span style="color: var(--text-muted); font-size: 12px;"><i class="fa-solid fa-shield-check"></i> Cleared</span>
                                    <% } %>
                                </td>
                            </tr>
                        <% 
                                }
                            } else {
                        %>
                            <tr>
                                <td colspan="9" style="padding: 40px; text-align: center; color: var(--text-muted);">
                                    No student fee records found in database.
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>

                <div class="print-only print-footer-signatures">
                    <div>Accounts Officer<br>Finance Dept.</div>
                    <div>Audited By<br>Internal Auditor</div>
                    <div>Approved By<br>Finance Officer — Lucknow Univ.</div>
                </div>

            </div>
        </main>
    </div>

    <script>
        function filterTable(type, btn) {
            const rows = document.querySelectorAll('.ledger-row');
            const btns = btn.parentElement.querySelectorAll('.btn-demo');
            btns.forEach(b => b.style.borderColor = 'var(--gold-border)');
            btn.style.borderColor = 'var(--gold)';

            rows.forEach(r => {
                if (type === 'all') {
                    r.style.display = '';
                } else if (type === 'paid') {
                    r.style.display = r.getAttribute('data-status') === 'paid' ? '' : 'none';
                } else if (type === 'pending') {
                    r.style.display = r.getAttribute('data-status') === 'pending' ? '' : 'none';
                }
            });
        }
    </script>
    <script>
        // Dynamic Print Orientation Toggle — Default: Landscape (for wide ledger)
        var dynamicStyle = document.createElement('style');
        dynamicStyle.id = 'printOrientationStyle';
        dynamicStyle.innerHTML = '@page { size: A4 landscape; margin: 10mm 12mm; }';
        document.head.appendChild(dynamicStyle);

        function setOrientation(mode) {
            var margin = (mode === 'landscape') ? '10mm 12mm' : '12mm 15mm';
            document.getElementById('printOrientationStyle').innerHTML =
                '@page { size: A4 ' + mode + '; margin: ' + margin + '; }';

            document.getElementById('btnPortrait').style.background  = (mode === 'portrait')  ? 'var(--gold)' : 'transparent';
            document.getElementById('btnPortrait').style.color       = (mode === 'portrait')  ? '#090d16' : 'var(--gold-light)';
            document.getElementById('btnLandscape').style.background = (mode === 'landscape') ? 'var(--gold)' : 'transparent';
            document.getElementById('btnLandscape').style.color      = (mode === 'landscape') ? '#090d16' : 'var(--gold-light)';
        }
    </script>
</body>
</html>
