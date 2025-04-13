// Load user data when page loads
window.addEventListener('load', () => {
    const userData = JSON.parse(localStorage.getItem('userData'));
    
    if (!userData) {
        window.location.href = 'index.html';
        return;
    }

    document.getElementById('username').textContent = userData.username;
    
    // Show different content based on user role
    const content = document.getElementById('dashboardContent');
    if (userData.role === 'admin') {
        content.innerHTML = `
            <h3>Admin Dashboard</h3>
            <p>Welcome to the admin panel.</p>
            <div class="admin-controls">
                <h4>Admin Controls:</h4>
                <ul>
                    <li><a href="#users">Manage Users</a></li>
                    <li><a href="#settings">System Settings</a></li>
                </ul>
            </div>
        `;
    } else {
        content.innerHTML = `
            <h3>User Dashboard</h3>
            <p>Welcome to your dashboard.</p>
            <div class="user-content">
                <h4>Quick Links:</h4>
                <ul>
                    <li><a href="#profile">My Profile</a></li>
                    <li><a href="#settings">Settings</a></li>
                </ul>
            </div>
        `;
    }
});

function logout() {
    localStorage.removeItem('userData');
    fetch('logout.php')
        .finally(() => {
            window.location.href = 'index.html';
        });
} 