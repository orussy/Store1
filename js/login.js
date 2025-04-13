document.getElementById('loginForm').addEventListener('submit', async (e) => {
    e.preventDefault();
    const errorMessage = document.getElementById('error-message');
    errorMessage.style.display = 'none';

    const formData = new FormData(e.target);

    try {
        console.log('Sending login request...');
        const response = await fetch('login.php', {
            method: 'POST',
            body: formData
        });

        const data = await response.json();
        console.log('Login response:', data);

        if (data.status === 'success') {
            console.log('Login successful, storing user data:', data.userData);
            // Store all user data in localStorage
            localStorage.setItem('userData', JSON.stringify(data.userData));
            console.log('User data stored in localStorage');

            // Redirect to dashboard.html
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

// Check if user is already logged in
async function checkLoginStatus() {
    try {
        const response = await fetch('get_user_data.php');
        if (response.ok) {
            const data = await response.json();
            if (data.username) {
                window.location.href = 'dashboard.php';
            }
        }
    } catch (error) {
        console.error('Error checking login status:', error);
    }
}
function handleGoogleLogin(response) {
    try {
        console.log('Google response received:', response);
        
        // Decode JWT token to get user info
        const responsePayload = decodeJwtResponse(response.credential);
        console.log('Decoded payload:', responsePayload);

        // Send to your server
        fetch('google_login.php', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                credential: response.credential,
                email: responsePayload.email,
                name: responsePayload.name,
                sub: responsePayload.sub
            })
        })
        .then(response => {
            console.log('Server response status:', response.status);
            return response.json();
        })
        .then(data => {
            console.log('Server response data:', data);
            if (data.status === 'success') {
                localStorage.setItem('userData', JSON.stringify({
                    email: data.email,
                    role: data.role,
                    id: data.id
                }));
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
// Check login status when page loads
window.addEventListener('load', checkLoginStatus); 