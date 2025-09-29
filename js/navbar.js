// New Navbar Implementation
class Navbar {
    constructor() {
        this.isLoggedIn = false;
        this.userData = null;
        this.init();
    }

	async init() {
		await this.checkAuthStatus();
		this.injectNavbar();
		this.setupEventListeners();
		this.updateUserInterface();
	}

    async checkAuthStatus() {
        try {
            const response = await fetch('get_user_data.php', { credentials: 'include' });
            if (response.ok) {
                const data = await response.json();
                if (data && data.user_id) {
                    this.isLoggedIn = true;
                    this.userData = data;
                }
            }
        } catch (error) {
            console.log('Not logged in');
        }
    }

    injectNavbar() {
    const mount = document.getElementById('navbar-root');
    if (!mount) return;

    mount.innerHTML = `
    <div class="navbar">
                <div class="navbar-left">
                    <a href="dashboard.html" class="logo-link">
                        <img src="img/store logo with one element on a white background.png" alt="Store Logo" class="logo">
                    </a>
                </div>
                
                <div class="navbar-center">
                    <form class="search-form" id="searchForm">
                        <div class="search-container">
                            <input type="text" id="searchInput" placeholder="Search products..." class="search-input">
                            <button type="submit" class="search-btn">
                                <i class="fas fa-search"></i>
                            </button>
        </div>
            </form>
        </div>
                
                <div class="navbar-right">
                    <div class="nav-item" id="wishlistItem">
                        <button class="nav-btn" id="wishlistBtn" title="Wishlist">
                            <i class="fas fa-heart"></i>
                            <span class="nav-label">Wishlist</span>
                        </button>
                        <div class="dropdown" id="wishlistDropdown">
                            <div class="dropdown-header">
                                <h3><i class="fas fa-heart"></i> My Wishlist</h3>
                                <a href="wishlist.php" class="view-all">View All</a>
                            </div>
                            <div class="dropdown-content" id="wishlistContent">
                                <div class="loading">Loading wishlist...</div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="nav-item" id="notificationsItem">
                        <button class="nav-btn" id="notificationsBtn" title="Notifications">
                            <i class="fas fa-bell"></i>
                            <span class="nav-label">Notifications</span>
                            <span class="notification-count" id="notificationCount">0</span>
                        </button>
                        <div class="dropdown" id="notificationsDropdown">
                            <div class="dropdown-header">
                                <h3><i class="fas fa-bell"></i> Notifications</h3>
                                <a href="#" class="view-all" onclick="markAllAsRead()">Mark All Read</a>
                            </div>
                            <div class="dropdown-content" id="notificationsContent">
                                <div class="loading">Loading notifications...</div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="nav-item" id="cartItem">
                        <button class="nav-btn" id="cartBtn" title="Shopping Cart">
                            <i class="fas fa-shopping-cart"></i>
                            <span class="nav-label">Cart</span>
                            <span class="cart-count" id="cartCount">0</span>
                        </button>
                        <div class="dropdown" id="cartDropdown">
                            <div class="dropdown-header">
                                <h3><i class="fas fa-shopping-cart"></i> Shopping Cart</h3>
                                <a href="cart.php" class="view-all">View All</a>
                            </div>
                            <div class="dropdown-content" id="cartContent">
                                <div class="loading">Loading cart...</div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="nav-item">
                        <a href="tel:+1234567890" class="nav-btn" title="Call Us">
                            <i class="fas fa-phone"></i>
                            <span class="nav-label">Call Us</span>
                        </a>
                    </div>
                    
                    <div class="nav-item" id="userItem">
                        <button class="nav-btn" id="userBtn" title="User Account">
                            <i class="fas fa-user"></i>
                            <span class="nav-label" id="userLabel">Account</span>
                            <span class="email-inline" id="userEmailInline" style="display:none;"></span>
                        </button>
                        <div class="dropdown" id="userDropdown">
                            <div class="dropdown-content">
                                <div id="loginSection">
                                    <a href="index.html" class="dropdown-link">
                                        <i class="fas fa-sign-in-alt"></i> Login
                                    </a>
                                </div>
                                <div id="userSection" style="display: none;">
                                    <div class="user-info">
                                        <div class="user-avatar">
                                            <i class="fas fa-user-circle"></i>
                                        </div>
                                        <div class="user-details">
                                            <span class="username" id="username">User</span>
                                            <span class="user-email" id="userEmail">user@example.com</span>
                                        </div>
                                    </div>
                                    <a href="user-profile.html" class="dropdown-link">
                                        <i class="fas fa-user"></i> Profile
                                    </a>
                                    <a href="#" class="dropdown-link" id="logoutBtn">
                                        <i class="fas fa-sign-out-alt"></i> Logout
                                    </a>
                                </div>
                            </div>
                        </div>
            </div>
                </div>
            </div>
        `;
    }

    setupEventListeners() {
        // Search functionality
        const searchForm = document.getElementById('searchForm');
        const searchInput = document.getElementById('searchInput');
        
        if (searchForm) {
            searchForm.addEventListener('submit', (e) => {
                e.preventDefault();
                this.handleSearch(searchInput.value);
            });
        }

        // Wishlist dropdown
        const wishlistBtn = document.getElementById('wishlistBtn');
        const wishlistDropdown = document.getElementById('wishlistDropdown');
        
        if (wishlistBtn && wishlistDropdown) {
            wishlistBtn.addEventListener('click', (e) => {
                e.preventDefault();
                this.toggleDropdown('wishlist');
            });
        }

        // Notifications dropdown
        const notificationsBtn = document.getElementById('notificationsBtn');
        const notificationsDropdown = document.getElementById('notificationsDropdown');
        
        if (notificationsBtn && notificationsDropdown) {
            notificationsBtn.addEventListener('click', (e) => {
                e.preventDefault();
                this.toggleDropdown('notifications');
            });
        }

        // Cart dropdown
        const cartBtn = document.getElementById('cartBtn');
        const cartDropdown = document.getElementById('cartDropdown');
        
        if (cartBtn && cartDropdown) {
            cartBtn.addEventListener('click', (e) => {
                e.preventDefault();
                this.toggleDropdown('cart');
            });
        }

        // User dropdown
        const userBtn = document.getElementById('userBtn');
        const userDropdown = document.getElementById('userDropdown');
        
        if (userBtn && userDropdown) {
            userBtn.addEventListener('click', (e) => {
                e.preventDefault();
                this.toggleDropdown('user');
            });
        }

        // Logout functionality
        const logoutBtn = document.getElementById('logoutBtn');
        if (logoutBtn) {
            logoutBtn.addEventListener('click', (e) => {
                e.preventDefault();
                this.handleLogout();
            });
        }

        // Click outside to close dropdowns
        document.addEventListener('click', (e) => {
            if (!e.target.closest('.nav-item')) {
                this.closeAllDropdowns();
            }
        });

        // Load initial data
        this.loadCartData();
        this.loadWishlistData();
        this.loadNotificationsData();
        this.updateUserInterface();
    }

    toggleDropdown(type) {
        const dropdown = document.getElementById(`${type}Dropdown`);
        if (!dropdown) return;

        // Close other dropdowns
        this.closeAllDropdowns();

        // Toggle current dropdown
        if (dropdown.classList.contains('show')) {
            dropdown.classList.remove('show');
        } else {
            dropdown.classList.add('show');
            
            // Load data when opening
            if (type === 'wishlist') {
                this.loadWishlistData();
            } else if (type === 'cart') {
                this.loadCartData();
            } else if (type === 'notifications') {
                this.loadNotificationsData();
            }
        }
    }

    closeAllDropdowns() {
        const dropdowns = document.querySelectorAll('.dropdown');
        dropdowns.forEach(dropdown => {
            dropdown.classList.remove('show');
        });
    }

    async loadCartData() {
        const cartContent = document.getElementById('cartContent');
        if (!cartContent) return;

        try {
            const response = await fetch('cart_api.php', { credentials: 'include' });
            const data = await response.json();
            
            if (data.status === 'success' && data.items) {
                this.displayCartItems(data.items, data.total);
                this.updateCartCount(data.items.length);
            } else {
                cartContent.innerHTML = '<div class="empty-state">Your cart is empty</div>';
                this.updateCartCount(0);
            }
        } catch (error) {
            console.error('Error loading cart:', error);
            cartContent.innerHTML = '<div class="error-state">Error loading cart</div>';
        }
    }

    async loadWishlistData() {
        const wishlistContent = document.getElementById('wishlistContent');
        if (!wishlistContent) return;

        if (!this.isLoggedIn) {
            wishlistContent.innerHTML = '<div class="empty-state">Please login to view your wishlist</div>';
            return;
        }

        try {
            const response = await fetch('wishlist_api.php', { credentials: 'include' });
            const data = await response.json();
            
            if (data.status === 'success' && data.items) {
                this.displayWishlistItems(data.items);
            } else {
                wishlistContent.innerHTML = '<div class="empty-state">Your wishlist is empty</div>';
            }
        } catch (error) {
            console.error('Error loading wishlist:', error);
            wishlistContent.innerHTML = '<div class="error-state">Error loading wishlist</div>';
        }
    }

    async loadNotificationsData() {
        const notificationsContent = document.getElementById('notificationsContent');
        if (!notificationsContent) return;

        if (!this.isLoggedIn) {
            notificationsContent.innerHTML = '<div class="empty-state">Please login to view your notifications</div>';
            this.updateNotificationCount(0);
            return;
        }

        try {
            const response = await fetch('get_notifications.php', { credentials: 'include' });
            const data = await response.json();
            
            if (data.status === 'success' && data.notifications) {
                this.displayNotifications(data.notifications);
                this.updateNotificationCount(data.notifications.filter(n => n.status === 'unread').length);
            } else {
                notificationsContent.innerHTML = '<div class="empty-state">No notifications</div>';
                this.updateNotificationCount(0);
            }
        } catch (error) {
            console.error('Error loading notifications:', error);
            notificationsContent.innerHTML = '<div class="error-state">Error loading notifications</div>';
            this.updateNotificationCount(0);
        }
    }

    displayCartItems(items, total) {
        const cartContent = document.getElementById('cartContent');
        if (!cartContent) return;

        if (items.length === 0) {
            cartContent.innerHTML = '<div class="empty-state">Your cart is empty</div>';
            return;
        }

        const itemsHtml = items.map(item => `
            <div class="cart-item">
                <img src="${item.cover}" alt="${item.name}" class="item-image">
                <div class="item-details">
                    <h4 class="item-name">${item.name}</h4>
                    <p class="item-price">$${item.price}</p>
                    <div class="item-quantity">Qty: ${item.quantity}</div>
                </div>
                <button class="remove-btn" onclick="removeFromCart(${item.id})">
                    <i class="fas fa-trash"></i>
                </button>
            </div>
        `).join('');

        cartContent.innerHTML = `
            ${itemsHtml}
            <div class="cart-footer">
                <div class="cart-total">Total: $${total.toFixed(2)}</div>
                <a href="cart.php" class="checkout-btn">Checkout</a>
                </div>
        `;
    }

    displayWishlistItems(items) {
        const wishlistContent = document.getElementById('wishlistContent');
        if (!wishlistContent) return;

        if (items.length === 0) {
            wishlistContent.innerHTML = '<div class="empty-state">Your wishlist is empty</div>';
            return;
        }

        const itemsHtml = items.map(item => `
            <div class="wishlist-item">
                <img src="${item.cover}" alt="${item.name}" class="item-image">
                <div class="item-details">
                    <h4 class="item-name">${item.name}</h4>
                    <p class="item-price">$${item.price}</p>
                </div>
                <button class="remove-btn" onclick="removeFromWishlist(${item.id})">
                    <i class="fas fa-trash"></i>
                </button>
            </div>
        `).join('');

        wishlistContent.innerHTML = itemsHtml;
    }

    displayNotifications(notifications) {
        const notificationsContent = document.getElementById('notificationsContent');
        if (!notificationsContent) return;

        if (notifications.length === 0) {
            notificationsContent.innerHTML = '<div class="empty-state">No notifications</div>';
            return;
        }

        const notificationsHtml = notifications.map(notification => `
            <div class="notification-item ${notification.status === 'unread' ? 'unread' : ''}" onclick="markNotificationAsRead(${notification.id})">
                <div class="notification-icon">
                    <i class="fas fa-bell"></i>
                </div>
                <div class="notification-details">
                    <h4 class="notification-title">${notification.title}</h4>
                    <p class="notification-message">${notification.message}</p>
                    <span class="notification-time">${this.formatTime(notification.timestamp)}</span>
                </div>
                ${notification.status === 'unread' ? '<div class="unread-dot"></div>' : ''}
            </div>
        `).join('');

        notificationsContent.innerHTML = notificationsHtml;
    }

    updateCartCount(count) {
        const cartCount = document.getElementById('cartCount');
        if (cartCount) {
            cartCount.textContent = count;
            cartCount.style.display = count > 0 ? 'block' : 'none';
        }
    }

    updateNotificationCount(count) {
        const notificationCount = document.getElementById('notificationCount');
        if (notificationCount) {
            notificationCount.textContent = count;
            notificationCount.style.display = count > 0 ? 'block' : 'none';
        }
    }

    formatTime(timestamp) {
        const date = new Date(timestamp);
        const now = new Date();
        const diffInSeconds = Math.floor((now - date) / 1000);
        
        if (diffInSeconds < 60) {
            return 'Just now';
        } else if (diffInSeconds < 3600) {
            const minutes = Math.floor(diffInSeconds / 60);
            return `${minutes}m ago`;
        } else if (diffInSeconds < 86400) {
            const hours = Math.floor(diffInSeconds / 3600);
            return `${hours}h ago`;
        } else {
            return date.toLocaleDateString();
        }
    }

    updateUserInterface() {
        const loginSection = document.getElementById('loginSection');
        const userSection = document.getElementById('userSection');
        const userLabel = document.getElementById('userLabel');
        const username = document.getElementById('username');
        const userEmail = document.getElementById('userEmail');
        const userEmailInline = document.getElementById('userEmailInline');

        if (this.isLoggedIn && this.userData) {
            if (loginSection) loginSection.style.display = 'none';
            if (userSection) userSection.style.display = 'block';
            if (userLabel) userLabel.textContent = 'Account';
            if (username) username.textContent = this.userData.email.split('@')[0];
            if (userEmail) userEmail.textContent = this.userData.email;
            if (userEmailInline) { userEmailInline.textContent = this.userData.email; userEmailInline.style.display = 'inline'; }
        } else {
            if (loginSection) loginSection.style.display = 'block';
            if (userSection) userSection.style.display = 'none';
            if (userLabel) userLabel.textContent = 'Login';
            if (userEmailInline) userEmailInline.style.display = 'none';
        }
    }

    handleSearch(query) {
        if (!query.trim()) return;
        
        // Redirect to search results page or implement search functionality
        console.log('Searching for:', query);
        // You can implement search functionality here
        // For now, just show an alert
        alert(`Searching for: ${query}`);
    }

    async handleLogout() {
        try {
            await fetch('logout.php', { credentials: 'include' });
            localStorage.removeItem('userData');
            this.isLoggedIn = false;
            this.userData = null;
            this.updateUserInterface();
            this.closeAllDropdowns();
            // Optionally redirect to login page
            // window.location.href = 'index.html';
        } catch (error) {
            console.error('Logout error:', error);
        }
    }
}

// Initialize navbar when DOM is loaded
document.addEventListener('DOMContentLoaded', () => {
	window.navbarInstance = new Navbar();
});

// Global functions for cart and wishlist operations
window.removeFromCart = async function(cartItemId) {
    try {
        const response = await fetch('cart_api.php', {
            method: 'DELETE',
            headers: { 'Content-Type': 'application/json' },
            credentials: 'include',
            body: JSON.stringify({ cart_item_id: cartItemId })
        });
        
        if (response.ok) {
            // Reload cart data
            const navbar = window.navbarInstance;
            if (navbar) navbar.loadCartData();
        }
    } catch (error) {
        console.error('Error removing from cart:', error);
    }
};

window.removeFromWishlist = async function(wishlistItemId) {
    try {
        const response = await fetch('wishlist_api.php', {
            method: 'DELETE',
            headers: { 'Content-Type': 'application/json' },
            credentials: 'include',
            body: JSON.stringify({ wishlist_item_id: wishlistItemId })
        });
        
        if (response.ok) {
            // Reload wishlist data
            const navbar = window.navbarInstance;
            if (navbar) navbar.loadWishlistData();
        }
    } catch (error) {
        console.error('Error removing from wishlist:', error);
    }
};

window.markNotificationAsRead = async function(notificationId) {
    try {
        const formData = new FormData();
        formData.append('notification_id', notificationId);
        
        const response = await fetch('mark_notification_read.php', {
            method: 'POST',
            body: formData
        });
        
        if (response.ok) {
            // Reload notifications data
            const navbar = window.navbarInstance;
            if (navbar) navbar.loadNotificationsData();
        }
    } catch (error) {
        console.error('Error marking notification as read:', error);
    }
};

window.markAllAsRead = async function() {
    try {
        // This would need to be implemented in your backend
        // For now, just reload notifications
        const navbar = window.navbarInstance;
        if (navbar) navbar.loadNotificationsData();
    } catch (error) {
        console.error('Error marking all as read:', error);
    }
};
