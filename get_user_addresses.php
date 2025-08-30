<?php
session_start();
header('Content-Type: application/json');

// Check if user is logged in
if (!isset($_SESSION['user_id'])) {
    echo json_encode(['status' => 'error', 'message' => 'User not logged in']);
    exit();
}

$user_id = $_SESSION['user_id'];

try {
    // Include database configuration
    require_once 'config/db.php';
    
    // Prepare and execute query to get user addresses with new columns
    $stmt = $conn->prepare("
        SELECT id, title, address1, address2, country, city, postal_code, 
               latitude, longitude, location_accuracy, created_at 
        FROM addresses 
        WHERE user_id = ? AND deleted_at IS NULL 
        ORDER BY created_at DESC
    ");
    
    $stmt->bind_param("i", $user_id);
    $stmt->execute();
    $result = $stmt->get_result();
    $addresses = $result->fetch_all(MYSQLI_ASSOC);
    
    if ($addresses) {
        echo json_encode([
            'status' => 'success',
            'addresses' => $addresses
        ]);
    } else {
        echo json_encode([
            'status' => 'success',
            'addresses' => []
        ]);
    }
    
    // Close statement
    $stmt->close();
    
} catch (Exception $e) {
    echo json_encode([
        'status' => 'error',
        'message' => 'Database error: ' . $e->getMessage()
    ]);
}
?>
