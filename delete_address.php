<?php
session_start();
header('Content-Type: application/json');

// Check if user is logged in
if (!isset($_SESSION['user_id'])) {
    echo json_encode(['status' => 'error', 'message' => 'User not logged in']);
    exit();
}

$user_id = $_SESSION['user_id'];

// Check if address_id is provided
if (!isset($_POST['address_id']) || empty($_POST['address_id'])) {
    echo json_encode(['status' => 'error', 'message' => 'Address ID is required']);
    exit();
}

$address_id = $_POST['address_id'];

try {
    // Include database configuration
    require_once 'config/db.php';
    
    // Soft delete the address (set deleted_at timestamp)
    $stmt = $conn->prepare("
        UPDATE addresses 
        SET deleted_at = NOW() 
        WHERE id = ? AND user_id = ? AND deleted_at IS NULL
    ");
    
    $stmt->bind_param("ii", $address_id, $user_id);
    
    if ($stmt->execute()) {
        if ($stmt->affected_rows > 0) {
            echo json_encode(['status' => 'success', 'message' => 'Address deleted successfully']);
        } else {
            echo json_encode(['status' => 'error', 'message' => 'Address not found or already deleted']);
        }
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Failed to delete address']);
    }
    
    $stmt->close();
    
} catch (Exception $e) {
    echo json_encode([
        'status' => 'error',
        'message' => 'Database error: ' . $e->getMessage()
    ]);
}
?>
