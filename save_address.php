<?php
header('Content-Type: application/json');
session_start();

try {
    require_once 'config/db.php';
    
    // Validate required fields
    $required = ['user_id', 'title', 'address1', 'country', 'city', 'postal_code', 'latitude', 'longitude'];
    // Note: address_id is optional (empty for new addresses, set for updates)
    foreach ($required as $field) {
        if (empty($_POST[$field])) {
            echo json_encode(['status' => 'error', 'message' => "Missing required field: $field"]);
            exit;
        }
    }
    
    $user_id = intval($_POST['user_id']);
    
    // Assign variables for bind_param (requires variables by reference)
    $title = $_POST['title'];
    $address1 = $_POST['address1'];
    $address2 = $_POST['address2'] ?? '';
    $country = $_POST['country'];
    $city = $_POST['city'];
    $postal_code = $_POST['postal_code'];
    $latitude = floatval($_POST['latitude']);
    $longitude = floatval($_POST['longitude']);
    $location_accuracy = $_POST['location_accuracy'] ?? 'exact';
    
    // Check if this is an update (address_id provided) or insert (new address)
    if (!empty($_POST['address_id'])) {
        // ===== UPDATE EXISTING ADDRESS =====
        $address_id = intval($_POST['address_id']);
        
        $sql = "UPDATE addresses SET 
                title = ?, address1 = ?, address2 = ?, country = ?, city = ?,
                postal_code = ?, latitude = ?, longitude = ?, location_accuracy = ?
                WHERE id = ? AND user_id = ? AND deleted_at IS NULL";
        
        $stmt = $conn->prepare($sql);
        $stmt->bind_param("ssssssddsii",
            $title,
            $address1,
            $address2,
            $country,
            $city,
            $postal_code,
            $latitude,
            $longitude,
            $location_accuracy,
            $address_id,
            $user_id
        );
        
        if ($stmt->execute()) {
            if ($stmt->affected_rows > 0) {
                echo json_encode(['status' => 'success', 'message' => 'Address updated successfully', 'id' => $address_id]);
            } else {
                echo json_encode(['status' => 'error', 'message' => 'Address not found or no changes made']);
            }
        } else {
            echo json_encode(['status' => 'error', 'message' => 'Update failed']);
        }
        
        $stmt->close();
        
    } else {
        // ===== INSERT NEW ADDRESS =====
        $sql = "INSERT INTO addresses (user_id, title, address1, address2, country, city, postal_code, latitude, longitude, location_accuracy, created_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW())";
        
        $stmt = $conn->prepare($sql);
        $stmt->bind_param("issssssdds",
            $user_id,
            $title,
            $address1,
            $address2,
            $country,
            $city,
            $postal_code,
            $latitude,
            $longitude,
            $location_accuracy
        );
        
        if ($stmt->execute()) {
            echo json_encode(['status' => 'success', 'message' => 'Address saved successfully', 'id' => $conn->insert_id]);
        } else {
            echo json_encode(['status' => 'error', 'message' => 'Save failed']);
        }
        
        $stmt->close();
    }
    
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode([
        'status' => 'error', 
        'message' => $e->getMessage(),
        'debug' => $_POST
    ]);
    exit;
} catch (Error $e) {
    http_response_code(500);
    echo json_encode([
        'status' => 'error', 
        'message' => 'Fatal error: ' . $e->getMessage(),
        'debug' => $_POST
    ]);
    exit;
}

$conn->close();
?>
