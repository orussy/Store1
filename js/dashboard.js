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
            // Fallback to localStorage + server validation via profile endpoint
            const localStr = localStorage.getItem('userData');
            let localUser = null; try { localUser = JSON.parse(localStr || ''); } catch (_) {}
            if (localUser && localUser.id) {
                const profResp = await fetch('get_user_profile.php?user_id=' + encodeURIComponent(localUser.id), { credentials: 'include' });
                const profData = await profResp.json();
                if (profData && profData.status === 'success' && profData.userData && profData.userData.email) {
                    effectiveUser = {
                        id: profData.userData.id,
                        email: profData.userData.email,
                        role_id: profData.userData.role_id || localUser.role_id || 7,
                        status: profData.userData.status || 'active'
                    };
                    try { localStorage.setItem('userData', JSON.stringify(effectiveUser)); } catch (_) {}
                }
            }
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

        // Display user info
        if (usernameEl) usernameEl.textContent = effectiveUser.email;
        if (userSection) userSection.style.display = 'block';
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

async function logout() {
    try {
        // Call logout endpoint
        await fetch('logout.php', {
            credentials: 'include'
        });
    } catch (error) {
        console.error('Logout error:', error);
    } finally {
        // Clear localStorage and redirect to login page
        localStorage.removeItem('userData');
        window.location.href = 'index.html';
    }
} 