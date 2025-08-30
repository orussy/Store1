<?php
session_start();

// Function to check if user is authenticated and is admin
function isAdmin() {
    // Check if user is logged in (using the same session variables as login.php)
    if (!isset($_SESSION['username']) || !isset($_SESSION['user_id'])) {
        return false;
    }
    
    // Check if user has admin role (using the same session variable as login.php)
    if (!isset($_SESSION['role']) || $_SESSION['role'] !== 'admin') {
        return false;
    }
    
    // Additional security: check if session hasn't expired (30 minutes)
    if (isset($_SESSION['last_activity']) && (time() - $_SESSION['last_activity'] > 1800)) {
        session_unset();
        session_destroy();
        return false;
    }
    
    // Update last activity time
    $_SESSION['last_activity'] = time();
    
    return true;
}

// Function to redirect non-admin users
function redirectNonAdmin() {
    if (!isAdmin()) {
        // Clear any existing session data
        session_unset();
        session_destroy();
        
        // Redirect to login page with error message
        header('Location: ../index.html?error=access_denied');
        exit();
    }
}

// Function to get admin user info
function getAdminInfo() {
    if (!isAdmin()) {
        return null;
    }
    
    return [
        'user_id' => $_SESSION['user_id'],
        'email' => $_SESSION['username'], // Using 'username' as set in login.php
        'role' => $_SESSION['role']
    ];
}

// Auto-check admin status on every page load
redirectNonAdmin();
?>
