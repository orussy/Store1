// Authentication check for protected pages
async function checkAuth() {
    try {
        // Check server session
        const sessionResponse = await fetch('get_user_data.php', {
            credentials: 'include'
        });
        
        if (!sessionResponse.ok) {
            // Fallback: try validating using localStorage userData
            const localStr = localStorage.getItem('userData');
            let localUser = null;
            try { localUser = JSON.parse(localStr || ''); } catch (_) { localUser = null; }
            if (localUser && localUser.id) {
                try {
                    const profileResp = await fetch('get_user_profile.php?user_id=' + encodeURIComponent(localUser.id), { credentials: 'include' });
                    const profileData = await profileResp.json();
                    if (profileData && profileData.status === 'success' && profileData.userData && profileData.userData.email) {
                        // Treat as authenticated via profile validation
                        const syntheticSession = {
                            user_id: profileData.userData.id,
                            email: profileData.userData.email,
                            role_id: localUser.role_id || 7,
                            status: profileData.userData.status || 'active'
                        };
                        // Update UI elements
                        const usernameElement = document.getElementById('username');
                        const userEmailElement = document.getElementById('userEmail');
                        const userSection = document.getElementById('userSection');
                        const loginSection = document.getElementById('loginSection');
                        if (usernameElement) usernameElement.textContent = syntheticSession.email;
                        if (userEmailElement) userEmailElement.textContent = syntheticSession.email;
                        if (userSection) userSection.style.display = 'block';
                        if (loginSection) loginSection.style.display = 'none';
                        return syntheticSession;
                    }
                } catch (e) {
                    console.warn('Profile validation fallback failed:', e);
                }
            }
            // No valid session or fallback; do not hard redirect to avoid loops
            console.log('No valid session found; showing login UI');
            const userSection = document.getElementById('userSection');
            const loginSection = document.getElementById('loginSection');
            if (userSection) userSection.style.display = 'none';
            if (loginSection) loginSection.style.display = 'flex';
            return false;
        }
        
        const sessionData = await sessionResponse.json();
        console.log('Session verified:', sessionData);
        
        // Update localStorage with session data
        localStorage.setItem('userData', JSON.stringify({
            id: sessionData.user_id,
            email: sessionData.email,
            role_id: sessionData.role_id,
            status: sessionData.status
        }));
        
        // Update UI elements
        const usernameElement = document.getElementById('username');
        const userEmailElement = document.getElementById('userEmail');
        const userSection = document.getElementById('userSection');
        const loginSection = document.getElementById('loginSection');
        
        if (usernameElement) {
            usernameElement.textContent = sessionData.email;
        }
        if (userEmailElement) {
            userEmailElement.textContent = sessionData.email;
        }
        
        if (userSection) {
            userSection.style.display = 'block';
        }
        
        if (loginSection) {
            loginSection.style.display = 'none';
        }
        
        return sessionData;
        
    } catch (error) {
        console.error('Authentication check failed:', error);
        const userSection = document.getElementById('userSection');
        const loginSection = document.getElementById('loginSection');
        if (userSection) userSection.style.display = 'none';
        if (loginSection) loginSection.style.display = 'flex';
        return false;
    }
}

// Logout function
async function logout() {
    try {
        // Call logout endpoint
        await fetch('logout.php', {
            credentials: 'include'
        });
    } catch (error) {
        console.error('Logout error:', error);
    } finally {
        // Clear localStorage; page decides navigation
        localStorage.removeItem('userData');
    }
}

// Check auth when page loads
window.addEventListener('load', checkAuth);
