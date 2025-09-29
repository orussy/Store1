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
    <link rel="stylesheet" href="style/new-navbar.css">
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
    <div id="navbar-root"></div>
    <div class="container">
        <h2>My Wishlist</h2>
        <div id="wishlist-container" class="wishlist-grid"></div>
    </div>
    <script src="js/auth-check.js"></script>
    <script src="js/wishlist.js"></script>
    <script src="js/js.js"></script>
    <script src="js/navbar.js"></script>
    <script src="js/notifications.js"></script>
    <script src="js/cart.js"></script>
</body>
</html> 