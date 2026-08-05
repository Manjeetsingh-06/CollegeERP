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
    <title>Student Fee Status & Ledger - University of Lucknow ERP</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="css/style.css?v=6.0">
    <style>
        .print-only { display: none; }
        @media print {
            @page { margin: 12mm 15mm; size: A4 portrait; }
            html, body {
                background: #ffffff !important;
                color: #000000 !important;
                font-family: Arial, sans-serif !important;
                margin: 0 !important; padding: 0 !important;
            }
            .sidebar, .sidebar-overlay, .bg-glow-1, .bg-glow-2,
            .top-navbar, .no-print, .mobile-toggle-btn,
            .stats-grid { display: none !important; }
            .app-container, .glass-container { display: block !important; }
            .main-content { width: 100% !important; padding: 0 !important; margin: 0 !important; }
            .glass-card {
                background: #ffffff !important;
                border: 1px solid #111 !important;
                border-radius: 4px !important;
                box-shadow: none !important;
                padding: 16px !important;
                color: #000 !important;
                margin-bottom: 0 !important;
            }
            .print-only { display: block !important; }
            .print-header {
                text-align: center;
                border-bottom: 3px double #000;
                padding-bottom: 12px;
                margin-bottom: 14px;
            }
            .print-header .univ-name { font-size: 18pt; font-weight: bold; text-transform: uppercase; color: #000; }
            .print-header .univ-sub { font-size: 10pt; color: #333; margin-top: 2px; }
            .print-header .doc-title { font-size: 13pt; font-weight: bold; text-transform: uppercase; margin-top: 8px; border: 2px solid #000; display: inline-block; padding: 3px 20px; letter-spacing: 2px; }
            .print-summary {
                display: flex; justify-content: space-between; flex-wrap: wrap;
                border: 1px solid #999; padding: 8px 14px; border-radius: 4px; margin-bottom: 12px;
            }
            .print-summary div { font-size: 10pt; color: #000; }
            .data-table, table { width: 100% !important; border-collapse: collapse !important; }
            .data-table th, table th {
                background: #e8e8e8 !important; color: #000 !important;
                border: 1px solid #000 !important;
                padding: 7px 10px !important; font-size: 9.5pt !important; font-weight: bold !important;
            }
            .data-table td, table td {
                border: 1px solid #666 !important; color: #000 !important;
                padding: 6px 10px !important; font-size: 9pt !important;
            }
            .data-table tr { page-break-inside: avoid; }
            .badge-gold, .badge-violet { background: none !important; border: 1px solid #000 !important; color: #000 !important; padding: 1px 6px !important; font-size: 8pt !important; }
            .no-print { display: none !important; }
            .print-footer { display: flex !important; justify-content: space-between; margin-top: 30px; font-size: 9.5pt; }
            .print-footer div { text-align: center; width: 180px; border-top: 1px solid #000; padding-top: 4px; }
        }
        .print-footer { display: none; }
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
                <div style="display:flex;gap:10px;flex-wrap:wrap;">
                    <button onclick="window.print()" class="btn-primary no-print" style="width: auto;">
                        <i class="fa-solid fa-print"></i> Print Official Ledger
                    </button>
                    <a href="fees?action=pay" class="btn-secondary no-print" style="width: auto; text-decoration:none;">
                        <i class="fa-solid fa-credit-card"></i> Process Payment
                    </a>
                </div>
            </header>

            <!-- Printable Official Header (print only) -->
            <div class="print-only print-header">
                <div class="univ-name">University of Lucknow, Lucknow</div>
                <div class="univ-sub">Lucknow, Uttar Pradesh — Established 1867</div>
                <div class="doc-title">Student Fee Status &amp; Balance Ledger</div>
                <div style="font-size:10pt;margin-top:8px;">Generated: <%= java.time.LocalDate.now() %> &nbsp;|&nbsp; Total Students: <%= totalStudents %> &nbsp;|&nbsp; Fee Submitted: <%= paidCount %> &nbsp;|&nbsp; Pending Dues: <%= pendingCount %></div>
            </div>

            <!-- Summary Overview Cards -->
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
                
                <!-- Filter Tabs -->
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
                            <th>Student Name</th>
                            <th>Department</th>
                            <th>Semester</th>
                            <th>Course Fee (₹)</th>
                            <th>Paid Amount (₹)</th>
                            <th>Pending Balance (₹)</th>
                            <th>Payment Status</th>
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
                                <td style="font-weight: 800; color: var(--gold-light);"><%= row.get("rollNumber") %></td>
                                <td style="font-weight: 600; color: #ffffff;"><%= row.get("fullName") %></td>
                                <td><span class="badge-violet"><%= row.get("deptName") %></span></td>
                                <td>Semester <%= row.get("semester") %></td>
                                <td>₹<%= String.format("%.2f", (double) row.get("totalFee")) %></td>
                                <td style="color: #34d399; font-weight: 700;">₹<%= String.format("%.2f", paid) %></td>
                                <td style="font-weight: 800; color: <%= isSubmitted ? "#34d399" : "#f87171" %>;">
                                    ₹<%= String.format("%.2f", pending) %>
                                </td>
                                <td>
                                    <% if (isSubmitted) { %>
                                        <span class="badge-gold" style="background: rgba(16, 185, 129, 0.2); color: #34d399; border-color: rgba(16, 185, 129, 0.4);">
                                            <i class="fa-solid fa-check-double"></i> SUBMITTED
                                        </span>
                                    <% } else { %>
                                        <span class="badge-gold" style="background: rgba(239, 68, 68, 0.2); color: #f87171; border-color: rgba(239, 68, 68, 0.4);">
                                            <i class="fa-solid fa-clock-rotate-left"></i> PENDING DUES
                                        </span>
                                    <% } %>
                                </td>
                                <td class="no-print">
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

                <div class="print-header" style="margin-top: 30px; text-align: right; font-size: 12px;">
                    <p>Official Signature / Seal ______________________</p>
                    <p style="margin-top:4px;">University of Lucknow Finance & Accounts Division</p>
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
    <!-- Print footer (signature row) -->
    <div class="print-footer">
        <div>Prepared By<br>Finance Officer</div>
        <div>Verified By<br>Controller of Examinations</div>
        <div>Approved By<br>Registrar — University of Lucknow</div>
    </div>
</body>
</html>
