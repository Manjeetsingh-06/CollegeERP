<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.FeeStructure" %>
<%@ page import="model.Department" %>
<%@ page import="model.User" %>
<%
    User loggedUser = (User) session.getAttribute("loggedUser");
    if (loggedUser == null) { response.sendRedirect("login.jsp"); return; }
    String userRole = loggedUser.getRole();
    boolean isAdmin = "ADMIN".equals(userRole);
    List<FeeStructure> feeList = (List<FeeStructure>) request.getAttribute("feeList");
    List<Department> deptList = (List<Department>) request.getAttribute("deptList");
    String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Fee Structure - University of Lucknow ERP</title>
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
                    <h2>⚙️ Course & Semester Fee Manager</h2>
                    <p><%= isAdmin ? "Add or Edit department semester fees live in real-time." : "View official university fee structures." %></p>
                </div>
            </header>

            <% if (msg != null) { %>
                <div class="alert alert-success">
                    <i class="fa-solid fa-circle-check"></i>
                    <span><%= msg %></span>
                </div>
            <% } %>

            <div class="content-grid" style="<%= isAdmin ? "" : "grid-template-columns: 1fr;" %>">
                
                <!-- Add / Edit Fee Structure Form (ADMIN ONLY) -->
                <% if (isAdmin) { %>
                <div class="glass-card" style="padding: 24px;" id="feeFormCard">
                    <div class="card-title" style="margin-bottom: 20px;">
                        <i class="fa-solid fa-pen-to-square" style="color: var(--gold);" id="formIcon"></i>
                        <span style="font-weight: 800; font-size: 1.1rem;" id="formTitle">Configure / Edit Fee Structure</span>
                    </div>

                    <form action="fees" method="POST" id="feeForm">
                        <input type="hidden" name="action" value="saveStructure">

                        <div class="form-group">
                            <label>Department</label>
                            <select name="deptId" id="formDeptId" class="form-control" style="padding-left: 14px;" required>
                                <option value="">-- Select Department --</option>
                                <% if (deptList != null) { for (Department d : deptList) { %>
                                    <option value="<%= d.getId() %>"><%= d.getDeptCode() %> - <%= d.getDeptName() %></option>
                                <% } } %>
                            </select>
                        </div>

                        <div class="form-group">
                            <label>Semester</label>
                            <select name="semester" id="formSemester" class="form-control" style="padding-left: 14px;" required>
                                <% for (int i = 1; i <= 8; i++) { %>
                                    <option value="<%= i %>">Semester <%= i %></option>
                                <% } %>
                            </select>
                        </div>

                        <div class="form-group">
                            <label>Tuition Fee (₹)</label>
                            <div class="input-wrapper">
                                <input type="number" step="0.01" name="tuitionFee" id="formTuitionFee" class="form-control" placeholder="e.g. 55000.00" required>
                                <i class="fa-solid fa-indian-rupee-sign"></i>
                            </div>
                        </div>

                        <div class="form-group">
                            <label>Exam & Other Fees (₹)</label>
                            <div class="input-wrapper">
                                <input type="number" step="0.01" name="otherFee" id="formOtherFee" class="form-control" placeholder="e.g. 8000.00" required>
                                <i class="fa-solid fa-receipt"></i>
                            </div>
                        </div>

                        <div style="display:flex;gap:10px;">
                            <button type="submit" class="btn-primary" style="flex:1;" id="formSubmitBtn">
                                <i class="fa-solid fa-floppy-disk"></i> Save Fee Structure
                            </button>
                            <button type="button" class="btn-secondary" id="resetBtn" style="display:none;" onclick="resetFeeForm()">
                                <i class="fa-solid fa-rotate-left"></i> Reset
                            </button>
                        </div>
                    </form>
                </div>
                <% } %>

                <!-- Fee Directory Table -->
                <div class="glass-card" style="padding: 24px; overflow-x: auto;">
                    <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:16px;">
                        <h3 style="font-size:1.1rem;font-weight:800;color:var(--text-primary);"><i class="fa-solid fa-indian-rupee-sign" style="color:var(--gold);margin-right:8px;"></i>Active Fee Structures</h3>
                        <span class="badge-gold"><%= feeList != null ? feeList.size() : 0 %> Configured</span>
                    </div>

                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Department</th>
                                <th>Semester</th>
                                <th>Tuition Fee</th>
                                <th>Other Fees</th>
                                <th>Total Fee</th>
                                <% if (isAdmin) { %><th>Action</th><% } %>
                            </tr>
                        </thead>
                        <tbody>
                            <% 
                                if (feeList != null && !feeList.isEmpty()) {
                                    for (FeeStructure f : feeList) {
                            %>
                                <tr>
                                    <td><span class="badge-violet"><%= f.getDeptName() %></span></td>
                                    <td>Semester <%= f.getSemester() %></td>
                                    <td>₹<%= String.format("%.2f", f.getTuitionFee()) %></td>
                                    <td>₹<%= String.format("%.2f", f.getOtherFee()) %></td>
                                    <td style="font-weight: 800; color: var(--gold-light);">₹<%= String.format("%.2f", f.getTotalFee()) %></td>
                                    <% if (isAdmin) { %>
                                    <td>
                                        <button type="button" class="btn-demo" style="padding: 6px 12px; font-size: 12px;" 
                                                onclick="editFeeStructure('<%= f.getDeptId() %>', '<%= f.getSemester() %>', '<%= f.getTuitionFee() %>', '<%= f.getOtherFee() %>')">
                                            <i class="fa-solid fa-pen-to-square"></i> Edit
                                        </button>
                                    </td>
                                    <% } %>
                                </tr>
                            <% 
                                    }
                                } else {
                            %>
                                <tr>
                                    <td colspan="<%= isAdmin ? 6 : 5 %>" style="padding: 40px; text-align: center; color: var(--text-muted);">
                                        No fee structures configured yet.
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>

            </div>

        </main>
    </div>

    <script>
        function editFeeStructure(deptId, semester, tuitionFee, otherFee) {
            const formDept = document.getElementById('formDeptId');
            const formSem = document.getElementById('formSemester');
            const formTuition = document.getElementById('formTuitionFee');
            const formOther = document.getElementById('formOtherFee');
            const formTitle = document.getElementById('formTitle');
            const formSubmitBtn = document.getElementById('formSubmitBtn');
            const resetBtn = document.getElementById('resetBtn');

            if (formDept && formSem && formTuition && formOther) {
                formDept.value = deptId;
                formSem.value = semester;
                formTuition.value = tuitionFee;
                formOther.value = otherFee;

                if (formTitle) formTitle.textContent = "Edit Fee Structure";
                if (formSubmitBtn) formSubmitBtn.innerHTML = '<i class="fa-solid fa-check-double"></i> Update Fee Structure';
                if (resetBtn) resetBtn.style.display = 'inline-flex';

                document.getElementById('feeFormCard').scrollIntoView({ behavior: 'smooth' });
            }
        }

        function resetFeeForm() {
            document.getElementById('feeForm').reset();
            document.getElementById('formTitle').textContent = "Configure / Edit Fee Structure";
            document.getElementById('formSubmitBtn').innerHTML = '<i class="fa-solid fa-floppy-disk"></i> Save Fee Structure';
            document.getElementById('resetBtn').style.display = 'none';
        }
    </script>
</body>
</html>
