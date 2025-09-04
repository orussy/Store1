<?php
session_start();

// Simple session check - redirect if not logged in
if (!isset($_SESSION['user_id'])) {
    header('Location: index.html');
    exit();
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Shopping Cart</title>
    <link rel="stylesheet" href="style/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.2/css/all.min.css">
    <style>
        html, body {
            height: 100%;
        }
        body {
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }
        .main-content {
            flex: 1 0 auto;
        }
        .footer {
            flex-shrink: 0;
        }
        .cart-header a{
           text-decoration: none;
           color: black;
           transition: 0.3s;
           
        }
        .cart-header a:hover{
            color: #3d3c3c;
        }
    </style>
</head>
<body>
    <!-- Navbar (copied from dashboard.html) -->
    <div class="navbar">
        <div class="left"> <a href="dashboard.html"><img src="img/store logo with one element on a white background.png" alt=""></a></div>
        <div class="center">
            <form action="" class="search-bar">
                <input type="search" name="search" pattern=".*\S.*" required placeholder="Search Here...">
                <button class="search-btn" type="submit">
                    <span>Search</span>
                </button>
            </form>
        </div>
        <div class="right">
            <img src="img/heart-solid.svg" alt="wishlist" class="nav-icon" onclick="toggleWishlist()">
            <img src="img/bell-solid.svg" alt="Security" class="nav-icon" onclick="toggleNotifications()">
            <img src="img/cart-shopping-solid.svg" alt="Cart" class="nav-icon" onclick="toggleCart()">
            <a href="#" class="nav-link"><img src="img/phone-solid.svg" alt="Night Mode" class="nav-icon"></a>
            <!-- Cart dropdown -->
            <div class="cart-dropdown" id="cartDropdown">
                <div class="cart-header">
                    <h3><i class="fa-solid fa-cart-shopping"></i> <a href="cart.php">Shopping Cart</a></h3>
                </div>
                <!-- This is the dropdown cart, not the main cart page list -->
                <div id="cartDropdownItems"></div>
            </div>
            <!-- Wishlist dropdown -->
            <div class="wishlist-dropdown" id="wishlistDropdown">
                <div class="wishlist-header">
                    <h3><i class="fa-solid fa-heart"></i><a href="wishlist.php"> My Wishlist</a></h3>
                </div>
                <div id="wishlistItems"></div>
            </div>
            <!-- Notifications dropdown -->
            <div class="notifications-dropdown" id="notificationsDropdown">
                <div class="notifications-header">
                    <h3><i class="fa-solid fa-bell"></i> Notifications</h3>
                </div>
                <div id="notificationsItems">
                    <!-- Notifications will be dynamically inserted here -->
                </div>
            </div>
            <!-- Login/User section -->
            <div class="user-section">
                <div id="loginSection" style="display: none;">
                    <a href="index.html" class="nav-link">
                        <img src="img/right-to-bracket-solid.svg" alt="Login" class="nav-icon">
                    </a>
                </div>
                <div id="userSection" style="display: none;">
                    <span id="username" class="username-text"></span>
                    <a href="#" class="nav-link">
                        <img src="img/user-solid.svg" alt="Profile" class="nav-icon">
                    </a>
                    <a href="#" class="nav-link" onclick="logout()">
                        <img src="img/right-from-bracket-solid.svg" alt="Logout" class="nav-icon">
                    </a>
                </div>
            </div>
        </div>
    </div>
    <div style="height: 80px;"></div> <!-- Spacer for fixed navbar -->
    <div class="container main-content">
        <h2 style="margin-bottom: 30px; color: #0d3b5e;">Your Cart</h2>
        <div id="cartItems"></div>
    </div>
    <div class="loading-overlay" id="loadingOverlay">
        <div class="loading-container">
            <div class="loading-text">Loading...</div>
        </div>
    </div>
    <footer class="footer">
        <div class="footer-content">
            <div class="footer-section">
                <h3>About Us</h3>
                <p>Welcome to our online store. We offer a wide range of products for your home and office.</p>
            </div>
        </div>
    </footer>
    <script src="js/auth-check.js"></script>
    <script src="js/js.js"></script>
    <script src="js/cart.js"></script>
    <script src="js/notifications.js"></script>
    <script>
        // Load cart when page loads
        document.addEventListener('DOMContentLoaded', function() {
            loadCart('cartItems');
        });
    </script>
</body>
</html> 