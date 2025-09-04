<?php
if (session_status() === PHP_SESSION_NONE) {
    $cookieParams = session_get_cookie_params();
    session_set_cookie_params([
        'lifetime' => 0,
        'path' => '/',
        'domain' => $cookieParams['domain'] ?? '',
        'secure' => (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off'),
        'httponly' => true,
        'samesite' => 'Lax'
    ]);
    session_start();
}

// Simple session check - show page with client-side guard if not logged in
if (!isset($_SESSION['user_id'])) {
    // Do not redirect here to avoid loops; UI will handle login state
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="style/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.2/css/all.min.css">
    <title>Wishlist</title>
    <style>
        .container{
            display: flex;
            flex-direction: column;
            justify-content: center;
            height: 100vh;
            width: 100vw;
        }
        .wishlist-grid {
            display: flex;
            flex-wrap: wrap;
            gap: 24px;
            justify-content: center;
            margin-top: 24px;
        }
        .wishlist-item {
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            width: 260px;
            display: flex;
            flex-direction: column;
            align-items: center;
            padding: 20px 16px 16px 16px;
            transition: box-shadow 0.2s;
            position: relative;
        }
        .wishlist-item:hover {
            box-shadow: 0 4px 16px rgba(0,0,0,0.16);
        }
        .wishlist-img {
            width: 120px;
            height: 120px;
            object-fit: cover;
            border-radius: 8px;
            margin-bottom: 16px;
        }
        .wishlist-info {
            text-align: center;
            display: flex;
            flex-direction: column;
            align-items: center;
        }
        .wishlist-info h3 {
            font-size: 1.1rem;
            margin: 0 0 8px 0;
            color: #222;
        }
        .wishlist-info p {
            margin: 0 0 12px 0;
            color: #666;
        }
        .wishlist-item button {
            background: #e74c3c;
            color: #fff;
            border: none;
            border-radius: 6px;
            padding: 8px 18px;
            cursor: pointer;
            font-size: 1rem;
            transition: background 0.2s;
        }
        .wishlist-item button:hover {
            background: #c0392b;
        }
        .wishlist-actions {
            display: flex;
            gap: 10px;
            justify-content: center;
            margin-top: 8px;
        }
    </style>
</head>
<body>
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
                    <h3><i class="fa-solid fa-cart-shopping"></i><a href="cart.php">< Shopping Cart</a></h3>
                </div>
                <div id="cartItems"></div>
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
    <div class="container">
        <h2>My Wishlist</h2>
        <div id="wishlist-container" class="wishlist-grid"></div>
    </div>
    <script src="js/auth-check.js"></script>
    <script src="js/wishlist.js"></script>
    <script src="js/js.js"></script>
    <script src="js/notifications.js"></script>
    <script src="js/cart.js"></script>
</body>
</html> 