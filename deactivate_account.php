<?php
session_start();
require_once 'config/db.php';

header("Content-Type: application/json");

// Check if user is logged in
if (!isset($_SESSION['user_id'])) {
    echo json_encode([
        "status" => "error",
        "message" => "You must be logged in to perform this action"
    ]);
    exit();
}

$user_id = $_SESSION['user_id'];
$reason = $_POST['reason'] ?? 'User requested deactivation';

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
    
    // Check if user is already deactivated
    if ($user['status'] === 'deactivated') {
        echo json_encode([
            "status" => "error",
            "message" => "Your account is already deactivated"
        ]);
        exit();
    }
    
    // Check if user is blocked (blocked users cannot deactivate)
    if ($user['status'] === 'blocked') {
        echo json_encode([
            "status" => "error",
            "message" => "Blocked accounts cannot be deactivated"
        ]);
        exit();
    }
    
    $old_status = $user['status'];
    
    // Update user status to deactivated (using existing status field)
    $updateQuery = "UPDATE users SET status = 'deactivated' WHERE id = ?";
    $updateStmt = $conn->prepare($updateQuery);
    $updateStmt->bind_param("i", $user_id);
    $updateStmt->execute();
    $updateStmt->close();
    
    // Destroy session to log user out
    session_destroy();
    
    echo json_encode([
        "status" => "success",
        "message" => "Your account has been deactivated successfully. You will be logged out and can reactivate by logging in again.",
        "data" => [
            "user_id" => $user_id,
            "email" => $user['email'],
            "old_status" => $old_status,
            "new_status" => 'deactivated',
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
