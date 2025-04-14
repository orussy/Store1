// Notifications data will be fetched from the server
let notifications = [];

// Toggle notifications dropdown
function toggleNotifications() {
    console.log('Toggling notifications dropdown');
    const notificationsDropdown = document.getElementById('notificationsDropdown');
    
    // Check if user is logged in
    const userData = JSON.parse(localStorage.getItem('userData'));
    if (!userData || !userData.email) {
        console.log('User not logged in, redirecting to login page');
        showToast('Please login to view your notifications');
        window.location.href = 'index.html';
        return;
    }
    
    // Toggle the dropdown visibility
    if (notificationsDropdown.classList.contains('show')) {
        notificationsDropdown.classList.remove('show');
        console.log('Hiding notifications dropdown');
    } else {
        notificationsDropdown.classList.add('show');
        console.log('Showing notifications dropdown');
        // Load notifications when showing the dropdown
        loadNotifications();
    }
}

// Load notifications from the server
function loadNotifications() {
    console.log('Loading notifications from server...');
    
    // Check if user is logged in
    const userData = JSON.parse(localStorage.getItem('userData'));
    if (!userData || !userData.email) {
        console.log('User not logged in, skipping notifications load');
        return;
    }
    
    // Get the notifications container
    const notificationsContainer = document.getElementById('notificationsItems');
    
    // Show loading state
    notificationsContainer.innerHTML = '<div class="loading">Loading notifications...</div>';
    
    // Fetch notifications from the server
    fetch('get_notifications.php')
        .then(response => {
            if (!response.ok) {
                throw new Error('Network response was not ok');
            }
            return response.json();
        })
        .then(data => {
            console.log('Notifications data:', data);
            
            // Clear loading state
            notificationsContainer.innerHTML = '';
            
            if (data.status === 'success' && data.notifications && data.notifications.length > 0) {
                // Store notifications in the global variable
                notifications = data.notifications;
                
                // Add each notification to the dropdown
                notifications.forEach(notification => {
                    const notificationItem = document.createElement('div');
                    notificationItem.className = 'notification-item';
                    notificationItem.setAttribute('data-notification-id', notification.id);
                    
                    // Add unread class if notification is not read
                    if (notification.status === 'unread') {
                        notificationItem.classList.add('unread');
                    }
                    
                    notificationItem.innerHTML = `
                        <div class="notification-item-details">
                            <h4>${notification.title}</h4>
                            <p>${notification.message}</p>
                            <span class="timestamp">${formatTimestamp(notification.timestamp)}</span>
                        </div>
                    `;
                    
                    // Add click event to mark as read
                    notificationItem.addEventListener('click', () => {
                        if (notification.status === 'unread') {
                            markAsRead(notification.id);
                        }
                    });
                    
                    notificationsContainer.appendChild(notificationItem);
                });
            } else {
                // Show empty notifications message
                notificationsContainer.innerHTML = '<div class="empty-notifications">No new notifications</div>';
            }
        })
        .catch(error => {
            console.error('Error loading notifications:', error);
            notificationsContainer.innerHTML = '<div class="error-message">Error loading notifications. Please try again later.</div>';
        });
}

// Mark notification as read
function markAsRead(notificationId) {
    console.log('Marking notification as read:', notificationId);
    
    // Create form data
    const formData = new FormData();
    formData.append('notification_id', notificationId);
    
    // Send request to mark notification as read
    fetch('mark_notification_read.php', {
        method: 'POST',
        body: formData
    })
    .then(response => {
        if (!response.ok) {
            throw new Error('Network response was not ok');
        }
        return response.json();
    })
    .then(data => {
        console.log('Mark as read response:', data);
        if (data.status === 'success') {
            // Update the notification in our local array
            const notificationIndex = notifications.findIndex(n => n.id === notificationId);
            if (notificationIndex !== -1) {
                notifications[notificationIndex].read = true;
                notifications[notificationIndex].status = 'read';
            }
            
            // Update the UI
            const notificationItem = document.querySelector(`[data-notification-id="${notificationId}"]`);
            if (notificationItem) {
                notificationItem.classList.remove('unread');
                // Remove the read dot if it exists
                const readDot = notificationItem.querySelector('.read-dot');
                if (readDot) {
                    readDot.remove();
                }
            }
            
            // Update unread count
            updateUnreadCount();
        }
    })
    .catch(error => {
        console.error('Error marking notification as read:', error);
    });
}

// Update unread count in the bell icon
function updateUnreadCount() {
    const unreadCount = notifications.filter(n => n.status === 'unread').length;
    const bellIcon = document.querySelector('.nav-icon[alt="Security"]');
    
    // Remove existing badge and dot if any
    const existingBadge = document.querySelector('.notification-badge');
    if (existingBadge) {
        existingBadge.remove();
    }
    
    const existingDot = document.querySelector('.notification-dot');
    if (existingDot) {
        existingDot.remove();
    }
    
    // Add badge if there are unread notifications
    if (unreadCount > 0) {
        // Add the red dot
        const dot = document.createElement('span');
        dot.className = 'notification-dot';
        bellIcon.parentNode.appendChild(dot);
        
        // Add the count badge
        const badge = document.createElement('span');
        badge.className = 'notification-badge';
        badge.textContent = unreadCount > 9 ? '9+' : unreadCount;
        bellIcon.parentNode.appendChild(badge);
    }
}

// Format timestamp to relative time
function formatTimestamp(timestamp) {
    const date = new Date(timestamp);
    const now = new Date();
    const diffInSeconds = Math.floor((now - date) / 1000);
    
    if (diffInSeconds < 60) {
        return 'Just now';
    } else if (diffInSeconds < 3600) {
        const minutes = Math.floor(diffInSeconds / 60);
        return `${minutes} minute${minutes > 1 ? 's' : ''} ago`;
    } else if (diffInSeconds < 86400) {
        const hours = Math.floor(diffInSeconds / 3600);
        return `${hours} hour${hours > 1 ? 's' : ''} ago`;
    } else {
        return date.toLocaleDateString();
    }
}

// Close notifications when clicking outside
document.addEventListener('click', function(event) {
    const notificationsDropdown = document.getElementById('notificationsDropdown');
    const bellIcon = document.querySelector('.nav-icon[alt="Security"]');
    
    // Check if click is outside the notifications dropdown and icon
    if (!notificationsDropdown.contains(event.target) && event.target !== bellIcon) {
        notificationsDropdown.classList.remove('show');
    }
});

// Load notifications when page loads
document.addEventListener('DOMContentLoaded', function() {
    // Check if user is logged in
    const userData = JSON.parse(localStorage.getItem('userData'));
    if (userData && userData.email) {
        // Load notifications in the background
        loadNotifications();
    }
}); 