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
header("Content-Type: application/json");

require_once 'config/db.php';

// Check if user is logged in via session or POST/GET
$userId = null;
if (isset($_SESSION['user_id'])) {
    $userId = $_SESSION['user_id'];
} elseif (isset($_POST['user_id']) && !empty($_POST['user_id'])) {
    $userId = intval($_POST['user_id']);
} elseif (isset($_GET['user_id']) && !empty($_GET['user_id'])) {
    $userId = intval($_GET['user_id']);
}

if (!$userId) {
    echo json_encode([
        "status" => "error",
        "message" => "User not authenticated"
    ]);
    exit();
}

try {
    // Get user data from users table
    $userQuery = "SELECT id, email, f_name, l_name, phone_no, birthdate, 
                         role_id, status, created_at, gender, loyalty_points, avatar
                  FROM users 
                  WHERE id = ? AND deleted_at IS NULL";
    
    $userStmt = $conn->prepare($userQuery);
    $userStmt->bind_param("i", $userId);
    $userStmt->execute();
    $userResult = $userStmt->get_result();
    
    if ($userResult->num_rows === 0) {
        echo json_encode([
            "status" => "error",
            "message" => "User not found"
        ]);
        exit();
    }
    
    $userData = $userResult->fetch_assoc();
    
    // Get address data from addresses table
    $addressQuery = "SELECT title, address1, address2, country, city, postal_code 
                     FROM addresses 
                     WHERE user_id = ? AND deleted_at IS NULL 
                     ORDER BY created_at DESC LIMIT 1";
    
    $addressStmt = $conn->prepare($addressQuery);
    $addressStmt->bind_param("i", $userId);
    $addressStmt->execute();
    $addressResult = $addressStmt->get_result();
    
    $addressData = null;
    if ($addressResult->num_rows > 0) {
        $addressData = $addressResult->fetch_assoc();
    }
    
    // Format the data for frontend
    $profileData = [
        "id" => $userData['id'],
        "email" => $userData['email'],
        "f_name" => $userData['f_name'],
        "l_name" => $userData['l_name'],
        "phone_no" => $userData['phone_no'] ?? '',
        "birthdate" => $userData['birthdate'] ?? '',
        "gender" => $userData['gender'] ?? '',
        "loyalty_points" => $userData['loyalty_points'] ?? 0,
        "avatar" => ($userData['avatar'] ?? '') ?: 'uploads/avatar.png',
        "street_address" => $addressData ? ($addressData['address1'] . ' ' . $addressData['address2']) : '',
        "city" => $addressData ? $addressData['city'] : '',
        "state" => '', // Not in your database
        "zip_code" => $addressData ? $addressData['postal_code'] : '',
        "country" => $addressData ? $addressData['country'] : '',
        "role_id" => $userData['role_id'] ?? 7,
        "status" => $userData['status'] ?? 'active',
        "created_at" => $userData['created_at'] ?? ''
    ];
    
    echo json_encode([
        "status" => "success",
        "userData" => $profileData
    ]);
    
    $userStmt->close();
    $addressStmt->close();
    
} catch (Exception $e) {
    echo json_encode([
        "status" => "error",
        "message" => "Database error: " . $e->getMessage()
    ]);
}

$conn->close();
?>
