<?php
session_start();
header("Content-Type: application/json");

require_once 'config/db.php';

// Check if user is logged in
if (!isset($_SESSION['user_id'])) {
    echo json_encode([
        "status" => "error",
        "message" => "User not authenticated"
    ]);
    exit();
}

// Check if it's a POST request
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    echo json_encode([
        "status" => "error",
        "message" => "Invalid request method"
    ]);
    exit();
}

$userId = $_SESSION['user_id'];

try {
    // Get form data
    $firstName = trim($_POST['f_name'] ?? '');
    $lastName = trim($_POST['l_name'] ?? '');
    $phone = trim($_POST['phone'] ?? '');
    $birthdate = trim($_POST['birthdate'] ?? '');
    $gender = trim($_POST['gender'] ?? '');
    
    // Validate required fields
    if (empty($firstName) || empty($lastName)) {
        echo json_encode([
            "status" => "error",
            "message" => "First name and last name are required"
        ]);
        exit();
    }
    
    // Validate phone number (optional but if provided, should be valid)
    if (!empty($phone) && !preg_match('/^[0-9+\-\s\(\)]+$/', $phone)) {
        echo json_encode([
            "status" => "error",
            "message" => "Invalid phone number format"
        ]);
        exit();
    }
    
    // Validate birthdate (optional but if provided, should be valid)
    if (!empty($birthdate)) {
        $date = DateTime::createFromFormat('Y-m-d', $birthdate);
        if (!$date || $date->format('Y-m-d') !== $birthdate) {
            echo json_encode([
                "status" => "error",
                "message" => "Invalid date format"
            ]);
            exit();
        }
        
        // Check if birthdate is not in the future
        $today = new DateTime();
        if ($date > $today) {
            echo json_encode([
                "status" => "error",
                "message" => "Birthdate cannot be in the future"
            ]);
            exit();
        }
    }
    
    // Validate gender (optional but if provided, should be valid)
    if (!empty($gender) && !in_array($gender, ['male', 'female', 'other'])) {
        echo json_encode([
            "status" => "error",
            "message" => "Invalid gender selection"
        ]);
        exit();
    }
    
    // Update user profile
    $query = "UPDATE users SET 
              f_name = ?, 
              l_name = ?, 
              phone_no = ?, 
              birthdate = ?, 
              gender = ?
              WHERE id = ? AND deleted_at IS NULL";
    
    $stmt = $conn->prepare($query);
    $stmt->bind_param("sssssi", $firstName, $lastName, $phone, $birthdate, $gender, $userId);
    
    if ($stmt->execute()) {
        if ($stmt->affected_rows > 0) {
            echo json_encode([
                "status" => "success",
                "message" => "Profile updated successfully"
            ]);
        } else {
            echo json_encode([
                "status" => "success",
                "message" => "No changes were made to your profile"
            ]);
        }
    } else {
        echo json_encode([
            "status" => "error",
            "message" => "Database error occurred"
        ]);
    }
    
    $stmt->close();
    
} catch (Exception $e) {
    echo json_encode([
        "status" => "error",
        "message" => "An error occurred: " . $e->getMessage()
    ]);
}

$conn->close();
?>
