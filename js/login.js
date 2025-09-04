// NO AUTO-REDIRECT LOGIC - Users must manually log in
console.log('Login page loaded');

document.getElementById('loginForm').addEventListener('submit', async (e) => {
    e.preventDefault();
    const errorMessage = document.getElementById('error-message');
    errorMessage.style.display = 'none';

    const formData = new FormData(e.target);

    try {
        console.log('Sending login request...');
        const response = await fetch('login.php', {
            method: 'POST',
            body: formData,
            credentials: 'include'
        });

        const data = await response.json();
        console.log('Login response:', data);

        if (data.status === 'success') {
            // Persist basic user data for fallback validation on next page
            try { localStorage.setItem('userData', JSON.stringify(data.userData)); } catch (_) {}
            // After login, verify session on server before redirect
            const sessionResp = await fetch('get_user_data.php', { credentials: 'include' });
            if (!sessionResp.ok) {
                throw new Error('Session not established');
            }
            const sessionData = await sessionResp.json();
            console.log('Session verified:', sessionData);
            window.location.href = data.redirect;
        } else {
            console.log('Login failed:', data.message);
            errorMessage.textContent = data.message;
            errorMessage.style.display = 'block';
        }
    } catch (error) {
        console.error('Login error:', error);
        errorMessage.textContent = 'An error occurred during login';
        errorMessage.style.display = 'block';
    }
});

// Remove auto-redirect based on localStorage; verify session explicitly instead
function handleGoogleLogin(response) {
    try {
        console.log('Google response received:', response);
        const responsePayload = decodeJwtResponse(response.credential);

        fetch('google_login.php', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            credentials: 'include',
            body: JSON.stringify({
                credential: response.credential,
                email: responsePayload.email,
                name: responsePayload.name,
                sub: responsePayload.sub
            })
        })
        .then(async (resp) => {
            // If server blocked login for blocked status
            if (!resp.ok) {
                const txt = await resp.text();
                let err;
                try { err = JSON.parse(txt); } catch (_) { err = { message: txt || 'Login failed' }; }
                throw new Error(err.message || 'Login failed');
            }
            return resp.json();
        })
        .then(async (data) => {
            if (data.status === 'success') {
                // Persist basic user data for fallback validation
                try { localStorage.setItem('userData', JSON.stringify(data.userData || { email: responsePayload.email })); } catch (_) {}
                // Verify session before redirect
                const sessionResp = await fetch('get_user_data.php', { credentials: 'include' });
                if (!sessionResp.ok) throw new Error('Session not established');
                const sessionData = await sessionResp.json();
                console.log('Session verified:', sessionData);
                window.location.href = 'dashboard.html';
            } else {
                throw new Error(data.message || 'Login failed');
            }
        })
        .catch(error => {
            console.error('Fetch error:', error);
            document.getElementById('error-message').textContent = error.message || 'An error occurred during login';
            document.getElementById('error-message').style.display = 'block';
        });
    } catch (error) {
        console.error('Handler error:', error);
        document.getElementById('error-message').textContent = 'An error occurred during login processing';
        document.getElementById('error-message').style.display = 'block';
    }
}

function decodeJwtResponse(token) {
    try {
        const base64Url = token.split('.')[1];
        const base64 = base64Url.replace(/-/g, '+').replace(/_/g, '/');
        const jsonPayload = decodeURIComponent(atob(base64).split('').map(function(c) {
            return '%' + ('00' + c.charCodeAt(0).toString(16)).slice(-2);
        }).join(''));
        return JSON.parse(jsonPayload);
    } catch (error) {
        console.error('Decode error:', error);
        throw new Error('Failed to decode token');
    }
}

// Remove auto-redirect on load; require explicit login
window.addEventListener('load', () => {
    console.log('Login page ready - waiting for user action');
}); 