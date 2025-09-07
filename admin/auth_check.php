<?php
session_start();
require_once '../config/db.php';

// Function to get role name from role_id
function getRoleName($role_id) {
    global $conn;
    $query = "SELECT name FROM roles WHERE id = ?";
    $stmt = $conn->prepare($query);
    $stmt->bind_param("i", $role_id);
    $stmt->execute();
    $result = $stmt->get_result();
    $row = $result->fetch_assoc();
    $stmt->close();
    return $row['name'] ?? 'Unknown Role';
}

// Function to check if user is authenticated and is admin
function isAdmin() {
    // Check if user is logged in (using the same session variables as login.php)
    if (!isset($_SESSION['username']) || !isset($_SESSION['user_id'])) {
        return false;
    }
    
    // Check if user has admin role_id (1-6 are admin roles)
    if (!isset($_SESSION['role_id']) || !in_array($_SESSION['role_id'], [1, 2, 3, 4, 5, 6])) {
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
        'role_id' => $_SESSION['role_id'],
        'role_name' => getRoleName($_SESSION['role_id'])
    ];
}

// Auto-check admin status on every page load
redirectNonAdmin();
?>
