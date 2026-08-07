<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - University of Lucknow ERP</title>
    
    <!-- FontAwesome & Custom CSS -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="css/style.css?v=6.0">
</head>
<body>

    <div class="bg-glow-1"></div>
    <div class="bg-glow-2"></div>

    <div class="auth-wrapper glass-container" style="display: flex; flex-direction: column; justify-content: center; align-items: center; min-height: 100vh; padding: 20px;">
        <div class="glass-card login-card" style="width: 100%; max-width: 480px; padding: 36px;">
            
            <div class="brand-header" style="text-align: center; margin-bottom: 28px;">
                <div class="brand-logo" style="width: 64px; height: 64px; background: var(--gold-gradient); border-radius: 20px; display: flex; align-items: center; justify-content: center; margin: 0 auto 16px; font-size: 32px; color: #000; box-shadow: var(--gold-glow);">
                    <i class="fa-solid fa-university"></i>
                </div>
                <h1 style="font-family: 'Outfit', sans-serif; font-size: 24px; font-weight: 800; color: #ffffff; margin-bottom: 6px;">University of Lucknow</h1>
                <p style="color: var(--gold-light); font-size: 13px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.5px;">Lucknow, Uttar Pradesh | ERP Portal</p>
            </div>

            <!-- Error Message Display -->
            <% 
                String errorMessage = (String) request.getAttribute("errorMessage");
                if (errorMessage != null) { 
            %>
                <div class="alert alert-danger">
                    <i class="fa-solid fa-circle-exclamation"></i>
                    <span><%= errorMessage %></span>
                </div>
            <% } %>

            <!-- Logout Success Notification -->
            <% 
                String logoutParam = request.getParameter("logout");
                if ("success".equals(logoutParam)) { 
            %>
                <div class="alert alert-success">
                    <i class="fa-solid fa-circle-check"></i>
                    <span>Logged out successfully. Have a great day!</span>
                </div>
            <% } %>

            <form action="login" method="POST" id="loginForm">
                
                <!-- Role Selector -->
                <div class="role-selector" style="display: flex; gap: 10px; margin-bottom: 22px;">
                    <div class="role-option" style="flex: 1;">
                        <input type="radio" id="roleAdmin" name="role" value="ADMIN" checked style="display:none;">
                        <label for="roleAdmin" class="btn-secondary" style="width:100%; justify-content:center; padding: 10px 4px; font-size:12px;"><i class="fa-solid fa-user-shield"></i> Admin</label>
                    </div>
                    <div class="role-option" style="flex: 1;">
                        <input type="radio" id="roleFaculty" name="role" value="FACULTY" style="display:none;">
                        <label for="roleFaculty" class="btn-secondary" style="width:100%; justify-content:center; padding: 10px 4px; font-size:12px;"><i class="fa-solid fa-chalkboard-user"></i> Faculty</label>
                    </div>
                    <div class="role-option" style="flex: 1;">
                        <input type="radio" id="roleStudent" name="role" value="STUDENT" style="display:none;">
                        <label for="roleStudent" class="btn-secondary" style="width:100%; justify-content:center; padding: 10px 4px; font-size:12px;"><i class="fa-solid fa-user-graduate"></i> Student</label>
                    </div>
                </div>

                <!-- Username Input -->
                <div class="form-group">
                    <label for="username">Username / Roll Number</label>
                    <div class="input-wrapper">
                        <input type="text" id="username" name="username" class="form-control" placeholder="Enter username (e.g. admin)" required autocomplete="username">
                        <i class="fa-solid fa-user"></i>
                    </div>
                </div>

                <!-- Password Input -->
                <div class="form-group">
                    <label for="password">Password</label>
                    <div class="input-wrapper">
                        <input type="password" id="password" name="password" class="form-control" placeholder="Enter password" required autocomplete="current-password">
                        <i class="fa-solid fa-lock"></i>
                        <i class="fa-solid fa-eye" id="togglePassword" style="left: auto; right: 14px; cursor: pointer;"></i>
                    </div>
                </div>

                <button type="submit" class="btn-primary" style="width: 100%; margin-top: 10px;">
                    <span>Sign In to ERP</span>
                    <i class="fa-solid fa-arrow-right"></i>
                </button>
            </form>

            <!-- Quick Demo Credential Quick-Fill Buttons -->
            <div class="demo-fill" style="margin-top: 24px; text-align: center; border-top: 1px solid var(--border-glass); padding-top: 18px;">
                <p style="font-size: 12px; color: var(--text-muted); margin-bottom: 12px;">Quick Test Accounts:</p>
                <div class="demo-btn-group" style="display: flex; gap: 8px; justify-content: center; flex-wrap: wrap;">
                    <button type="button" class="btn-demo" onclick="fillCredentials('admin', 'Manjeet@2007', 'ADMIN')">
                        <i class="fa-solid fa-key"></i> Admin
                    </button>
                    <button type="button" class="btn-demo" onclick="fillCredentials('faculty1', 'Faculty@123', 'FACULTY')">
                        <i class="fa-solid fa-user-tie"></i> Faculty
                    </button>
                    <button type="button" class="btn-demo" onclick="fillCredentials('student1', 'Student@123', 'STUDENT')">
                        <i class="fa-solid fa-book-open"></i> Student
                    </button>
                </div>
            </div>

        </div>

        <!-- FOOTER COPYRIGHT & RESERVED -->
        <footer style="margin-top: 24px; text-align: center; color: var(--text-muted); font-size: 13px;">
            <p style="margin-bottom: 4px;">&copy; 2025 <strong>University of Lucknow, Lucknow</strong>. All Rights Reserved.</p>
            <p style="color: var(--gold-light); font-weight: 700;">Developed by <strong>Manjeet Singh</strong></p>
        </footer>
    </div>

    <script src="js/main.js"></script>
</body>
</html>
