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

// Database connection
require_once 'config/db.php';

try {
    // Get user ID from session
    $userId = $_SESSION['user_id'];
    
    // Prepare SQL query to get both user-specific and global notifications
    $stmt = $conn->prepare("
        SELECT id, title, content, created_at, status 
        FROM notification 
        WHERE user_id = ? OR user_id IS NULL 
        ORDER BY created_at DESC 
        LIMIT 20
    ");
    
    $stmt->bind_param("i", $userId);
    $stmt->execute();
    $result = $stmt->get_result();
    
    $notifications = [];
    while ($row = $result->fetch_assoc()) {
        $notifications[] = [
            'id' => $row['id'],
            'title' => $row['title'],
            'message' => $row['content'],
            'timestamp' => $row['created_at'],
            'status' => $row['status']
        ];
    }
    
    echo json_encode([
        'status' => 'success',
        'notifications' => $notifications
    ]);
    
} catch (Exception $e) {
    echo json_encode([
        'status' => 'error',
        'message' => 'Error fetching notifications: ' . $e->getMessage()
    ]);
}

$stmt->close();
$conn->close();
?> 