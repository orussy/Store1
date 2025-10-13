// Authentication check for protected pages
async function checkAuth() {
    try {
        // Check server session
        const sessionResponse = await fetch('get_user_data.php', {
            credentials: 'include'
        });
        
        if (!sessionResponse.ok) {
            // If not authenticated on server, clear any stale client state and show login UI
            try { localStorage.removeItem('userData'); } catch (_) {}
            const userSection = document.getElementById('userSection');
            const loginSection = document.getElementById('loginSection');
            if (userSection) userSection.style.display = 'none';
            if (loginSection) loginSection.style.display = 'flex';
            return false;
        }
        
        const sessionData = await sessionResponse.json();
        console.log('Session verified:', sessionData);
        
        // Update localStorage with session data
        try {
            localStorage.setItem('userData', JSON.stringify({
                id: sessionData.user_id,
                email: sessionData.email,
                role_id: sessionData.role_id,
                status: sessionData.status
            }));
        } catch (_) {}
        
        // Update UI elements
        const usernameElement = document.getElementById('username');
        const userEmailElement = document.getElementById('userEmail');
        const userSection = document.getElementById('userSection');
        const loginSection = document.getElementById('loginSection');
        
        if (usernameElement) { usernameElement.textContent = ''; }
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
        // Clear localStorage and redirect to login page
        localStorage.removeItem('userData');
        window.location.href = 'index.html';
    }
}

// Check auth when page loads
window.addEventListener('load', checkAuth);
