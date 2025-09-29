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
    <link rel="stylesheet" href="style/new-navbar.css">
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
    <div id="navbar-root"></div>
    <div style="height: 80px;"></div> <!-- Spacer for fixed navbar -->
    <div class="container main-content">
        <div class="cart-header" style="display:flex; align-items:center; justify-content:space-between; margin-bottom: 20px;">
            <h2 style="margin:0; color: #0d3b5e;">Your Cart</h2>
            <a href="checkout.html" class="add-to-cart" style="text-decoration:none; display:inline-flex; align-items:center; gap:6px;">
                <i class="fa-solid fa-credit-card"></i> Checkout
            </a>
        </div>
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
    <script src="js/navbar.js"></script>
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