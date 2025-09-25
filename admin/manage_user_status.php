<?php
session_start();
require_once '../config/db.php';

// Check if user is admin (role_id 1 or 2)
if (!isset($_SESSION['role_id']) || !in_array($_SESSION['role_id'], [1, 2])) {
    header('Location: ../index.html');
    exit();
}

header("Content-Type: application/json");

$action = $_POST['action'] ?? '';
$user_id = $_POST['user_id'] ?? '';
$new_status = $_POST['new_status'] ?? '';
$reason = $_POST['reason'] ?? '';

if (empty($action) || empty($user_id) || empty($new_status)) {
    echo json_encode([
        "status" => "error",
        "message" => "Missing required parameters"
    ]);
    exit();
}

// Validate status - using existing database values
$valid_statuses = ['active', 'deactivated', 'blocked'];
if (!in_array($new_status, $valid_statuses)) {
    echo json_encode([
        "status" => "error",
        "message" => "Invalid status value"
    ]);
    exit();
}

try {
    // Get current user status
    $getStatusQuery = "SELECT status, email FROM users WHERE id = ?";
    $getStatusStmt = $conn->prepare($getStatusQuery);
    $getStatusStmt->bind_param("i", $user_id);
    $getStatusStmt->execute();
    $result = $getStatusStmt->get_result();
    $user = $result->fetch_assoc();
    $getStatusStmt->close();
    
    if (!$user) {
        echo json_encode([
            "status" => "error",
            "message" => "User not found"
        ]);
        exit();
    }
    
    $old_status = $user['status'];
    
    // Update user status (using existing status field)
    $updateQuery = "UPDATE users SET status = ? WHERE id = ?";
    $updateStmt = $conn->prepare($updateQuery);
    $updateStmt->bind_param("si", $new_status, $user_id);
    $updateStmt->execute();
    $updateStmt->close();
    
    // Send success response
    echo json_encode([
        "status" => "success",
        "message" => "User status updated successfully",
        "data" => [
            "user_id" => $user_id,
            "email" => $user['email'],
            "old_status" => $old_status,
            "new_status" => $new_status,
            "changed_by" => $_SESSION['user_id'],
            "reason" => $reason
        ]
    ]);
    
} catch (Exception $e) {
    echo json_encode([
        "status" => "error",
        "message" => "Database error: " . $e->getMessage()
    ]);
}

$conn->close();
?>
