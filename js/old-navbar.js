// Define dropdown functions directly in navbar.js to ensure they're available
function toggleCart() {
    console.log('toggleCart called');
    const cartDropdown = document.getElementById('cartDropdown');
    if (!cartDropdown) {
        console.error('Cart dropdown not found');
        return;
    }
    cartDropdown.classList.toggle('show');
    
    if (cartDropdown.classList.contains('show')) {
        console.log('Cart dropdown shown');
        if (typeof loadCart === 'function') {
            loadCart('cartDropdownItems');
        }
    } else {
        console.log('Cart dropdown hidden');
    }
}

function toggleWishlist() {
    console.log('toggleWishlist called');
    const wishlistDropdown = document.getElementById('wishlistDropdown');
    if (!wishlistDropdown) {
        console.error('Wishlist dropdown not found');
        return;
    }
    
    // Check if user is logged in
    const userData = JSON.parse(localStorage.getItem('userData') || 'null');
    if (!userData || !userData.email) {
        console.log('User not logged in');
        if (typeof showToast === 'function') {
            showToast('Please login to view your wishlist');
        }
        return;
    }
    
    wishlistDropdown.classList.toggle('show');
    
    if (wishlistDropdown.classList.contains('show')) {
        console.log('Wishlist dropdown shown');
        if (typeof loadWishlist === 'function') {
            loadWishlist();
        }
    } else {
        console.log('Wishlist dropdown hidden');
    }
}

function toggleNotifications() {
    console.log('toggleNotifications called');
    const notificationsDropdown = document.getElementById('notificationsDropdown');
    if (!notificationsDropdown) {
        console.error('Notifications dropdown not found');
        return;
    }
    
    // Check if user is logged in
    const userData = JSON.parse(localStorage.getItem('userData') || 'null');
    if (!userData || !userData.email) {
        console.log('User not logged in');
        if (typeof showToast === 'function') {
            showToast('Please login to view your notifications');
        }
        return;
    }
    
    notificationsDropdown.classList.toggle('show');
    
    if (notificationsDropdown.classList.contains('show')) {
        console.log('Notifications dropdown shown');
        if (typeof loadNotifications === 'function') {
            loadNotifications();
        }
    } else {
        console.log('Notifications dropdown hidden');
    }
}

// Simple showToast function if not available from other files
function showToast(message) {
    // Check if showToast is already defined
    if (typeof window.showToast === 'function') {
        return window.showToast(message);
    }
    
    // Create a simple toast notification
    const toast = document.createElement('div');
    toast.style.cssText = `
        position: fixed;
        top: 20px;
        right: 20px;
        background: #333;
        color: white;
        padding: 12px 20px;
        border-radius: 4px;
        z-index: 10000;
        font-size: 14px;
        opacity: 0;
        transition: opacity 0.3s ease;
    `;
    toast.textContent = message;
    document.body.appendChild(toast);
    
    // Show toast
    setTimeout(() => {
        toast.style.opacity = '1';
    }, 100);
    
    // Hide toast after 3 seconds
    setTimeout(() => {
        toast.style.opacity = '0';
        setTimeout(() => {
            if (document.body.contains(toast)) {
                document.body.removeChild(toast);
            }
        }, 300);
    }, 3000);
}

// Make functions globally accessible
window.toggleCart = toggleCart;
window.toggleWishlist = toggleWishlist;
window.toggleNotifications = toggleNotifications;
window.showToast = showToast;

// Inject a unified navbar into #navbar-root
(function injectNavbar(){
    const mount = document.getElementById('navbar-root');
    if (!mount) return;
    mount.innerHTML = `
    <div class="navbar">
        <div class="left">
            <a href="dashboard.html"><img src="img/store logo with one element on a white background.png" alt="Store Logo"></a>
        </div>
        <div class="center">
            <form action="" class="search-bar">
                <input type="search" name="search" pattern=".*\\S.*" required placeholder="Search Here...">
                <button class="search-btn" type="submit"><span>Search</span></button>
            </form>
        </div>
        <div class="right">
            <div class="nav-item">
                <img src="img/heart-solid.svg" alt="wishlist" class="nav-icon" onclick="toggleWishlist()">
                <div class="wishlist-dropdown" id="wishlistDropdown">
                    <div class="wishlist-header">
                        <h3><i class="fa-solid fa-heart"></i><a href="wishlist.php"> My Wishlist</a></h3>
                    </div>
                    <div id="wishlistItems"></div>
                </div>
            </div>
            <div class="nav-item">
                <img src="img/bell-solid.svg" alt="Security" class="nav-icon" onclick="toggleNotifications()">
                <div class="notifications-dropdown" id="notificationsDropdown">
                    <div class="notifications-header">
                        <h3><i class="fa-solid fa-bell"></i> Notifications</h3>
                    </div>
                    <div id="notificationsItems"></div>
                </div>
            </div>
            <div class="nav-item">
                <img src="img/cart-shopping-solid.svg" alt="Cart" class="nav-icon" onclick="toggleCart()">
                <div class="cart-dropdown" id="cartDropdown">
                    <div class="cart-header">
                        <h3><i class="fa-solid fa-cart-shopping"></i> <a href="cart.php">Shopping Cart</a></h3>
                    </div>
                    <div id="cartDropdownItems"></div>
                </div>
            </div>
            <a href="#" class="nav-link"><img src="img/phone-solid.svg" alt="Night Mode" class="nav-icon"></a>
            <div class="user-section">
                <div id="loginSection" style="display: none;">
                    <a href="index.html" class="nav-link">
                        <img src="img/right-to-bracket-solid.svg" alt="Login" class="nav-icon">
                    </a>
                </div>
                <div id="userSection" style="display: none;">
                    <span id="username" class="username-text"></span>
                    <a href="user-profile.html" class="nav-link">
                        <img src="img/user-solid.svg" alt="Profile" class="nav-icon">
                    </a>
                    <a href="#" class="nav-link" onclick="logout()">
                        <img src="img/right-from-bracket-solid.svg" alt="Logout" class="nav-icon">
                    </a>
                </div>
            </div>
        </div>
    </div>`;
})();


