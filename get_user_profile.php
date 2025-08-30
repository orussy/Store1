<?php
session_start();
header("Content-Type: application/json");

require_once 'config/db.php';

// Check if user is logged in
if (!isset($_SESSION['user_id'])) {
    echo json_encode([
        "status" => "error",
        "message" => "User not authenticated"
    ]);
    exit();
}

// Get user ID from session
$userId = $_SESSION['user_id'];

try {
    // Get user data from users table
    $userQuery = "SELECT id, email, f_name, l_name, phone_no, birthdate, 
                         role, status, created_at, gender, loyalty_points, avatar
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
        "phone" => $userData['phone_no'] ?? '',
        "date_of_birth" => $userData['birthdate'] ?? '',
        "gender" => $userData['gender'] ?? '',
        "loyalty_points" => $userData['loyalty_points'] ?? 0,
        "avatar" => ($userData['avatar'] ?? '') ?: 'uploads/avatar.png',
        "street_address" => $addressData ? ($addressData['address1'] . ' ' . $addressData['address2']) : '',
        "city" => $addressData ? $addressData['city'] : '',
        "state" => '', // Not in your database
        "zip_code" => $addressData ? $addressData['postal_code'] : '',
        "country" => $addressData ? $addressData['country'] : '',
        "role" => $userData['role'] ?? 'user',
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
