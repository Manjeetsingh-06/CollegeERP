// College ERP Interactive Script & Mobile Responsiveness

document.addEventListener('DOMContentLoaded', () => {
    // Quick Demo Credentials Auto-Fill
    window.fillCredentials = function(username, password, role) {
        const userField = document.getElementById('username');
        const passField = document.getElementById('password');
        
        if (userField && passField) {
            userField.value = username;
            passField.value = password;
            
            const roleRadio = document.querySelector(`input[name="role"][value="${role}"]`);
            if (roleRadio) {
                roleRadio.checked = true;
            }
        }
    };

    // Toggle Password Visibility
    const togglePassBtn = document.getElementById('togglePassword');
    const passInput = document.getElementById('password');
    
    if (togglePassBtn && passInput) {
        togglePassBtn.addEventListener('click', () => {
            const type = passInput.getAttribute('type') === 'password' ? 'text' : 'password';
            passInput.setAttribute('type', type);
            togglePassBtn.classList.toggle('fa-eye');
            togglePassBtn.classList.toggle('fa-eye-slash');
        });
    }

    // Live Clock for Dashboard Top Navigation
    const clockEl = document.getElementById('liveClock');
    if (clockEl) {
        setInterval(() => {
            const now = new Date();
            clockEl.textContent = now.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit', second: '2-digit' });
        }, 1000);
    }

    // Mobile Sidebar Navigation Toggle
    const mobileToggleBtn = document.getElementById('mobileMenuToggle');
    const sidebar = document.querySelector('.sidebar');
    const sidebarOverlay = document.getElementById('sidebarOverlay');

    if (mobileToggleBtn && sidebar) {
        mobileToggleBtn.addEventListener('click', () => {
            sidebar.classList.toggle('show-mobile');
            if (sidebarOverlay) sidebarOverlay.classList.toggle('show');
        });
    }

    if (sidebarOverlay && sidebar) {
        sidebarOverlay.addEventListener('click', () => {
            sidebar.classList.remove('show-mobile');
            sidebarOverlay.classList.remove('show');
        });
    }
});
