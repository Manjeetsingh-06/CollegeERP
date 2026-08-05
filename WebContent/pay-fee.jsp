<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Student" %>
<%@ page import="model.User" %>
<%
    User loggedUser = (User) session.getAttribute("loggedUser");
    if (loggedUser == null) { response.sendRedirect("login.jsp"); return; }
    List<Student> studentList = (List<Student>) request.getAttribute("studentList");
    Student selectedStudent = (Student) request.getAttribute("selectedStudent");
    String msg = request.getParameter("msg");
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pay Fee - University of Lucknow ERP</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="css/style.css?v=6.0">
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
                    <h2>💳 Fee Payment Portal</h2>
                    <p>Process semester fee payments and generate digital receipts.</p>
                </div>
            </header>

            <% if (msg != null) { %><div class="alert alert-success"><i class="fa-solid fa-circle-check"></i> <span><%= msg %></span></div><% } %>
            <% if (error != null) { %><div class="alert alert-danger"><i class="fa-solid fa-circle-exclamation"></i> <span><%= error %></span></div><% } %>

            <div class="glass-card" style="padding: 28px; max-width: 650px;">
                <h3 style="font-size: 1.1rem; font-weight: 800; color: var(--text-primary); margin-bottom: 20px;">
                    <i class="fa-solid fa-credit-card" style="color: var(--gold); margin-right: 8px;"></i>Process Fee Payment
                </h3>

                <form action="fees" method="POST">
                    <input type="hidden" name="action" value="processPayment">

                    <div class="form-group">
                        <label>Select Student</label>
                        <select name="studentId" class="form-control" style="padding-left: 14px;" required>
                            <option value="">-- Choose Student --</option>
                            <% if (studentList != null) { for (Student s : studentList) { %>
                                <option value="<%= s.getId() %>" <%= selectedStudent != null && selectedStudent.getId() == s.getId() ? "selected" : "" %>>
                                    <%= s.getRollNumber() %> - <%= s.getFullName() %> (<%= s.getDeptName() %>)
                                </option>
                            <% } } %>
                        </select>
                    </div>

                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px;">
                        <div class="form-group">
                            <label>Payment Amount (₹)</label>
                            <div class="input-wrapper">
                                <input type="number" step="0.01" name="amountPaid" class="form-control" placeholder="Enter amount" min="1" required>
                                <i class="fa-solid fa-indian-rupee-sign"></i>
                            </div>
                        </div>

                        <div class="form-group">
                            <label>Payment Mode</label>
                            <select name="paymentMode" class="form-control" style="padding-left: 14px;" required>
                                <option value="ONLINE">UPI / Net Banking</option>
                                <option value="CASH">Cash Deposit</option>
                                <option value="CHEQUE">Demand Draft / Cheque</option>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Transaction / Reference Note</label>
                        <div class="input-wrapper">
                            <input type="text" name="remarks" class="form-control" placeholder="Transaction ID or bank note">
                            <i class="fa-solid fa-receipt"></i>
                        </div>
                    </div>

                    <button type="submit" class="btn-primary" style="margin-top: 10px; width: 100%;">
                        <i class="fa-solid fa-circle-check"></i> Submit Payment & Issue Receipt
                    </button>
                </form>
            </div>
        </main>
    </div>
</body>
</html>
