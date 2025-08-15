<?php
session_start();
require_once 'config/db.php';

header("Content-Type: application/json");

// Check if user has temporary data in session
if (!isset($_SESSION['temp_user'])) {
    echo json_encode([
        "status" => "error",
        "message" => "No verification session found. Please register again."
    ]);
    exit;
}

$verification_code = $_POST['verification_code'] ?? '';
$temp_user = $_SESSION['temp_user'];

// Check if verification code matches (convert both to strings for comparison)
if ((string)$verification_code !== (string)$temp_user['verification_code']) {
    echo json_encode([
        "status" => "error",
        "message" => "Invalid verification code. Please check your email and try again. Expected: " . $temp_user['verification_code'] . ", Received: " . $verification_code
    ]);
    exit;
}

// Check if code is expired (10 minutes)
$created_time = strtotime($temp_user['created_at']);
$current_time = time();
$time_diff = $current_time - $created_time;

if ($time_diff > 600) { // 10 minutes = 600 seconds
    // Clear expired session
    unset($_SESSION['temp_user']);
    echo json_encode([
        "status" => "error",
        "message" => "Verification code has expired. Please register again."
    ]);
    exit;
}

try {
    // Start transaction
    $conn->begin_transaction();

    // Create user folder and avatar
    $folderName = "uploads/" . $temp_user['email'];
    if (!file_exists($folderName)) {
        mkdir($folderName, 0777, true);
        copy("uploads/avatar.png", $folderName . "/avatar.png");
    }
    $avatar = $folderName . "/avatar.png";

    // Insert user data (let MySQL auto-increment the ID)
    $query = "INSERT INTO users (`avatar`, `f_name`, `l_name`, `email`, `password`, `birthdate`, `phone_no`, `gender`, `status`, `role`) 
              VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'active', 'user')";
    $stmt = $conn->prepare($query);
    $stmt->bind_param("ssssssss", 
        $avatar, 
        $temp_user['f_name'], 
        $temp_user['l_name'], 
        $temp_user['email'], 
        $temp_user['password'], 
        $temp_user['birthdate'], 
        $temp_user['phone_no'], 
        $temp_user['gender']
    );
    
    if (!$stmt->execute()) {
        throw new Exception("Error inserting user: " . $stmt->error);
    }
    
    // Get the user ID
    $user_id = $conn->insert_id;
    
    // Create cart for user
    $query2 = "INSERT INTO cart(`user_id`) VALUES(?)";
    $stmt2 = $conn->prepare($query2);
    $stmt2->bind_param("i", $user_id);
    
    if (!$stmt2->execute()) {
        throw new Exception("Error creating cart: " . $stmt2->error);
    }
    
    // Commit transaction
    $conn->commit();
    
    // Clear temporary session data
    unset($_SESSION['temp_user']);
    
    echo json_encode([
        "status" => "success",
        "message" => "Email verified successfully! Your account has been created."
    ]);

} catch (Exception $e) {
    // Rollback transaction on error
    $conn->rollback();
    echo json_encode([
        "status" => "error",
        "message" => "Error creating account: " . $e->getMessage()
    ]);
} finally {
    // Close statements and connection
    if (isset($stmt)) $stmt->close();
    if (isset($stmt2)) $stmt2->close();
    $conn->close();
}
?>
