<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%
    User sUser = (User) session.getAttribute("loggedUser");
    String sRole = (sUser != null) ? sUser.getRole() : "";
    String currentPage = request.getRequestURI();
    String actionParam = request.getParameter("action");
%>
<!-- Mobile Overlay -->
<div class="sidebar-overlay" id="sidebarOverlay"></div>

<aside class="sidebar">
    <div class="sidebar-brand">
        <div class="logo-icon"><i class="fa-solid fa-university"></i></div>
        <div>
            <h2 style="font-size:15px;line-height:1.2;">University of Lucknow</h2>
            <span style="font-size:10px;color:var(--gold-light);font-weight:600;letter-spacing:0.5px;">ERP MANAGEMENT SYSTEM</span>
        </div>
        <button type="button" class="mobile-close-btn" id="mobileMenuClose"
            onclick="document.querySelector('.sidebar').classList.remove('show-mobile');document.getElementById('sidebarOverlay').classList.remove('show');">
            <i class="fa-solid fa-xmark"></i>
        </button>
    </div>

    <ul class="nav-menu">
        <li class="nav-item <%= currentPage.contains("dashboard") ? "active" : "" %>">
            <a href="dashboard.jsp"><i class="fa-solid fa-chart-line"></i> <span>Dashboard</span></a>
        </li>

        <% if ("ADMIN".equals(sRole)) { %>
            <li class="nav-item <%= currentPage.contains("student") ? "active" : "" %>">
                <a href="students"><i class="fa-solid fa-user-graduate"></i> <span>Students</span></a>
            </li>
            <li class="nav-item <%= currentPage.contains("faculty") ? "active" : "" %>">
                <a href="faculty"><i class="fa-solid fa-chalkboard-user"></i> <span>Faculty</span></a>
            </li>
            <li class="nav-item <%= currentPage.contains("departments") ? "active" : "" %>">
                <a href="departments"><i class="fa-solid fa-building-columns"></i> <span>Departments</span></a>
            </li>
            <li class="nav-item <%= currentPage.contains("subjects") ? "active" : "" %>">
                <a href="subjects"><i class="fa-solid fa-book-open"></i> <span>Courses & Subjects</span></a>
            </li>
            <li class="nav-item <%= currentPage.contains("attendance") ? "active" : "" %>">
                <a href="attendance"><i class="fa-solid fa-clipboard-user"></i> <span>Attendance</span></a>
            </li>
            <li class="nav-item <%= currentPage.contains("marks") ? "active" : "" %>">
                <a href="marks"><i class="fa-solid fa-award"></i> <span>Marks & Results</span></a>
            </li>

            <!-- DEDICATED FINANCE & FEE OPTIONS FOR ADMIN -->
            <li class="nav-item <%= currentPage.contains("fees") && "structure".equals(actionParam) ? "active" : "" %>">
                <a href="fees?action=structure"><i class="fa-solid fa-gears"></i> <span>Fee Structure</span></a>
            </li>
            <li class="nav-item <%= currentPage.contains("fees") && ("pending".equals(actionParam) || actionParam == null) ? "active" : "" %>">
                <a href="fees?action=pending"><i class="fa-solid fa-receipt"></i> <span>Pending Fees Ledger</span></a>
            </li>
            <li class="nav-item <%= currentPage.contains("fees") && "pay".equals(actionParam) ? "active" : "" %>">
                <a href="fees?action=pay"><i class="fa-solid fa-credit-card"></i> <span>Pay Student Fees</span></a>
            </li>

            <li class="nav-item <%= currentPage.contains("library") || currentPage.contains("book") ? "active" : "" %>">
                <a href="library"><i class="fa-solid fa-book"></i> <span>Library</span></a>
            </li>

        <% } else if ("FACULTY".equals(sRole)) { %>
            <li class="nav-item <%= currentPage.contains("student") ? "active" : "" %>">
                <a href="students"><i class="fa-solid fa-user-graduate"></i> <span>Class Students</span></a>
            </li>
            <li class="nav-item <%= currentPage.contains("subjects") ? "active" : "" %>">
                <a href="subjects"><i class="fa-solid fa-book-open"></i> <span>Course Catalog</span></a>
            </li>
            <li class="nav-item <%= currentPage.contains("attendance") ? "active" : "" %>">
                <a href="attendance"><i class="fa-solid fa-clipboard-user"></i> <span>Mark Class Attendance</span></a>
            </li>
            <li class="nav-item <%= currentPage.contains("marks") ? "active" : "" %>">
                <a href="marks"><i class="fa-solid fa-award"></i> <span>Enter Class Marks</span></a>
            </li>

        <% } else { %>
            <li class="nav-item <%= currentPage.contains("attendance") ? "active" : "" %>">
                <a href="attendance?action=report"><i class="fa-solid fa-clipboard-user"></i> <span>My Attendance</span></a>
            </li>
            <li class="nav-item <%= currentPage.contains("marks") ? "active" : "" %>">
                <a href="marks?action=marksheet"><i class="fa-solid fa-award"></i> <span>My Results</span></a>
            </li>
            <li class="nav-item <%= currentPage.contains("fees") ? "active" : "" %>">
                <a href="fees?action=pay"><i class="fa-solid fa-indian-rupee-sign"></i> <span>Pay Fees</span></a>
            </li>
            <li class="nav-item <%= currentPage.contains("library") || currentPage.contains("book") ? "active" : "" %>">
                <a href="library"><i class="fa-solid fa-book"></i> <span>Library Books</span></a>
            </li>
        <% } %>

        <!-- COMMON MODULES -->
        <li class="nav-item <%= currentPage.contains("notices") ? "active" : "" %>">
            <a href="notices"><i class="fa-solid fa-bullhorn"></i> <span>Notices</span></a>
        </li>
        <li class="nav-item <%= currentPage.contains("timetable") ? "active" : "" %>">
            <a href="timetable"><i class="fa-solid fa-calendar-week"></i> <span>Timetable</span></a>
        </li>
        <li class="nav-item <%= currentPage.contains("complaints") ? "active" : "" %>">
            <a href="complaints"><i class="fa-solid fa-comments"></i> <span>Complaints & Help</span></a>
        </li>

        <li class="nav-item" style="margin-top: auto;">
            <a href="logout" style="color: #f87171;"><i class="fa-solid fa-right-from-bracket"></i> <span>Logout</span></a>
        </li>
    </ul>

    <!-- SIDEBAR FOOTER -->
    <div class="sidebar-footer">
        <i class="fa-solid fa-university" style="color:var(--gold);margin-bottom:6px;font-size:18px;"></i>
        <p style="font-size:11px;font-weight:700;color:var(--gold-light);margin-bottom:2px;">University of Lucknow, Lucknow</p>
        <p style="font-size:10px;color:var(--text-muted);">&copy; 2025 <strong>University of Lucknow, Lucknow</strong>. All Rights Reserved.</p>
        <p style="font-size:10px;color:var(--text-muted);">Developed by <strong style="color:var(--gold-light);">Manjeet Singh</strong></p>
    </div>
</aside>

<!-- =========================================================
     FLOATING DRAGGABLE AI CHATBOT ASSISTANT WIDGET
     ========================================================= -->
<div id="aiChatbotTrigger" title="Drag me anywhere or Click to Chat!">
    <i class="fa-solid fa-robot"></i>
    <span class="badge-dot"></span>
    <div class="chatbot-flag-bubble">💡 May I Help You? Chat with AI</div>
</div>

<div id="aiChatbotWidget">
    <div class="chatbot-header" id="aiChatbotHeader">
        <div class="chatbot-header-title">
            <i class="fa-solid fa-robot"></i>
            <div>
                <h4>LU ERP Assistant</h4>
                <span>AI Powered Helpdesk • Drag Head</span>
            </div>
        </div>
        <button type="button" class="chatbot-close-btn" onclick="toggleChatbot(false)">
            <i class="fa-solid fa-xmark"></i>
        </button>
    </div>

    <div class="chatbot-body" id="chatbotBody">
        <div class="chat-msg bot">
            👋 Namaste! I am <strong>Lucknow University ERP AI Assistant</strong>.<br>How can I assist you today?
        </div>
    </div>

    <div class="chatbot-chips">
        <button type="button" class="chip-btn" onclick="quickAsk('How to pay fees?')">💳 Pay Fees</button>
        <button type="button" class="chip-btn" onclick="quickAsk('Where to check results?')">📝 Marksheets</button>
        <button type="button" class="chip-btn" onclick="quickAsk('Attendance rules')">📊 Attendance</button>
        <button type="button" class="chip-btn" onclick="quickAsk('Library books')">📚 Library</button>
    </div>

    <div class="chatbot-input-area">
        <input type="text" id="chatbotInput" placeholder="Type your question..." onkeypress="if(event.key==='Enter') sendChatMessage()">
        <button type="button" class="chatbot-send-btn" onclick="sendChatMessage()">
            <i class="fa-solid fa-paper-plane"></i>
        </button>
    </div>
</div>

<script>
    // --- ATTACH DIRECTLY TO DOCUMENT.BODY TO FIX ADMIN PANEL CONTAINER CLIP ---
    document.addEventListener("DOMContentLoaded", function() {
        const trigger = document.getElementById('aiChatbotTrigger');
        const widget = document.getElementById('aiChatbotWidget');
        if (trigger && widget) {
            document.body.appendChild(trigger);
            document.body.appendChild(widget);
        }
    });

    // --- DRAGGABLE WIDGET LOGIC ---
    (function makeDraggable() {
        const trigger = document.getElementById('aiChatbotTrigger');
        const widget = document.getElementById('aiChatbotWidget');
        const header = document.getElementById('aiChatbotHeader');

        let isDragging = false;
        let startX, startY, initialLeft, initialTop;

        // Toggle open/close on click (only if not dragged)
        let draggedFar = false;

        function startDrag(e, el) {
            isDragging = true;
            draggedFar = false;
            const event = e.touches ? e.touches[0] : e;
            startX = event.clientX;
            startY = event.clientY;

            const rect = el.getBoundingClientRect();
            initialLeft = rect.left;
            initialTop = rect.top;

            el.style.bottom = 'auto';
            el.style.right = 'auto';
            el.style.left = initialLeft + 'px';
            el.style.top = initialTop + 'px';
        }

        function doDrag(e, el) {
            if (!isDragging) return;
            const event = e.touches ? e.touches[0] : e;
            const dx = event.clientX - startX;
            const dy = event.clientY - startY;

            if (Math.abs(dx) > 4 || Math.abs(dy) > 4) draggedFar = true;

            let newLeft = initialLeft + dx;
            let newTop = initialTop + dy;

            // Screen boundary bounds
            newLeft = Math.max(10, Math.min(window.innerWidth - el.offsetWidth - 10, newLeft));
            newTop = Math.max(10, Math.min(window.innerHeight - el.offsetHeight - 10, newTop));

            el.style.left = newLeft + 'px';
            el.style.top = newTop + 'px';
        }

        function stopDrag() {
            isDragging = false;
        }

        // Trigger dragging
        trigger.addEventListener('mousedown', (e) => startDrag(e, trigger));
        document.addEventListener('mousemove', (e) => doDrag(e, trigger));
        document.addEventListener('mouseup', stopDrag);

        trigger.addEventListener('touchstart', (e) => startDrag(e, trigger));
        document.addEventListener('touchmove', (e) => doDrag(e, trigger));
        document.addEventListener('touchend', stopDrag);

        // Header dragging for window
        header.addEventListener('mousedown', (e) => startDrag(e, widget));
        document.addEventListener('mousemove', (e) => doDrag(e, widget));
        document.addEventListener('mouseup', stopDrag);

        header.addEventListener('touchstart', (e) => startDrag(e, widget));
        document.addEventListener('touchmove', (e) => doDrag(e, widget));
        document.addEventListener('touchend', stopDrag);

        trigger.addEventListener('click', () => {
            if (!draggedFar) {
                const isOpen = widget.classList.contains('open');
                toggleChatbot(!isOpen);
            }
        });
    })();

    function toggleChatbot(show) {
        const widget = document.getElementById('aiChatbotWidget');
        if (show) {
            widget.classList.add('open');
            document.getElementById('chatbotInput').focus();
        } else {
            widget.classList.remove('open');
        }
    }

    function quickAsk(text) {
        document.getElementById('chatbotInput').value = text;
        sendChatMessage();
    }

    function sendChatMessage() {
        const input = document.getElementById('chatbotInput');
        const msg = input.value.trim();
        if (!msg) return;

        const body = document.getElementById('chatbotBody');

        // Append User Message
        const userDiv = document.createElement('div');
        userDiv.className = 'chat-msg user';
        userDiv.textContent = msg;
        body.appendChild(userDiv);
        input.value = '';
        body.scrollTop = body.scrollHeight;

        // Show typing indicator
        const botDiv = document.createElement('div');
        botDiv.className = 'chat-msg bot';
        botDiv.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i> Typing...';
        body.appendChild(botDiv);
        body.scrollTop = body.scrollHeight;

        // AJAX POST to ChatbotServlet
        fetch('chatbot', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'message=' + encodeURIComponent(msg)
        })
        .then(response => response.json())
        .then(data => {
            botDiv.innerHTML = data.reply;
            body.scrollTop = body.scrollHeight;
        })
        .catch(err => {
            botDiv.innerHTML = '⚠️ Connection error. Please try again.';
            body.scrollTop = body.scrollHeight;
        });
    }
</script>

