// User Profile Page JavaScript

// Global functions for fetching data
    async function fetchUserProfileData() {
        try {
            // Get user data from localStorage
            const userData = JSON.parse(localStorage.getItem('userData'));
            if (!userData || !userData.id) {
                console.error('User data not found in localStorage');
                return null;
            }
            
            const formData = new FormData();
            formData.append('user_id', userData.id);
            
            const response = await fetch('get_user_profile.php', {
                method: 'POST',
                body: formData
            });
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

    // Function to fetch user addresses from database
    async function fetchUserAddresses() {
        try {
            // Get user data from localStorage
            const userData = JSON.parse(localStorage.getItem('userData'));
            if (!userData || !userData.id) {
                console.error('User data not found in localStorage');
                return [];
            }
            
            const formData = new FormData();
            formData.append('user_id', userData.id);
            
            const response = await fetch('get_user_addresses.php', {
                method: 'POST',
                body: formData
            });
            const data = await response.json();
            
            if (data.status === 'success') {
                return data.addresses;
            } else {
                console.error('Error fetching addresses:', data.message);
                return [];
            }
        } catch (error) {
            console.error('Error fetching addresses:', error);
            return [];
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

document.addEventListener('DOMContentLoaded', function() {
    console.log('=== DOM LOADED ===');
    
    // Check if user is logged in
    const userData = JSON.parse(localStorage.getItem('userData') || 'null');
    console.log('User data from localStorage:', userData);
    
    if (!userData || !userData.id) {
        console.error('❌ No user data found in localStorage!');
        console.log('localStorage contents:', localStorage);
    } else {
        console.log('✅ User authenticated with ID:', userData.id);
    }
    
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
// Avatar upload handlers
function attachAvatarUploadListeners() {
    const chooseBtn = document.getElementById('chooseAvatarBtn');
    const fileInput = document.getElementById('avatarFileInput');
    const form = document.getElementById('avatarUploadForm');
    const previewImg = document.getElementById('avatarPreviewImg');
    const uploadBtn = document.getElementById('uploadAvatarBtn');

    if (!form || !fileInput || !chooseBtn || !previewImg || !uploadBtn) return;

    chooseBtn.onclick = function() { fileInput.click(); };

    fileInput.onchange = function(e) {
        const file = e.target.files && e.target.files[0];
        if (!file) return;
        if (!/^image\/(jpeg|png|webp)$/.test(file.type)) {
            showNotification('Only JPG, PNG, or WEBP images are allowed', 'error');
            fileInput.value = '';
            return;
        }
        if (file.size > 5 * 1024 * 1024) {
            showNotification('Image is too large (max 5MB)', 'error');
            fileInput.value = '';
            return;
        }
        const reader = new FileReader();
        reader.onload = function(evt) {
            previewImg.src = evt.target.result;
        };
        reader.readAsDataURL(file);
    };

    form.onsubmit = async function(e) {
        e.preventDefault();
        if (!fileInput.files || !fileInput.files[0]) {
            showNotification('Please choose an image first', 'error');
            return;
        }
        const original = uploadBtn.innerHTML;
        uploadBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Uploading...';
        uploadBtn.disabled = true;
        try {
            const fd = new FormData();
            fd.append('avatar', fileInput.files[0]);
            const resp = await fetch('upload_avatar.php', { method: 'POST', body: fd });
            const data = await resp.json();
            if (data.status === 'success') {
                showNotification('Profile picture updated!', 'success');
                // Update sidebar avatar
                const imgEl = document.querySelector('#userImageContainer img');
                if (imgEl && data.avatar) {
                    imgEl.src = data.avatar;
                }
                // Update localStorage
                const ls = JSON.parse(localStorage.getItem('userData') || 'null');
                if (ls && data.avatar) {
                    // strip cache bust for storage
                    const baseUrl = data.avatar.split('?')[0];
                    ls.avatar = baseUrl;
                    localStorage.setItem('userData', JSON.stringify(ls));
                }
            } else {
                showNotification(data.message || 'Failed to update avatar', 'error');
            }
        } catch (err) {
            console.error(err);
            showNotification('Error uploading image', 'error');
        } finally {
            uploadBtn.innerHTML = original;
            uploadBtn.disabled = false;
        }
    };
}


// Global function to load section content
    async function loadSectionContent(section) {
        console.log('Loading section:', section);
        const mainContent = document.querySelector('.main-content');
        let content = '';
        
        try {
            switch(section) {
                case 'personal':
                    console.log('=== LOADING PERSONAL INFORMATION ===');
                    // Fetch user data for personal information
                    const userData = await fetchUserProfileData();
                    const userAddresses = await fetchUserAddresses();
                    
                    console.log('User data:', userData);
                    console.log('User addresses:', userAddresses);
                
                if (userData) {
                    const fullName = `${userData.f_name || ''} ${userData.l_name || ''}`.trim() || 'Not provided';
                    const email = userData.email || 'Not provided';
                    const phone = userData.phone_no || 'Not provided';
                    const dateOfBirth = formatDate(userData.birthdate);
                    const gender = userData.gender || 'Not provided';
                    const loyaltyPoints = userData.loyalty_points || 0;
                    
                    // Generate addresses HTML
                    let addressesHTML = '';
                    if (userAddresses && userAddresses.length > 0) {
                        addressesHTML = `
                            <div class="info-item addresses-section">
                                <label>Addresses:</label>
                                <div class="addresses-list">
                                    ${userAddresses.map(address => `
                                        <div class="address-item">
                                            <div class="address-header">
                                                <span class="address-title">${address.title}</span>
                                                <span class="address-accuracy ${address.location_accuracy}">${address.location_accuracy}</span>
                                                <span class="address-date">${formatDate(address.created_at)}</span>
                                            </div>
                                            <div class="address-details">
                                                <p>${address.address1}</p>
                                                ${address.address2 && address.address2.trim() !== '' ? `<p>${address.address2}</p>` : ''}
                                                <p>${address.city}, ${address.country} ${address.postal_code}</p>
                                                <p class="coordinates">📍 ${address.latitude}, ${address.longitude}</p>
                                            </div>
                                        </div>
                                    `).join('')}
                                </div>
                            </div>
                        `;
                    } else {
                        addressesHTML = `
                            <div class="info-item">
                                <label>Addresses:</label>
                                <span>No addresses found</span>
                            </div>
                        `;
                    }
                    
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
                                ${addressesHTML}
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
                                <!-- Change Profile Picture Section -->
                                <div class="settings-section">
                                    <h3><i class="fas fa-image"></i> Change Profile Picture</h3>
                                    <form id="avatarUploadForm" class="edit-form" enctype="multipart/form-data">
                                        <div class="avatar-upload">
                                            <div class="avatar-preview">
                                                <img id="avatarPreviewImg" src="${(settingsUserData.avatar && settingsUserData.avatar.trim() !== '' ? settingsUserData.avatar : 'uploads/avatar.png')}" alt="Current Avatar" onerror="this.onerror=null;this.src='uploads/avatar.png';">
                                            </div>
                                            <div class="avatar-actions">
                                                <input type="file" id="avatarFileInput" name="avatar" accept="image/*" style="display:none;" />
                                                <button type="button" class="btn btn-secondary" id="chooseAvatarBtn"><i class="fas fa-upload"></i> Choose Image</button>
                                                <button type="submit" class="btn btn-primary" id="uploadAvatarBtn"><i class="fas fa-cloud-upload-alt"></i> Upload</button>
                                            </div>
                                            <small class="form-help">Allowed: JPG, PNG, WEBP. Max size 5MB.</small>
                                        </div>
                                    </form>
                                </div>
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
                                                <input type="tel" id="editPhone" name="phone" value="${settingsUserData.phone_no || ''}">
                                            </div>
                                            <div class="form-group">
                                                <label for="editBirthdate">Date of Birth</label>
                                                <input type="date" id="editBirthdate" name="birthdate" value="${settingsUserData.birthdate || ''}">
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

                                <!-- Address Management Section -->
                                <div class="settings-section">
                                    <h3><i class="fas fa-map-marker-alt"></i> Manage Addresses</h3>
                                    <div class="addresses-management">
                                        <div class="addresses-list-settings">
                                            <h4>Your Addresses</h4>
                                            <div id="addressesListSettings" class="addresses-list">
                                                <!-- Addresses will be loaded here -->
                                            </div>
                                            <button type="button" class="btn btn-secondary" onclick="showAddAddressForm()">
                                                <i class="fas fa-plus"></i> Add New Address
                                            </button>
                                        </div>
                                        
                                        <!-- Add/Edit Address Form -->
                                        <div id="addressFormContainer" class="address-form-container" style="display: none;">
                                            <h4 id="addressFormTitle">Add New Address</h4>
                                            <form id="addressForm" class="edit-form">
                                                <input type="hidden" id="addressId" name="address_id">
                                                <input type="hidden" id="latitude" name="latitude">
                                                <input type="hidden" id="longitude" name="longitude">
                                                <input type="hidden" id="user_id" name="user_id">
                                                <div class="form-row">
                                                    <div class="form-group">
                                                        <label for="addressTitle">Address Title *</label>
                                                        <select id="addressTitle" name="title" required>
                                                            <option value="">Select Title</option>
                                                            <option value="Home">Home</option>
                                                            <option value="Work">Work</option>
                                                            <option value="Parents">Parents</option>
                                                            <option value="Vacation">Vacation</option>
                                                            <option value="Office">Office</option>
                                                            <option value="Gym">Gym</option>
                                                            <option value="Friend's House">Friend's House</option>
                                                            <option value="Delivery Point">Delivery Point</option>
                                                            <option value="Other">Other</option>
                                                        </select>
                                                    </div>
                                                    <div class="form-group">
                                                        <label for="addressCountry">Country *</label>
                                                        <select id="addressCountry" name="country" required>
                                                            <option value="">Select Country</option>
                                                            <option value="Egypt">Egypt</option>
                                                            <option value="United States">United States</option>
                                                            <option value="United Kingdom">United Kingdom</option>
                                                            <option value="Canada">Canada</option>
                                                            <option value="Germany">Germany</option>
                                                            <option value="France">France</option>
                                                            <option value="Italy">Italy</option>
                                                            <option value="Spain">Spain</option>
                                                            <option value="Australia">Australia</option>
                                                            <option value="Japan">Japan</option>
                                                            <option value="China">China</option>
                                                            <option value="India">India</option>
                                                            <option value="Brazil">Brazil</option>
                                                            <option value="Mexico">Mexico</option>
                                                            <option value="South Africa">South Africa</option>
                                                            <option value="Saudi Arabia">Saudi Arabia</option>
                                                            <option value="UAE">UAE</option>
                                                            <option value="Turkey">Turkey</option>
                                                            <option value="Russia">Russia</option>
                                                        </select>
                                                    </div>
                                                </div>
                                                <div class="form-group">
                                                    <label for="addressLine1">Address Line 1 *</label>
                                                    <input type="text" id="addressLine1" name="address1" placeholder="Street address, P.O. box, company name" required>
                                                </div>
                                                <div class="form-group">
                                                    <label for="addressLine2">Address Line 2 (Optional)</label>
                                                    <input type="text" id="addressLine2" name="address2" placeholder="Apartment, suite, unit, building, floor, etc.">
                                                    <small class="form-help">This field will be automatically cleared when using map location</small>
                                                </div>
                                                <div class="form-row">
                                                    <div class="form-group">
                                                        <label for="addressCity">City *</label>
                                                        <input type="text" id="addressCity" name="city" required>
                                                    </div>
                                                    <div class="form-group">
                                                        <label for="addressPostalCode">Postal Code *</label>
                                                        <input type="text" id="addressPostalCode" name="postal_code" required>
                                                    </div>
                                                </div>
                                                
                                                <!-- Map Location Section -->
                                                <div class="form-group">
                                                    <label for="mapLocation">Set Location on Map *</label>
                                                    <div class="map-info">
                                                        <small class="form-help">
                                                            <i class="fas fa-info-circle"></i> 
                                                            Click on the map to set your location. Address fields will be automatically filled based on the selected coordinates.
                                                        </small>
                                                    </div>
                                                    <div class="map-container">
                                                        <div id="map" class="map-preview"></div>
                                                        <div class="map-controls">
                                                            <button type="button" class="btn btn-secondary" onclick="openMapModal()">
                                                                <i class="fas fa-map"></i> Open Full Map
                                                            </button>
                                                            <button type="button" class="btn btn-info" onclick="autoFillFromCurrentLocation()" title="Use current GPS location">
                                                                <i class="fas fa-crosshairs"></i> Use GPS
                                                            </button>
                                                            <span class="coordinates-display">
                                                                Lat: <span id="selectedLat">Not set</span>, 
                                                                Lng: <span id="selectedLng">Not set</span>
                                                            </span>
                                                        </div>
                                                    </div>
                                                </div>
                                                
                                                <div class="form-actions">
                                                    <button type="button" class="btn btn-cancel" onclick="cancelAddressForm()">
                                                        <i class="fas fa-times"></i> Cancel
                                                    </button>
                                                    <button type="submit" class="btn btn-primary">
                                                        <i class="fas fa-save"></i> Save Address
                                                    </button>
                                                </div>
                                            </form>
                                        </div>
                                    </div>
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
        
        if (mainContent) {
            mainContent.innerHTML = content;
            
            // If status section is loaded, update the status display
            if (section === 'status') {
                updateStatusDisplay();
            }
            
                    // If settings section is loaded, load addresses and attach form listener
        if (section === 'settings') {
            setTimeout(() => {
                loadAddressesInSettings();
                // Only attach listener if not already attached
                if (!document.getElementById('addressForm')?.hasAttribute('data-listener-attached')) {
                    attachAddressFormListener();
                }
                // Attach avatar upload listeners
                attachAvatarUploadListeners();
            }, 100);
        }
        }
    } catch (error) {
        console.error('Error loading section content:', error);
        if (mainContent) {
            mainContent.innerHTML = `
                <div class="content-placeholder">
                    <h2>Error Loading Content</h2>
                    <p>There was an error loading the requested section. Please try again.</p>
                    <p class="error-details">${error.message}</p>
                </div>
            `;
        }
    }
}

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

// Function to hash password using SHA-256
async function hashPassword(password) {
    const encoder = new TextEncoder();
    const data = encoder.encode(password);
    const hashBuffer = await crypto.subtle.digest('SHA-256', data);
    const hashArray = Array.from(new Uint8Array(hashBuffer));
    const hashHex = hashArray.map(b => b.toString(16).padStart(2, '0')).join('');
    return hashHex;
}

async function handleChangePassword(e) {
    e.preventDefault();
    
    const formData = new FormData(e.target);
    const submitBtn = e.target.querySelector('button[type="submit"]');
    const originalText = submitBtn.innerHTML;
    
    // Validate passwords
    const newPassword = formData.get('new_password');
    const confirmPassword = formData.get('confirm_password');
    const currentPassword = formData.get('current_password');
    
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
        
        // Hash passwords on client side
        const hashedCurrentPassword = await hashPassword(currentPassword);
        const hashedNewPassword = await hashPassword(newPassword);
        
        // Update form data with hashed passwords
        formData.set('current_password', hashedCurrentPassword);
        formData.set('new_password', hashedNewPassword);
        
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

// Address Management Functions
let map, marker;
let selectedLatitude = null;
let selectedLongitude = null;

// Load addresses in settings section
async function loadAddressesInSettings() {
    const addressesList = document.getElementById('addressesListSettings');
    if (!addressesList) return;
    
    try {
        const addresses = await fetchUserAddresses();
        if (addresses && addresses.length > 0) {
            addressesList.innerHTML = addresses.map(address => `
                <div class="address-item">
                    <div class="address-header">
                        <span class="address-title">${address.title}</span>
                        <div class="address-actions">
                            <button type="button" class="btn btn-small btn-primary" onclick="editAddress(${address.id})">
                                <i class="fas fa-edit"></i>
                            </button>
                            <button type="button" class="btn btn-small btn-danger" onclick="deleteAddress(${address.id})">
                                <i class="fas fa-trash"></i>
                            </button>
                        </div>
                    </div>
                    <div class="address-details">
                        <p>${address.address1}</p>
                        ${address.address2 ? `<p>${address.address2}</p>` : ''}
                        <p>${address.city}, ${address.country} ${address.postal_code}</p>
                    </div>
                </div>
            `).join('');
        } else {
            addressesList.innerHTML = '<p class="no-addresses">No addresses found. Add your first address!</p>';
        }
    } catch (error) {
        console.error('Error loading addresses:', error);
        addressesList.innerHTML = '<p class="error-message">Error loading addresses. Please try again.</p>';
    }
}

// Show add address form
function showAddAddressForm() {
    document.getElementById('addressFormContainer').style.display = 'block';
    document.getElementById('addressFormTitle').textContent = 'Add New Address';
    document.getElementById('addressForm').reset();
    document.getElementById('addressId').value = '';
    document.getElementById('latitude').value = '';
    document.getElementById('longitude').value = '';
    selectedLatitude = null;
    selectedLongitude = null;
    updateCoordinatesDisplay();
    initializeMap();
    
    // Attach form listener
    attachAddressFormListener();
}

// Show edit address form
async function editAddress(addressId) {
    try {
        const addresses = await fetchUserAddresses();
        const address = addresses.find(addr => addr.id == addressId);
        
        if (address) {
            document.getElementById('addressFormContainer').style.display = 'block';
            document.getElementById('addressFormTitle').textContent = 'Edit Address';
            document.getElementById('addressId').value = address.id;
            document.getElementById('addressTitle').value = address.title;
            document.getElementById('addressCountry').value = address.country;
            document.getElementById('addressLine1').value = address.address1;
            document.getElementById('addressLine2').value = address.address2;
            document.getElementById('addressCity').value = address.city;
            document.getElementById('addressPostalCode').value = address.postal_code;
            
            // Set coordinates if available
            if (address.latitude && address.longitude) {
                selectedLatitude = parseFloat(address.latitude);
                selectedLongitude = parseFloat(address.longitude);
                document.getElementById('latitude').value = selectedLatitude;
                document.getElementById('longitude').value = selectedLongitude;
                updateCoordinatesDisplay();
                initializeMap();
            } else {
                selectedLatitude = null;
                selectedLongitude = null;
                document.getElementById('latitude').value = '';
                document.getElementById('longitude').value = '';
                updateCoordinatesDisplay();
                initializeMap();
            }
            
            // Attach form listener
            attachAddressFormListener();
        }
    } catch (error) {
        console.error('Error loading address for edit:', error);
        alert('Error loading address details. Please try again.');
    }
}

// Cancel address form
function cancelAddressForm() {
    document.getElementById('addressFormContainer').style.display = 'none';
    document.getElementById('addressForm').reset();
}

// Initialize map
function initializeMap() {
    const mapDiv = document.getElementById('map');
    if (!mapDiv) return;
    
    // Default coordinates (Cairo, Egypt)
    const defaultLat = selectedLatitude || 30.0444;
    const defaultLng = selectedLongitude || 31.2357;
    
    // Create map using Leaflet (free alternative to Google Maps)
    if (map) {
        map.remove();
    }
    
    map = L.map('map').setView([defaultLat, defaultLng], 13);
    
    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: '© OpenStreetMap contributors'
    }).addTo(map);
    
    // Add marker if coordinates are set
    if (selectedLatitude && selectedLongitude) {
        marker = L.marker([selectedLatitude, selectedLongitude]).addTo(map);
    }
    
    // Add click event to set location
    map.on('click', function(e) {
        if (marker) {
            map.removeLayer(marker);
        }
        marker = L.marker(e.latlng).addTo(map);
        selectedLatitude = e.latlng.lat;
        selectedLongitude = e.latlng.lng;
        
        // Update hidden form fields
        document.getElementById('latitude').value = selectedLatitude;
        document.getElementById('longitude').value = selectedLongitude;
        
        updateCoordinatesDisplay();
        
        // Auto-fill address fields
        autoFillAddressFromCoordinates(e.latlng.lat, e.latlng.lng);
    });
}

// Update coordinates display
function updateCoordinatesDisplay() {
    const latSpan = document.getElementById('selectedLat');
    const lngSpan = document.getElementById('selectedLng');
    
    if (latSpan && lngSpan) {
        if (selectedLatitude && selectedLongitude) {
            latSpan.textContent = selectedLatitude.toFixed(6);
            lngSpan.textContent = selectedLongitude.toFixed(6);
        } else {
            latSpan.textContent = 'Not set';
            lngSpan.textContent = 'Not set';
        }
    }
}

// Open full map modal
function openMapModal() {
    // Create modal for full map
    const modal = document.createElement('div');
    modal.className = 'modal';
    modal.id = 'mapModal';
    modal.innerHTML = `
        <div class="modal-content" style="max-width: 800px; height: 600px;">
            <div class="modal-header">
                <h3><i class="fas fa-map"></i> Set Location on Map</h3>
                <span class="close" onclick="closeMapModal()">&times;</span>
            </div>
            <div class="modal-body" style="height: 500px; padding: 0;">
                <div id="fullMap" style="width: 100%; height: 100%;"></div>
            </div>
        </div>
    `;
    
    document.body.appendChild(modal);
    modal.style.display = 'block';
    
    // Initialize full map
    setTimeout(() => {
        const fullMapDiv = document.getElementById('fullMap');
        const fullMap = L.map('fullMap').setView([selectedLatitude || 30.0444, selectedLongitude || 31.2357], 10);
        
        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
            attribution: '© OpenStreetMap contributors'
        }).addTo(fullMap);
        
        if (selectedLatitude && selectedLongitude) {
            L.marker([selectedLatitude, selectedLongitude]).addTo(fullMap);
        }
        
        fullMap.on('click', function(e) {
            fullMap.eachLayer((layer) => {
                if (layer instanceof L.Marker) {
                    fullMap.removeLayer(layer);
                }
            });
            L.marker(e.latlng).addTo(fullMap);
            selectedLatitude = e.latlng.lat;
            selectedLongitude = e.latlng.lng;
            updateCoordinatesDisplay();
            
            // Auto-fill address fields
            autoFillAddressFromCoordinates(e.latlng.lat, e.latlng.lng);
        });
    }, 100);
}

// Close map modal
function closeMapModal() {
    const modal = document.getElementById('mapModal');
    if (modal) {
        modal.remove();
    }
}

// Auto-fill address fields from coordinates
async function autoFillAddressFromCoordinates(lat, lng) {
    try {
        // Show loading state
        const address1Field = document.getElementById('addressLine1');
        const cityField = document.getElementById('addressCity');
        const countryField = document.getElementById('addressCountry');
        const postalCodeField = document.getElementById('addressPostalCode');
        
        if (!address1Field || !cityField || !countryField || !postalCodeField) {
            return;
        }
        
        // Add loading indicator
        address1Field.placeholder = 'Loading address...';
        cityField.placeholder = 'Loading city...';
        countryField.placeholder = 'Loading country...';
        postalCodeField.placeholder = 'Loading postal code...';
        
        // Fetch address data from coordinates
        const response = await fetch(`reverse_geocode.php?lat=${lat}&lon=${lng}`);
        const data = await response.json();
        
        if (data.status === 'success') {
            // Fill in the address fields
            address1Field.value = data.address.address1 || '';
            cityField.value = data.address.city || '';
            countryField.value = data.address.country || '';
            postalCodeField.value = data.address.postal_code || '';
            
            // Clear address2 field
            const address2Field = document.getElementById('addressLine2');
            if (address2Field) {
                address2Field.value = '';
            }
            
            // Update country dropdown if it matches
            if (data.address.country) {
                const countrySelect = document.getElementById('addressCountry');
                if (countrySelect) {
                    for (let option of countrySelect.options) {
                        if (option.value.toLowerCase() === data.address.country.toLowerCase()) {
                            option.selected = true;
                            break;
                        }
                    }
                }
            }
            
            // Show success message
            showAddressAutoFillMessage('Address auto-filled successfully!', 'success');
        } else {
            showAddressAutoFillMessage('Could not auto-fill address. Please enter manually.', 'warning');
        }
        
    } catch (error) {
        console.error('Error auto-filling address:', error);
        showAddressAutoFillMessage('Error auto-filling address. Please enter manually.', 'error');
    } finally {
        // Reset placeholders
        const address1Field = document.getElementById('addressLine1');
        const cityField = document.getElementById('addressCity');
        const countryField = document.getElementById('addressCountry');
        const postalCodeField = document.getElementById('addressPostalCode');
        
        if (address1Field) address1Field.placeholder = 'Street address, P.O. box, company name';
        if (cityField) cityField.placeholder = 'City';
        if (countryField) countryField.placeholder = 'Select Country';
        if (postalCodeField) postalCodeField.placeholder = 'Postal Code';
    }
}

// Auto-fill from current GPS location
function autoFillFromCurrentLocation() {
    if (!navigator.geolocation) {
        showAddressAutoFillMessage('GPS is not supported by your browser.', 'error');
        return;
    }
    
    showAddressAutoFillMessage('Getting your location...', 'info');
    
    navigator.geolocation.getCurrentPosition(
        function(position) {
            const lat = position.coords.latitude;
            const lng = position.coords.longitude;
            
            // Set coordinates
            selectedLatitude = lat;
            selectedLongitude = lng;
            updateCoordinatesDisplay();
            
            // Update map marker
            if (map) {
                if (marker) {
                    map.removeLayer(marker);
                }
                marker = L.marker([lat, lng]).addTo(map);
                map.setView([lat, lng], 15);
            }
            
            // Auto-fill address fields
            autoFillAddressFromCoordinates(lat, lng);
        },
        function(error) {
            let errorMessage = 'Unable to get your location.';
            switch(error.code) {
                case error.PERMISSION_DENIED:
                    errorMessage = 'Location permission denied. Please enable location access.';
                    break;
                case error.POSITION_UNAVAILABLE:
                    errorMessage = 'Location information unavailable.';
                    break;
                case error.TIMEOUT:
                    errorMessage = 'Location request timed out.';
                    break;
            }
            showAddressAutoFillMessage(errorMessage, 'error');
        },
        {
            enableHighAccuracy: true,
            timeout: 10000,
            maximumAge: 60000
        }
    );
}

// Show address auto-fill message
function showAddressAutoFillMessage(message, type) {
    // Remove existing message
    const existingMessage = document.querySelector('.address-auto-fill-message');
    if (existingMessage) {
        existingMessage.remove();
    }
    
    // Create message element
    const messageDiv = document.createElement('div');
    messageDiv.className = `address-auto-fill-message message-${type}`;
    messageDiv.innerHTML = `
        <i class="fas fa-${type === 'success' ? 'check-circle' : type === 'warning' ? 'exclamation-triangle' : 'times-circle'}"></i>
        ${message}
    `;
    
    // Insert after the map container
    const mapContainer = document.querySelector('.map-container');
    if (mapContainer) {
        mapContainer.parentNode.insertBefore(messageDiv, mapContainer.nextSibling);
        
        // Auto-remove after 5 seconds
        setTimeout(() => {
            if (messageDiv.parentNode) {
                messageDiv.remove();
            }
        }, 5000);
    }
}

// Function to attach address form event listener
function attachAddressFormListener() {
    console.log('=== ATTACHING ADDRESS FORM LISTENER ===');
    const addressForm = document.getElementById('addressForm');
    console.log('Address form element found:', addressForm);
    
    if (addressForm) {
        console.log('Address form found, adding event listener...');
        
        // Check if listener is already attached
        if (addressForm.hasAttribute('data-listener-attached')) {
            console.log('✅ Listener already attached, skipping...');
            return true;
        }
        
        // Remove any existing listener first (safety measure)
        addressForm.removeEventListener('submit', handleAddressFormSubmit);
        
        // Add new listener
        addressForm.addEventListener('submit', handleAddressFormSubmit);
        
        // Mark as attached to prevent duplicates
        addressForm.setAttribute('data-listener-attached', 'true');
        
        console.log('✅ Event listener attached successfully');
        return true;
    } else {
        console.log('❌ Address form element NOT found!');
        console.log('Available elements with "address" in ID:', document.querySelectorAll('[id*="address"]'));
        console.log('Available forms:', document.querySelectorAll('form'));
        return false;
    }
}

// Handle address form submission
async function handleAddressFormSubmit(e) {
    e.preventDefault();
    
    console.log('=== FORM SUBMISSION STARTED ===');
    console.log('Form element:', this);
    console.log('Selected coordinates check:', { lat: selectedLatitude, lng: selectedLongitude });
    
    // Prevent multiple submissions
    if (this.hasAttribute('data-submitting')) {
        console.log('❌ Form already submitting, ignoring...');
        return;
    }
    
    // Mark form as submitting
    this.setAttribute('data-submitting', 'true');
    
    if (!selectedLatitude || !selectedLongitude) {
        alert('Please set a location on the map before saving.');
        console.log('Form submission blocked - no coordinates selected');
        this.removeAttribute('data-submitting');
        return;
    }
    
    console.log('Form validation passed, proceeding with submission...');
    
    // Update hidden inputs before FormData
    document.getElementById('latitude').value = selectedLatitude || '';
    document.getElementById('longitude').value = selectedLongitude || '';
    
    const userData = JSON.parse(localStorage.getItem('userData'));
    if (userData?.id) {
        document.getElementById('user_id').value = userData.id;
    }
    
    const formData = new FormData(this);
    
    // Debug: Log what we're sending
    console.log('=== USER PROFILE ADDRESS FORM DEBUG ===');
    console.log('Form data being sent:');
    for (let [key, value] of formData.entries()) {
        console.log(key + ': ' + value);
    }
    console.log('User data from localStorage:', userData);
    console.log('Selected coordinates:', { lat: selectedLatitude, lng: selectedLongitude });
    
    try {
        console.log('Sending fetch request to save_address.php...');
        const response = await fetch('save_address.php', {
            method: 'POST',
            body: formData
        });
        
        console.log('Response received:', response);
        console.log('Response status:', response.status);
        console.log('Response ok:', response.ok);
        
        const data = await response.json();
        console.log('Response data:', data);
        
        if (data.status === 'success') {
            // Use console.log instead of alert for debugging
            console.log('✅ Success:', data.message);
            // alert(data.message); // Commented out to prevent repeated alerts
            cancelAddressForm();
            loadAddressesInSettings();
            // Reload addresses in personal info section
            if (document.querySelector('.nav-item.active').getAttribute('data-section') === 'personal') {
                loadSectionContent('personal');
            }
        } else {
            console.error('Server response:', data);
            let errorMsg = 'Error: ' + data.message;
            if (data.debug) {
                errorMsg += '\n\nDebug info: ' + JSON.stringify(data.debug, null, 2);
                console.log('Debug info:', data.debug);
            }
            console.error('❌ Error:', errorMsg);
            // alert(errorMsg); // Commented out to prevent repeated alerts
        }
    } catch (error) {
        console.error('Error saving address:', error);
        console.error('❌ Error saving address. Please try again.');
        // alert('Error saving address. Please try again.'); // Commented out to prevent repeated alerts
    } finally {
        // Always remove the submitting flag
        this.removeAttribute('data-submitting');
    }
}

// Delete address
async function deleteAddress(addressId) {
    if (confirm('Are you sure you want to delete this address?')) {
        try {
            const formData = new FormData();
            formData.append('address_id', addressId);
            
            // Add user_id from localStorage
            const userData = JSON.parse(localStorage.getItem('userData'));
            if (userData && userData.id) {
                formData.append('user_id', userData.id);
            }
            
            const response = await fetch('delete_address.php', {
                method: 'POST',
                body: formData
            });
            
            const data = await response.json();
            
            if (data.status === 'success') {
                alert(data.message);
                loadAddressesInSettings();
                // Reload addresses in personal info section
                if (document.querySelector('.nav-item.active').getAttribute('data-section') === 'personal') {
                    loadSectionContent('personal');
                }
            } else {
                alert('Error: ' + data.message);
            }
        } catch (error) {
            console.error('Error deleting address:', error);
            alert('Error deleting address. Please try again.');
        }
    }
}

// Load addresses when settings section is loaded
document.addEventListener('DOMContentLoaded', function() {
    // Add event listener for settings section
    const settingsNav = document.querySelector('.nav-item[data-section="settings"]');
    if (settingsNav) {
        settingsNav.addEventListener('click', function() {
            // Load addresses after a short delay to ensure the section is rendered
            setTimeout(loadAddressesInSettings, 100);
        });
    }
});
