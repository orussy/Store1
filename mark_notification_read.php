<?php
session_start();
header('Content-Type: application/json');

// Check if user is logged in
if (!isset($_SESSION['user_id'])) {
    echo json_encode([
        'status' => 'error',
        'message' => 'Authentication required'
    ]);
    exit;
}

// Check if notification ID is provided
if (!isset($_POST['notification_id'])) {
    echo json_encode([
        'status' => 'error',
        'message' => 'Notification ID is required'
    ]);
    exit;
}

// Database connection
require_once 'config/db.php';

try {
    // Get user ID from session
    $userId = $_SESSION['user_id'];
    $notificationId = $_POST['notification_id'];
    
    // First, check if this is a global notification
    $checkStmt = $conn->prepare("
        SELECT id, title, content, user_id 
        FROM notification 
        WHERE id = ?
    ");
    $checkStmt->bind_param("i", $notificationId);
    $checkStmt->execute();
    $result = $checkStmt->get_result();
    $notification = $result->fetch_assoc();
    $checkStmt->close();
    
    if ($notification) {
        if ($notification['user_id'] === null) {
            // This is a global notification - create a user-specific copy
            $insertStmt = $conn->prepare("
                INSERT INTO notification (user_id, title, content, status, original_notification_id)
                VALUES (?, ?, ?, 'read', ?)
            ");
            $insertStmt->bind_param("issi", $userId, $notification['title'], $notification['content'], $notificationId);
            $insertResult = $insertStmt->execute();
            $insertStmt->close();
            
            if ($insertResult) {
                $newNotificationId = $conn->insert_id;
                // Get the newly created notification
                $selectStmt = $conn->prepare("
                    SELECT id, title, content, status, created_at 
                    FROM notification 
                    WHERE id = ?
                ");
                $selectStmt->bind_param("i", $newNotificationId);
                $selectStmt->execute();
                $notificationResult = $selectStmt->get_result();
                $notification = $notificationResult->fetch_assoc();
                $selectStmt->close();
            }
        } else {
            // This is a user-specific notification - mark it as read
            $updateStmt = $conn->prepare("
                UPDATE notification 
                SET status = 'read' 
                WHERE id = ? AND user_id = ?
            ");
            $updateStmt->bind_param("ii", $notificationId, $userId);
            $updateResult = $updateStmt->execute();
            $updateStmt->close();
            
            if ($updateResult) {
                // Get the updated notification
                $selectStmt = $conn->prepare("
                    SELECT id, title, content, status, created_at 
                    FROM notification 
                    WHERE id = ? AND user_id = ?
                ");
                $selectStmt->bind_param("ii", $notificationId, $userId);
                $selectStmt->execute();
                $notificationResult = $selectStmt->get_result();
                $notification = $notificationResult->fetch_assoc();
                $selectStmt->close();
            }
        }
        
        if ($notification) {
            echo json_encode([
                'status' => 'success',
                'message' => 'Notification marked as read',
                'notification' => $notification
            ]);
        } else {
            echo json_encode([
                'status' => 'error',
                'message' => 'Failed to mark notification as read'
            ]);
        }
    } else {
        echo json_encode([
            'status' => 'error',
            'message' => 'Notification not found'
        ]);
    }
    
} catch (Exception $e) {
    echo json_encode([
        'status' => 'error',
        'message' => 'Error updating notification: ' . $e->getMessage()
    ]);
}

$conn->close();
?> 