<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Payment" %>
<%@ page import="model.User" %>
<%
    User loggedUser = (User) session.getAttribute("loggedUser");
    if (loggedUser == null) { response.sendRedirect("login.jsp"); return; }
    Payment payment = (Payment) request.getAttribute("payment");
    String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Official Fee Receipt - University of Lucknow</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="css/style.css?v=6.0">
    <style>
        .print-only { display: none; }

        @media print {
            @page { margin: 15mm; size: A4 portrait; }
            
            html, body {
                background: #ffffff !important;
                color: #000000 !important;
                font-family: 'Times New Roman', Times, serif !important;
                margin: 0 !important; padding: 0 !important;
            }

            .sidebar, .top-navbar, .no-print, #aiChatbotTrigger, #aiChatbotWidget,
            .chatbot-flag-bubble, .bg-glow-1, .bg-glow-2 { display: none !important; }

            .app-container, .glass-container { display: block !important; border: none !important; box-shadow: none !important; }
            .main-content { width: 100% !important; padding: 0 !important; margin: 0 !important; }

            .glass-card {
                background: #ffffff !important;
                border: 3px double #000000 !important;
                border-radius: 0 !important;
                box-shadow: none !important;
                padding: 24px !important;
                color: #000000 !important;
                max-width: 100% !important;
            }

            .print-only { display: block !important; }
            .screen-only { display: none !important; }

            .print-receipt-header {
                text-align: center;
                border-bottom: 2px solid #000;
                padding-bottom: 12px;
                margin-bottom: 20px;
            }
            .print-receipt-header .univ-title {
                font-size: 20pt;
                font-weight: bold;
                text-transform: uppercase;
                letter-spacing: 1px;
                color: #000;
            }
            .print-receipt-header .receipt-title-badge {
                font-size: 13pt;
                font-weight: bold;
                text-transform: uppercase;
                border: 2px solid #000;
                display: inline-block;
                padding: 3px 24px;
                margin-top: 8px;
                background: #f5f5f5 !important;
            }

            .receipt-table {
                width: 100% !important;
                border-collapse: collapse !important;
                margin: 20px 0 !important;
            }
            .receipt-table td {
                border: 1px solid #000 !important;
                padding: 8px 12px !important;
                color: #000000 !important;
                font-size: 10.5pt !important;
            }

            .print-signatures {
                display: flex !important;
                justify-content: space-between;
                margin-top: 60px;
                font-size: 10pt;
                font-weight: bold;
            }
            .print-signatures div {
                text-align: center;
                width: 180px;
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
                    <h2>🧾 Official Fee Payment Receipt</h2>
                    <p>Transaction confirmation &amp; printable payment voucher.</p>
                </div>
                <button onclick="window.print()" class="btn-primary no-print" style="width: auto;">
                    <i class="fa-solid fa-print"></i> Print Receipt
                </button>
            </header>

            <% if (msg != null) { %>
                <div class="alert alert-success no-print">
                    <i class="fa-solid fa-circle-check"></i>
                    <span><%= msg %></span>
                </div>
            <% } %>

            <% if (payment != null) { %>
            <div class="glass-card" style="padding: 36px; max-width: 700px; margin: 0 auto;">
                
                <!-- PRINT HEADER -->
                <div class="print-only print-receipt-header">
                    <div class="univ-title">University of Lucknow, Lucknow</div>
                    <div style="font-size: 10pt; font-weight: bold; margin-top: 2px;">FINANCE &amp; ACCOUNTS DIVISION • ESTABLISHED 1867</div>
                    <div class="receipt-title-badge">Official Fee Payment Receipt</div>
                </div>

                <!-- SCREEN HEADER -->
                <div class="screen-only" style="text-align: center; border-bottom: 2px solid var(--gold-border); padding-bottom: 20px; margin-bottom: 24px;">
                    <i class="fa-solid fa-university" style="font-size: 2.8rem; color: var(--gold); margin-bottom: 10px;"></i>
                    <h2 style="font-family: 'Outfit', sans-serif; font-size: 1.8rem; font-weight: 800; color: #ffffff;">UNIVERSITY OF LUCKNOW, LUCKNOW</h2>
                    <p style="color: var(--gold-light); font-size: 0.95rem; font-weight: 700; text-transform: uppercase;">OFFICIAL FEE PAYMENT RECEIPT</p>
                </div>

                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px; font-size: 0.95rem;">
                    <div>
                        <p style="color: var(--text-muted);">Receipt No: <strong style="color: var(--gold-light); font-size: 1.1rem;"><%= payment.getReceiptNo() %></strong></p>
                        <p style="color: var(--text-muted); margin-top: 6px;">Payment Date: <strong style="color: #ffffff;"><%= payment.getPaymentDate() %></strong></p>
                    </div>
                    <div style="text-align: right;">
                        <span class="badge-gold" style="font-size: 0.85rem; padding: 6px 16px;"><i class="fa-solid fa-shield-check"></i> STATUS: ✅ PAID</span>
                    </div>
                </div>

                <table class="data-table receipt-table" style="margin-bottom: 24px;">
                    <tbody>
                        <tr>
                            <td style="font-weight: 700; color: var(--gold-light); width: 40%;">Student Name</td>
                            <td style="font-weight: 700; color: #ffffff;"><%= payment.getStudentName() %></td>
                        </tr>
                        <tr>
                            <td style="font-weight: 700; color: var(--gold-light);">Roll Number</td>
                            <td><%= payment.getRollNumber() %></td>
                        </tr>
                        <tr>
                            <td style="font-weight: 700; color: var(--gold-light);">Department</td>
                            <td><span class="badge-violet"><%= payment.getDeptName() %></span></td>
                        </tr>
                        <tr>
                            <td style="font-weight: 700; color: var(--gold-light);">Semester</td>
                            <td>Semester <%= payment.getSemester() %></td>
                        </tr>
                        <tr>
                            <td style="font-weight: 700; color: var(--gold-light);">Payment Mode</td>
                            <td><%= payment.getPaymentMode() %></td>
                        </tr>
                        <% if (payment.getRemarks() != null && !payment.getRemarks().isEmpty()) { %>
                        <tr>
                            <td style="font-weight: 700; color: var(--gold-light);">Transaction Note</td>
                            <td><%= payment.getRemarks() %></td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>

                <div style="display: flex; justify-content: space-between; align-items: center; background: rgba(255, 215, 0, 0.12); border: 2px solid var(--gold); padding: 20px 24px; border-radius: var(--radius-md);">
                    <span style="font-size: 1.1rem; font-weight: 700; color: var(--text-secondary);">Total Amount Paid:</span>
                    <strong style="font-size: 1.8rem; color: var(--gold-light); font-weight: 800; font-family: 'Outfit', sans-serif;">₹<%= String.format("%.2f", payment.getAmountPaid()) %></strong>
                </div>

                <div class="screen-only" style="margin-top: 32px; text-align: center; color: var(--text-muted); font-size: 0.82rem;">
                    This is a computer-generated official receipt and requires no physical signature.
                </div>

                <div class="print-only print-signatures">
                    <div>Student / Payee</div>
                    <div>Accounts Cashier</div>
                    <div>Finance Officer — Lucknow Univ.</div>
                </div>

            </div>
            <% } else { %>
            <div class="glass-card" style="text-align: center; padding: 60px 20px; color: var(--text-muted);">
                <i class="fa-solid fa-receipt" style="font-size: 3rem; display: block; margin-bottom: 16px; opacity: 0.3;"></i>
                No payment receipt details found.
            </div>
            <% } %>
        </main>
    </div>
</body>
</html>
