<?php
session_start();
header('Content-Type: application/json');

// Check if user is logged in
if (!isset($_SESSION['user_id'])) {
    echo json_encode(['status' => 'error', 'message' => 'User not logged in']);
    exit();
}

$user_id = $_SESSION['user_id'];

// Validate required fields including new required coordinates
$required_fields = ['title', 'address1', 'country', 'city', 'postal_code', 'latitude', 'longitude'];
foreach ($required_fields as $field) {
    if (!isset($_POST[$field]) || empty($_POST[$field])) {
        echo json_encode(['status' => 'error', 'message' => "Field '$field' is required"]);
        exit();
    }
}

// Validate coordinates
$latitude = $_POST['latitude'];
$longitude = $_POST['longitude'];
if (!is_numeric($latitude) || !is_numeric($longitude)) {
    echo json_encode(['status' => 'error', 'message' => 'Invalid coordinates']);
    exit();
}

try {
    // Include database configuration
    require_once 'config/db.php';
    
    $title = $_POST['title'];
    $address1 = $_POST['address1'];
    $address2 = $_POST['address2'] ?? null;
    $country = $_POST['country'];
    $city = $_POST['city'];
    $postal_code = $_POST['postal_code'];
    $location_accuracy = $_POST['location_accuracy'] ?? 'approximate';
    $address_id = $_POST['address_id'] ?? null;
    
    if ($address_id) {
        // Update existing address
        $stmt = $conn->prepare("
            UPDATE addresses 
            SET title = ?, address1 = ?, address2 = ?, country = ?, city = ?, 
                postal_code = ?, latitude = ?, longitude = ?, location_accuracy = ?
            WHERE id = ? AND user_id = ? AND deleted_at IS NULL
        ");
        
        $stmt->bind_param("ssssssddssii", $title, $address1, $address2, $country, $city, 
                         $postal_code, $latitude, $longitude, $location_accuracy, $address_id, $user_id);
        
        if ($stmt->execute()) {
            if ($stmt->affected_rows > 0) {
                echo json_encode(['status' => 'success', 'message' => 'Address updated successfully']);
            } else {
                echo json_encode(['status' => 'error', 'message' => 'Address not found or no changes made']);
            }
        } else {
            echo json_encode(['status' => 'error', 'message' => 'Failed to update address']);
        }
        
        $stmt->close();
    } else {
        // Insert new address
        $stmt = $conn->prepare("
            INSERT INTO addresses (user_id, title, address1, address2, country, city, 
                                 postal_code, latitude, longitude, location_accuracy, created_at)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW())
        ");
        
        $stmt->bind_param("isssssdds", $user_id, $title, $address1, $address2, $country, 
                         $city, $postal_code, $latitude, $longitude, $location_accuracy);
        
        if ($stmt->execute()) {
            echo json_encode(['status' => 'success', 'message' => 'Address added successfully']);
        } else {
            echo json_encode(['status' => 'error', 'message' => 'Failed to add address']);
        }
        
        $stmt->close();
    }
    
} catch (Exception $e) {
    echo json_encode([
        'status' => 'error',
        'message' => 'Database error: ' . $e->getMessage()
    ]);
}
?>
