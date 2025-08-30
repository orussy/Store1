// User Profile Page JavaScript

document.addEventListener('DOMContentLoaded', function() {
    // Get all navigation items
    const navItems = document.querySelectorAll('.nav-item');
    const mainContent = document.querySelector('.main-content');

    // Load initial section - default to 'personal'
    loadSectionContent('personal');

    // Add click event listeners to navigation items
    navItems.forEach(item => {
        item.addEventListener('click', function(e) {
            e.preventDefault();
            
            // Remove active class from all items
            navItems.forEach(nav => nav.classList.remove('active'));
            
            // Add active class to clicked item
            this.classList.add('active');
            
            // Get the section data attribute
            const section = this.getAttribute('data-section');
            
            // Load content based on section
            loadSectionContent(section);
        });
    });

    // Function to fetch user profile data from database
    async function fetchUserProfileData() {
        try {
            const response = await fetch('get_user_profile.php');
            const data = await response.json();
            
            if (data.status === 'success') {
                return data.userData;
            } else {
                console.error('Error fetching user data:', data.message);
                return null;
            }
        } catch (error) {
            console.error('Error fetching user profile:', error);
            return null;
        }
    }

    // Function to format date
    function formatDate(dateString) {
        if (!dateString) return 'Not provided';
        
        try {
            const date = new Date(dateString);
            if (isNaN(date.getTime())) {
                // If it's not a valid date, return as is
                return dateString;
            }
            return date.toLocaleDateString('en-US', {
                year: 'numeric',
                month: 'long',
                day: 'numeric'
            });
        } catch (error) {
            return dateString;
        }
    }

    // Function to load section content
    async function loadSectionContent(section) {
        console.log('Loading section:', section);
        let content = '';
        
        switch(section) {
            case 'personal':
                // Fetch user data for personal information
                const userData = await fetchUserProfileData();
                
                if (userData) {
                    const fullName = `${userData.f_name || ''} ${userData.l_name || ''}`.trim() || 'Not provided';
                    const email = userData.email || 'Not provided';
                    const phone = userData.phone || 'Not provided';
                    const dateOfBirth = formatDate(userData.date_of_birth);
                    const gender = userData.gender || 'Not provided';
                    const loyaltyPoints = userData.loyalty_points || 0;
                    
                    content = `
                        <div class="section-content">
                            <h2>Personal Information</h2>
                            <div class="info-grid">
                                <div class="info-item">
                                    <label>Full Name:</label>
                                    <span>${fullName}</span>
                                </div>
                                <div class="info-item">
                                    <label>Email:</label>
                                    <span>${email}</span>
                                </div>
                                <div class="info-item">
                                    <label>Phone:</label>
                                    <span>${phone}</span>
                                </div>
                                <div class="info-item">
                                    <label>Date of Birth:</label>
                                    <span>${dateOfBirth}</span>
                                </div>
                                <div class="info-item">
                                    <label>Gender:</label>
                                    <span>${gender}</span>
                                </div>
                                <div class="info-item">
                                    <label>Loyalty Points:</label>
                                    <span>${loyaltyPoints}</span>
                                </div>
                                <div class="info-item">
                                    <label>Account Created:</label>
                                    <span>${formatDate(userData.created_at)}</span>
                                </div>
                            </div>
                        </div>
                    `;
                } else {
                    content = `
                        <div class="section-content">
                            <h2>Personal Information</h2>
                            <div class="error-message">
                                <p>Unable to load user data. Please try refreshing the page.</p>
                            </div>
                        </div>
                    `;
                }
                break;
                
            case 'settings':
                console.log('Loading settings section...');
                // Fetch user data for settings
                const settingsUserData = await fetchUserProfileData();
                console.log('Settings user data:', settingsUserData);
                
                if (settingsUserData) {
                    content = `
                        <div class="section-content">
                            <h2>Account Settings</h2>
                            <div class="settings-container">
                                <!-- Edit Profile Section -->
                                <div class="settings-section">
                                    <h3><i class="fas fa-user-edit"></i> Edit Profile Information</h3>
                                    <form id="editProfileForm" class="edit-form">
                                        <div class="form-row">
                                            <div class="form-group">
                                                <label for="editFirstName">First Name *</label>
                                                <input type="text" id="editFirstName" name="f_name" value="${settingsUserData.f_name || ''}" required>
                                            </div>
                                            <div class="form-group">
                                                <label for="editLastName">Last Name *</label>
                                                <input type="text" id="editLastName" name="l_name" value="${settingsUserData.l_name || ''}" required>
                                            </div>
                                        </div>
                                        <div class="form-row">
                                            <div class="form-group">
                                                <label for="editPhone">Phone Number</label>
                                                <input type="tel" id="editPhone" name="phone" value="${settingsUserData.phone || ''}">
                                            </div>
                                            <div class="form-group">
                                                <label for="editBirthdate">Date of Birth</label>
                                                <input type="date" id="editBirthdate" name="birthdate" value="${settingsUserData.date_of_birth || ''}">
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label for="editGender">Gender</label>
                                            <select id="editGender" name="gender">
                                                <option value="">Select Gender</option>
                                                <option value="male" ${settingsUserData.gender === 'male' ? 'selected' : ''}>Male</option>
                                                <option value="female" ${settingsUserData.gender === 'female' ? 'selected' : ''}>Female</option>
                                                <option value="other" ${settingsUserData.gender === 'other' ? 'selected' : ''}>Other</option>
                                            </select>
                                        </div>
                                        <div class="form-actions">
                                            <button type="submit" class="btn btn-primary">
                                                <i class="fas fa-save"></i> Update Profile
                                            </button>
                                        </div>
                                    </form>
                                </div>

                                <!-- Change Email Section -->
                                <div class="settings-section">
                                    <h3><i class="fas fa-envelope"></i> Change Email Address</h3>
                                    <form id="changeEmailForm" class="edit-form">
                                        <div class="form-group">
                                            <label for="currentEmail">Current Email</label>
                                            <input type="email" id="currentEmail" value="${settingsUserData.email || ''}" readonly>
                                        </div>
                                        <div class="form-group">
                                            <label for="newEmail">New Email Address *</label>
                                            <input type="email" id="newEmail" name="new_email" required>
                                        </div>
                                        <div class="form-group">
                                            <label for="emailVerificationCode">Verification Code</label>
                                            <div class="verification-group">
                                                <input type="text" id="emailVerificationCode" name="verification_code" placeholder="Enter 6-digit code" maxlength="6">
                                                <button type="button" class="btn btn-secondary" onclick="sendEmailVerification()">
                                                    <i class="fas fa-paper-plane"></i> Send Code
                                                </button>
                                            </div>
                                        </div>
                                        <div class="form-actions">
                                            <button type="submit" class="btn btn-primary">
                                                <i class="fas fa-check"></i> Change Email
                                            </button>
                                        </div>
                                    </form>
                                </div>

                                <!-- Change Password Section -->
                                <div class="settings-section">
                                    <h3><i class="fas fa-lock"></i> Change Password</h3>
                                    <form id="changePasswordForm" class="edit-form">
                                        <div class="form-group">
                                            <label for="currentPassword">Current Password *</label>
                                            <input type="password" id="currentPassword" name="current_password" required>
                                        </div>
                                        <div class="form-group">
                                            <label for="newPassword">New Password *</label>
                                            <input type="password" id="newPassword" name="new_password" required>
                                            <small class="password-requirements">Password must be at least 8 characters long</small>
                                        </div>
                                        <div class="form-group">
                                            <label for="confirmPassword">Confirm New Password *</label>
                                            <input type="password" id="confirmPassword" name="confirm_password" required>
                                        </div>
                                        <div class="form-actions">
                                            <button type="submit" class="btn btn-primary">
                                                <i class="fas fa-key"></i> Change Password
                                            </button>
                                        </div>
                                    </form>
                                </div>

                                <!-- Account Deactivation Section -->
                                <div class="settings-section">
                                    <h3><i class="fas fa-user-slash"></i> Account Deactivation</h3>
                                    <div class="deactivation-info">
                                        <p><strong>Warning:</strong> This action will deactivate your account temporarily.</p>
                                        <ul>
                                            <li>You will be logged out immediately</li>
                                            <li>You cannot access your account while deactivated</li>
                                            <li>Your account will be automatically reactivated when you log in again</li>
                                        </ul>
                                    </div>
                                    <button class="btn btn-deactivate" onclick="showDeactivateModal()">
                                        <i class="fas fa-user-slash"></i> Deactivate Account
                                    </button>
                                </div>
                            </div>
                        </div>
                    `;
                } else {
                    console.error('Failed to load settings data');
                    content = `
                        <div class="section-content">
                            <h2>Account Settings</h2>
                            <div class="error-message">
                                <p>Unable to load user data. Please try refreshing the page.</p>
                                <p>If the problem persists, please log out and log back in.</p>
                            </div>
                        </div>
                    `;
                }
                break;
                
            case 'history':
                content = `
                    <div class="section-content">
                        <h2>Purchase History</h2>
                        <div class="history-list">
                            <div class="history-item">
                                <div class="order-info">
                                    <strong>Order #12345</strong>
                                    <span>March 15, 2024</span>
                                </div>
                                <div class="order-status">Delivered</div>
                            </div>
                            <div class="history-item">
                                <div class="order-info">
                                    <strong>Order #12344</strong>
                                    <span>March 10, 2024</span>
                                </div>
                                <div class="order-status">Shipped</div>
                            </div>
                        </div>
                    </div>
                `;
                break;
                
            case 'status':
                content = `
                    <div class="section-content">
                        <h2>Account Status</h2>
                        <div class="status-info">
                            <div class="status-card">
                                <div class="status-header">
                                    <h3>Current Status</h3>
                                    <span id="currentStatus" class="status-badge"></span>
                                </div>
                                <div class="status-description">
                                    <p id="statusDescription"></p>
                                </div>
                            </div>
                            <div class="status-actions">
                                <h3>Status Information</h3>
                                <ul class="status-list">
                                    <li><strong>Active:</strong> Your account is active and you can use all features.</li>
                                    <li><strong>Deactivated:</strong> Your account is temporarily inactive but will be reactivated on next login.</li>
                                    <li><strong>Blocked:</strong> Your account has been blocked. Contact support for assistance.</li>
                                </ul>
                                <div class="status-note">
                                    <p><strong>Note:</strong> You can deactivate your own account from Account Settings. Deactivated accounts are automatically reactivated when you log in again.</p>
                                </div>
                            </div>
                        </div>
                    </div>
                `;
                break;
                
            default:
                content = `
                    <div class="content-placeholder">
                        <h2>Welcome to Your Profile</h2>
                        <p>Select an option from the sidebar to get started.</p>
                    </div>
                `;
        }
        
        mainContent.innerHTML = content;
        
        // If status section is loaded, update the status display
        if (section === 'status') {
            updateStatusDisplay();
        }
    }

    // Function to update status display
    async function updateStatusDisplay() {
        const userData = await fetchUserProfileData();
        if (userData && userData.status) {
            const status = userData.status;
            const statusElement = document.getElementById('currentStatus');
            const descriptionElement = document.getElementById('statusDescription');
            
            if (statusElement) {
                statusElement.textContent = status.charAt(0).toUpperCase() + status.slice(1);
                statusElement.className = `status-badge status-${status}`;
            }
            
            if (descriptionElement) {
                const descriptions = {
                    'active': 'Your account is fully active and you have access to all features.',
                    'deactivated': 'Your account is temporarily inactive. It will be automatically reactivated when you log in.',
                    'blocked': 'Your account has been blocked. Please contact customer support for assistance.'
                };
                descriptionElement.textContent = descriptions[status] || 'Status information not available.';
            }
        }
    }

    // Initialize with default content
    loadSectionContent('personal');
    
    // Add form event listeners when settings section is loaded
    document.addEventListener('click', function(e) {
        if (e.target && e.target.closest('#editProfileForm')) {
            const form = e.target.closest('#editProfileForm');
            if (!form.hasAttribute('data-listener-added')) {
                form.addEventListener('submit', handleEditProfile);
                form.setAttribute('data-listener-added', 'true');
            }
        }
        if (e.target && e.target.closest('#changeEmailForm')) {
            const form = e.target.closest('#changeEmailForm');
            if (!form.hasAttribute('data-listener-added')) {
                form.addEventListener('submit', handleChangeEmail);
                form.setAttribute('data-listener-added', 'true');
            }
        }
        if (e.target && e.target.closest('#changePasswordForm')) {
            const form = e.target.closest('#changePasswordForm');
            if (!form.hasAttribute('data-listener-added')) {
                form.addEventListener('submit', handleChangePassword);
                form.setAttribute('data-listener-added', 'true');
            }
        }
    });
});

// Form handling functions
async function handleEditProfile(e) {
    e.preventDefault();
    
    const formData = new FormData(e.target);
    const submitBtn = e.target.querySelector('button[type="submit"]');
    const originalText = submitBtn.innerHTML;
    
    try {
        submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Updating...';
        submitBtn.disabled = true;
        
        const response = await fetch('update_user_profile.php', {
            method: 'POST',
            body: formData
        });
        
        const data = await response.json();
        
        if (data.status === 'success') {
            showNotification('Profile updated successfully!', 'success');
            // Refresh the personal information section
            loadSectionContent('personal');
        } else {
            showNotification(data.message || 'Error updating profile', 'error');
        }
    } catch (error) {
        console.error('Error:', error);
        showNotification('Error updating profile', 'error');
    } finally {
        submitBtn.innerHTML = originalText;
        submitBtn.disabled = false;
    }
}

async function handleChangeEmail(e) {
    e.preventDefault();
    
    const formData = new FormData(e.target);
    const submitBtn = e.target.querySelector('button[type="submit"]');
    const originalText = submitBtn.innerHTML;
    
    // Validate verification code
    const verificationCode = formData.get('verification_code');
    if (!verificationCode || verificationCode.length !== 6) {
        showNotification('Please enter a valid 6-digit verification code', 'error');
        return;
    }
    
    try {
        submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Changing Email...';
        submitBtn.disabled = true;
        
        const response = await fetch('change_email.php', {
            method: 'POST',
            body: formData
        });
        
        const data = await response.json();
        
        if (data.status === 'success') {
            showNotification('Email changed successfully! Please check your new email for verification.', 'success');
            e.target.reset();
            // Update the current email display
            document.getElementById('currentEmail').value = formData.get('new_email');
        } else {
            showNotification(data.message || 'Error changing email', 'error');
        }
    } catch (error) {
        console.error('Error:', error);
        showNotification('Error changing email', 'error');
    } finally {
        submitBtn.innerHTML = originalText;
        submitBtn.disabled = false;
    }
}

async function handleChangePassword(e) {
    e.preventDefault();
    
    const formData = new FormData(e.target);
    const submitBtn = e.target.querySelector('button[type="submit"]');
    const originalText = submitBtn.innerHTML;
    
    // Validate passwords
    const newPassword = formData.get('new_password');
    const confirmPassword = formData.get('confirm_password');
    
    if (newPassword.length < 8) {
        showNotification('Password must be at least 8 characters long', 'error');
        return;
    }
    
    if (newPassword !== confirmPassword) {
        showNotification('New passwords do not match', 'error');
        return;
    }
    
    try {
        submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Changing Password...';
        submitBtn.disabled = true;
        
        const response = await fetch('change_password.php', {
            method: 'POST',
            body: formData
        });
        
        const data = await response.json();
        
        if (data.status === 'success') {
            showNotification('Password changed successfully!', 'success');
            e.target.reset();
        } else {
            showNotification(data.message || 'Error changing password', 'error');
        }
    } catch (error) {
        console.error('Error:', error);
        showNotification('Error changing password', 'error');
    } finally {
        submitBtn.innerHTML = originalText;
        submitBtn.disabled = false;
    }
}

async function sendEmailVerification() {
    const newEmail = document.getElementById('newEmail').value;
    const sendBtn = document.querySelector('button[onclick="sendEmailVerification()"]');
    const originalText = sendBtn.innerHTML;
    
    if (!newEmail || !newEmail.includes('@')) {
        showNotification('Please enter a valid email address', 'error');
        return;
    }
    
    try {
        sendBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Sending...';
        sendBtn.disabled = true;
        
        const formData = new FormData();
        formData.append('new_email', newEmail);
        
        const response = await fetch('send_email_verification.php', {
            method: 'POST',
            body: formData
        });
        
        const data = await response.json();
        
        if (data.status === 'success') {
            showNotification('Verification code sent to your new email address!', 'success');
        } else {
            showNotification(data.message || 'Error sending verification code', 'error');
        }
    } catch (error) {
        console.error('Error:', error);
        showNotification('Error sending verification code', 'error');
    } finally {
        sendBtn.innerHTML = originalText;
        sendBtn.disabled = false;
    }
}

function showNotification(message, type = 'info') {
    // Create notification element
    const notification = document.createElement('div');
    notification.className = `notification notification-${type}`;
    notification.innerHTML = `
        <div class="notification-content">
            <i class="fas fa-${type === 'success' ? 'check-circle' : type === 'error' ? 'exclamation-circle' : 'info-circle'}"></i>
            <span>${message}</span>
        </div>
        <button class="notification-close" onclick="this.parentElement.remove()">
            <i class="fas fa-times"></i>
        </button>
    `;
    
    // Add to page
    document.body.appendChild(notification);
    
    // Auto remove after 5 seconds
    setTimeout(() => {
        if (notification.parentElement) {
            notification.remove();
        }
    }, 5000);
}

// Add some additional styling for the dynamic content
const style = document.createElement('style');
style.textContent = `
    .section-content {
        width: 100%;
        max-width: 800px;
        margin: 0 auto;
    }
    
    .section-content h2 {
        color: #333;
        margin-bottom: 30px;
        text-align: center;
        font-size: 28px;
        font-weight: 600;
    }
    
    .info-grid, .settings-grid {
        display: grid;
        gap: 0;
        background: white;
        padding: 30px;
        border-radius: 10px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        overflow: hidden;
    }
    
    .info-item, .setting-item {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 20px 0;
        border-bottom: 1px solid #eee;
    }
    
    .info-item:last-child, .setting-item:last-child {
        border-bottom: none;
    }
    
    .info-item label {
        font-weight: 600;
        color: #555;
        font-size: 16px;
    }
    
    .info-item span {
        color: #333;
        font-size: 16px;
    }
    
    .setting-item label {
        font-weight: 500;
        color: #555;
        font-size: 16px;
    }
    
    .setting-item input[type="checkbox"] {
        width: 20px;
        height: 20px;
        accent-color: #1e3a8a;
    }
    
    .setting-info {
        display: flex;
        flex-direction: column;
        gap: 5px;
    }
    
    .setting-info small {
        color: #666;
        font-size: 14px;
        font-style: italic;
    }
    
    .btn {
        padding: 10px 20px;
        border: none;
        border-radius: 8px;
        cursor: pointer;
        font-size: 14px;
        font-weight: 500;
        transition: all 0.3s ease;
        display: flex;
        align-items: center;
        gap: 8px;
    }
    
    .btn-deactivate {
        background: #dc3545;
        color: white;
    }
    
    .btn-deactivate:hover {
        background: #c82333;
        transform: translateY(-2px);
    }
    
    .history-list {
        background: white;
        border-radius: 10px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        overflow: hidden;
    }
    
    .history-item {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 20px 30px;
        border-bottom: 1px solid #eee;
    }
    
    .history-item:last-child {
        border-bottom: none;
    }
    
    .order-info {
        display: flex;
        flex-direction: column;
        gap: 5px;
    }
    
    .order-info strong {
        color: #333;
        font-size: 16px;
    }
    
    .order-info span {
        color: #666;
        font-size: 14px;
    }
    
    .order-status {
        background: #e8f5e8;
        color: #2d5a2d;
        padding: 8px 16px;
        border-radius: 20px;
        font-size: 14px;
        font-weight: 500;
    }
    
    /* Status Section Styles */
    .status-info {
        background: white;
        border-radius: 10px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        overflow: hidden;
    }
    
    .status-card {
        padding: 30px;
        border-bottom: 1px solid #eee;
    }
    
    .status-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 20px;
    }
    
    .status-header h3 {
        margin: 0;
        color: #333;
        font-size: 20px;
    }
    
    .status-badge {
        padding: 8px 16px;
        border-radius: 20px;
        font-size: 14px;
        font-weight: 500;
        text-transform: capitalize;
    }
    
    .status-active {
        background: #e8f5e8;
        color: #2d5a2d;
    }
    
    .status-deactivated {
        background: #fff3cd;
        color: #856404;
    }
    
    .status-blocked {
        background: #f8d7da;
        color: #721c24;
    }
    
    .status-description p {
        color: #666;
        font-size: 16px;
        line-height: 1.6;
        margin: 0;
    }
    
    .status-actions {
        padding: 30px;
    }
    
    .status-actions h3 {
        margin: 0 0 20px 0;
        color: #333;
        font-size: 20px;
    }
    
    .status-list {
        list-style: none;
        padding: 0;
        margin: 0 0 20px 0;
    }
    
    .status-list li {
        padding: 10px 0;
        border-bottom: 1px solid #eee;
        color: #666;
        font-size: 16px;
        line-height: 1.6;
    }
    
    .status-list li:last-child {
        border-bottom: none;
    }
    
    .status-list strong {
        color: #333;
    }
    
    .status-note {
        background: #f8f9fa;
        padding: 20px;
        border-radius: 8px;
        border-left: 4px solid #1e3a8a;
    }
    
    .status-note p {
        margin: 0;
        color: #495057;
        font-size: 14px;
        line-height: 1.6;
    }
    
    /* Error Message Styles */
    .error-message {
        background: #f8d7da;
        border: 1px solid #f5c6cb;
        border-radius: 8px;
        padding: 20px;
        text-align: center;
        color: #721c24;
    }
    
    .error-message p {
        margin: 0;
        font-size: 16px;
    }
    
    /* Settings Container Styles */
    .settings-container {
        display: flex;
        flex-direction: column;
        gap: 30px;
    }
    
    .settings-section {
        background: white;
        border-radius: 10px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        overflow: hidden;
    }
    
    .settings-section h3 {
        background: #f8f9fa;
        margin: 0;
        padding: 20px 30px;
        border-bottom: 1px solid #eee;
        color: #333;
        font-size: 18px;
        display: flex;
        align-items: center;
        gap: 10px;
    }
    
    .edit-form {
        padding: 30px;
    }
    
    .form-row {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 20px;
    }
    
    .form-group {
        margin-bottom: 20px;
    }
    
    .form-group label {
        display: block;
        margin-bottom: 8px;
        font-weight: 600;
        color: #333;
        font-size: 14px;
    }
    
    .form-group input,
    .form-group select {
        width: 100%;
        padding: 12px;
        border: 1px solid #ddd;
        border-radius: 5px;
        font-size: 14px;
        transition: border-color 0.3s ease;
    }
    
    .form-group input:focus,
    .form-group select:focus {
        outline: none;
        border-color: #1e3a8a;
        box-shadow: 0 0 0 2px rgba(30, 58, 138, 0.1);
    }
    
    .form-group input[readonly] {
        background-color: #f8f9fa;
        color: #666;
    }
    
    .verification-group {
        display: flex;
        gap: 10px;
    }
    
    .verification-group input {
        flex: 1;
    }
    
    .verification-group button {
        white-space: nowrap;
    }
    
    .password-requirements {
        color: #666;
        font-size: 12px;
        margin-top: 5px;
        display: block;
    }
    
    .form-actions {
        margin-top: 30px;
        display: flex;
        justify-content: flex-end;
    }
    
    .btn-primary {
        background: #1e3a8a;
        color: white;
    }
    
    .btn-primary:hover {
        background: #1e40af;
        transform: translateY(-2px);
    }
    
    .btn-secondary {
        background: #6c757d;
        color: white;
    }
    
    .btn-secondary:hover {
        background: #5a6268;
    }
    
    .deactivation-info {
        padding: 20px 30px;
        background: #fff3cd;
        border: 1px solid #ffeaa7;
        margin: 0 30px 20px 30px;
        border-radius: 5px;
    }
    
    .deactivation-info p {
        margin: 0 0 10px 0;
        color: #856404;
        font-weight: 600;
    }
    
    .deactivation-info ul {
        margin: 0;
        padding-left: 20px;
        color: #856404;
    }
    
    .deactivation-info li {
        margin-bottom: 5px;
    }
    
    /* Notification Styles */
    .notification {
        position: fixed;
        top: 20px;
        right: 20px;
        background: white;
        border-radius: 8px;
        box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        padding: 15px 20px;
        display: flex;
        align-items: center;
        gap: 15px;
        z-index: 10000;
        min-width: 300px;
        max-width: 400px;
        animation: slideIn 0.3s ease;
    }
    
    .notification-success {
        border-left: 4px solid #28a745;
    }
    
    .notification-error {
        border-left: 4px solid #dc3545;
    }
    
    .notification-info {
        border-left: 4px solid #17a2b8;
    }
    
    .notification-content {
        display: flex;
        align-items: center;
        gap: 10px;
        flex: 1;
    }
    
    .notification-content i {
        font-size: 18px;
    }
    
    .notification-success .notification-content i {
        color: #28a745;
    }
    
    .notification-error .notification-content i {
        color: #dc3545;
    }
    
    .notification-info .notification-content i {
        color: #17a2b8;
    }
    
    .notification-close {
        background: none;
        border: none;
        color: #666;
        cursor: pointer;
        padding: 5px;
        border-radius: 3px;
        transition: background-color 0.3s ease;
    }
    
    .notification-close:hover {
        background-color: #f8f9fa;
    }
    
    @keyframes slideIn {
        from {
            transform: translateX(100%);
            opacity: 0;
        }
        to {
            transform: translateX(0);
            opacity: 1;
        }
    }
    
    /* Modal Styles */
    .modal {
        display: none;
        position: fixed;
        z-index: 1000;
        left: 0;
        top: 0;
        width: 100%;
        height: 100%;
        background-color: rgba(0,0,0,0.5);
    }
    
    .modal-content {
        background-color: white;
        margin: 5% auto;
        padding: 0;
        border-radius: 10px;
        width: 90%;
        max-width: 500px;
        box-shadow: 0 10px 30px rgba(0,0,0,0.3);
    }
    
    .modal-header {
        background: #dc3545;
        color: white;
        padding: 20px;
        border-radius: 10px 10px 0 0;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }
    
    .modal-header h3 {
        margin: 0;
        font-size: 18px;
        display: flex;
        align-items: center;
        gap: 10px;
    }
    
    .close {
        color: white;
        font-size: 28px;
        font-weight: bold;
        cursor: pointer;
        transition: opacity 0.3s ease;
    }
    
    .close:hover {
        opacity: 0.7;
    }
    
    .modal-body {
        padding: 20px;
    }
    
    .warning-message {
        background: #fff3cd;
        border: 1px solid #ffeaa7;
        border-radius: 8px;
        padding: 15px;
        margin-bottom: 20px;
    }
    
    .warning-message p {
        margin: 0 0 10px 0;
        color: #856404;
        font-weight: 600;
    }
    
    .warning-message ul {
        margin: 0;
        padding-left: 20px;
        color: #856404;
    }
    
    .warning-message li {
        margin-bottom: 5px;
    }
    
    .form-group {
        margin-bottom: 20px;
    }
    
    .form-group label {
        display: block;
        margin-bottom: 8px;
        font-weight: 600;
        color: #333;
    }
    
    .form-group textarea {
        width: 100%;
        padding: 12px;
        border: 1px solid #ddd;
        border-radius: 5px;
        font-size: 14px;
        resize: vertical;
    }
    
    .form-actions {
        display: flex;
        gap: 10px;
        justify-content: flex-end;
    }
    
    .btn-cancel {
        background: #6c757d;
        color: white;
    }
    
    .btn-cancel:hover {
        background: #5a6268;
    }
`;
document.head.appendChild(style);
