// Check authentication on page load
window.addEventListener('load', async () => {
    try {
        // First check server session
        const sessionResponse = await fetch('get_user_data.php', { credentials: 'include' });

        let effectiveUser = null;
        if (sessionResponse.ok) {
            const sessionData = await sessionResponse.json();
            console.log('Session verified:', sessionData);
            effectiveUser = {
                id: sessionData.user_id,
                email: sessionData.email,
                role_id: sessionData.role_id,
                status: sessionData.status
            };
            try { localStorage.setItem('userData', JSON.stringify(effectiveUser)); } catch (_) {}
        } else {
            // Not authenticated: clear any stale client state
            try { localStorage.removeItem('userData'); } catch (_) {}
        }

        const loginSection = document.getElementById('loginSection');
        const userSection = document.getElementById('userSection');
        const usernameEl = document.getElementById('username');

        if (!effectiveUser) {
            // Show login UI instead of redirect
            if (userSection) userSection.style.display = 'none';
            if (loginSection) loginSection.style.display = 'flex';
            return;
        }

        // Display user first name (fallbacks to name/email prefix)
        if (usernameEl) { usernameEl.textContent = ''; }
        if (userSection) userSection.style.display = 'flex';
        if (loginSection) loginSection.style.display = 'none';

        // Show different content based on user role_id
        const content = document.getElementById('dashboardContent');
        if (content) {
            if (effectiveUser.role_id >= 1 && effectiveUser.role_id <= 6) {
                content.innerHTML = ``; // Admin area placeholder
            } else {
                content.innerHTML = ``; // Regular user area placeholder
            }
        }
    } catch (error) {
        console.error('Authentication check failed:', error);
        // Show login UI instead of redirect
        const loginSection = document.getElementById('loginSection');
        const userSection = document.getElementById('userSection');
        if (userSection) userSection.style.display = 'none';
        if (loginSection) loginSection.style.display = 'flex';
    }
});

// Logout function is now handled by js.js
// This ensures consistency across all pages 