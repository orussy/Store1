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

// Get POST data
$input = json_decode(file_get_contents('php://input'), true);

if (!isset($input['setting']) || !isset($input['value'])) {
    echo json_encode([
        "status" => "error",
        "message" => "Missing required parameters"
    ]);
    exit();
}

$userId = $_SESSION['user_id']; // Get user ID from session
$setting = $input['setting'];
$value = $input['value'];

// Validate setting type
$allowedSettings = ['email_notifications', 'two_factor_auth'];
if (!in_array($setting, $allowedSettings)) {
    echo json_encode([
        "status" => "error",
        "message" => "Invalid setting specified"
    ]);
    exit();
}

// Convert boolean value to integer for database
$dbValue = $value ? 1 : 0;

try {
    // Check if user_settings table exists, if not create it
    $checkTableQuery = "SHOW TABLES LIKE 'user_settings'";
    $tableResult = $conn->query($checkTableQuery);
    
    if ($tableResult->num_rows === 0) {
        // Create user_settings table
        $createTableQuery = "CREATE TABLE user_settings (
            id INT AUTO_INCREMENT PRIMARY KEY,
            user_id INT NOT NULL,
            setting_name VARCHAR(50) NOT NULL,
            setting_value TINYINT(1) DEFAULT 0,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
            UNIQUE KEY unique_user_setting (user_id, setting_name),
            FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
        )";
        
        if (!$conn->query($createTableQuery)) {
            throw new Exception("Failed to create user_settings table");
        }
    }
    
    // Insert or update the setting
    $query = "INSERT INTO user_settings (user_id, setting_name, setting_value) 
              VALUES (?, ?, ?) 
              ON DUPLICATE KEY UPDATE setting_value = ?";
    
    $stmt = $conn->prepare($query);
    $stmt->bind_param("isii", $userId, $setting, $dbValue, $dbValue);
    
    if ($stmt->execute()) {
        echo json_encode([
            "status" => "success",
            "message" => "Setting updated successfully"
        ]);
    } else {
        echo json_encode([
            "status" => "error",
            "message" => "Failed to update setting"
        ]);
    }
    
    $stmt->close();
    
} catch (Exception $e) {
    echo json_encode([
        "status" => "error",
        "message" => "Database error: " . $e->getMessage()
    ]);
}

$conn->close();
?>
