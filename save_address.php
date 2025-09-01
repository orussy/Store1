<?php
header('Content-Type: application/json');

// Debug: Log all incoming data
error_log("=== Address Form Debug ===");
error_log("POST data: " . print_r($_POST, true));

// Check if user_id is provided in POST data (for localStorage auth)
if (!isset($_POST['user_id']) || empty($_POST['user_id'])) {
    echo json_encode(['status' => 'error', 'message' => 'User ID not provided']);
    exit();
}

$user_id = intval($_POST['user_id']);

// Validate required fields including new required coordinates
$required_fields = ['title', 'address1', 'country', 'city', 'postal_code', 'latitude', 'longitude'];
$missing_fields = [];

foreach ($required_fields as $field) {
    if (!isset($_POST[$field]) || empty($_POST[$field])) {
        $missing_fields[] = $field;
    }
}

if (!empty($missing_fields)) {
    echo json_encode([
        'status' => 'error', 
        'message' => 'Missing required fields: ' . implode(', ', $missing_fields),
        'debug' => [
            'post_data' => $_POST,
            'missing_fields' => $missing_fields
        ]
    ]);
    exit();
}

// Validate coordinates
$latitude = floatval($_POST['latitude']);
$longitude = floatval($_POST['longitude']);
if (!is_numeric($latitude) || !is_numeric($longitude)) {
    echo json_encode([
        'status' => 'error', 
        'message' => 'Invalid coordinates',
        'debug' => [
            'latitude' => $latitude,
            'longitude' => $longitude,
            'latitude_type' => gettype($latitude),
            'longitude_type' => gettype($longitude)
        ]
    ]);
    exit();
}

try {
    // Include database configuration
    require_once 'config/db.php';
    
    $title = $_POST['title'];
    $address1 = $_POST['address1'];
    $address2 = $_POST['address2'] ?? null;
    if ($address2 === null) $address2 = "";
    $country = $_POST['country'];
    $city = $_POST['city'];
    $postal_code = $_POST['postal_code'];
    $allowed = ['exact','approximate','general'];
    $location_accuracy = in_array($_POST['location_accuracy'] ?? 'approximate', $allowed)
    ? $_POST['location_accuracy']
    : 'approximate';
    $address_id = $_POST['address_id'] ?? null;
    
    error_log("Processing address - ID: " . ($address_id ?: 'NEW') . ", User: $user_id");
    error_log("Coordinates: lat=$latitude, lng=$longitude");
    
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
            echo json_encode(['status' => 'error', 'message' => 'Failed to update address: ' . $stmt->error]);
        }
        
        $stmt->close();
    } else {
        // Insert new address
        $stmt = $conn->prepare("
            INSERT INTO addresses (user_id, title, address1, address2, country, city, 
                                 postal_code, latitude, longitude, location_accuracy, created_at)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW())
        ");
        
        // 10 parameters: i,s,s,s,s,s,s,d,d,s - CORRECT type string with 10 characters
        $stmt->bind_param("issssssdds", $user_id, $title, $address1, $address2, $country, 
                         $city, $postal_code, $latitude, $longitude, $location_accuracy);
        
        if ($stmt->execute()) {
            $new_address_id = $conn->insert_id;
            echo json_encode([
                'status' => 'success', 
                'message' => 'Address added successfully',
                'debug' => [
                    'new_address_id' => $new_address_id,
                    'affected_rows' => $stmt->affected_rows
                ]
            ]);
        } else {
            echo json_encode([
                'status' => 'error', 
                'message' => 'Failed to add address: ' . $stmt->error,
                'debug' => [
                    'sql_error' => $stmt->error,
                    'errno' => $stmt->errno
                ]
            ]);
        }
        
        $stmt->close();
    }
    
} catch (Exception $e) {
    echo json_encode([
        'status' => 'error',
        'message' => 'Database error: ' . $e->getMessage(),
        'debug' => [
            'exception' => $e->getMessage(),
            'trace' => $e->getTraceAsString()
        ]
    ]);
}
?>
