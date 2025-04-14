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
    
    // Prepare SQL query to mark notification as read
    $stmt = $conn->prepare("
        UPDATE notification 
        SET status = 'read' 
        WHERE id = ? AND user_id = ?
    ");
    
    $stmt->bind_param("ii", $notificationId, $userId);
    $result = $stmt->execute();
    
    if ($result) {
        // Get updated notification data
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
    
} catch (Exception $e) {
    echo json_encode([
        'status' => 'error',
        'message' => 'Error updating notification: ' . $e->getMessage()
    ]);
}

$stmt->close();
$conn->close();
?> 