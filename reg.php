<?php

session_start();
require_once 'config/db.php';

// Enable detailed error reporting
error_reporting(E_ALL);
ini_set('display_errors', 1);

header("Content-Type: application/json");

$f_name = $_POST['f_name'] ?? '';
$l_name = $_POST['l_name'] ?? '';
$email = $_POST['email'] ?? '';
$password = $_POST['password'] ?? '';
$birthdate = $_POST['birthdate'] ?? '';
$phone_no = $_POST['phone_no'] ?? '';
$gender = $_POST['gender'] ?? '';
$hashpass = password_hash($password, PASSWORD_DEFAULT);

$folderName = "uploads/" . $email;
if (!file_exists($folderName)) {
    mkdir($folderName, 0777, true);
    copy("uploads/avatar.png", $folderName . "/avatar.png");
}
$avatar = $folderName . "/avatar.png";

try {
    // Start transaction
    $conn->begin_transaction();

    // Insert user data with prepared statement
    $query = "INSERT INTO users (`avatar`, `f_name`, `l_name`, `email`, `password`, `birthdate`, `phone_no`, `gender`) 
              VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
    $stmt = $conn->prepare($query);
    $stmt->bind_param("ssssssss", $avatar, $f_name, $l_name, $email, $hashpass, $birthdate, $phone_no, $gender);
    
    if (!$stmt->execute()) {
        throw new Exception("Error inserting user: " . $stmt->error);
    }
    
    // Get the user ID
    $user_id = $conn->insert_id;
    
    // Create cart for user with prepared statement
    $query2 = "INSERT INTO cart(`user_id`) VALUES(?)";
    $stmt2 = $conn->prepare($query2);
    $stmt2->bind_param("i", $user_id);
    
    if (!$stmt2->execute()) {
        throw new Exception("Error creating cart: " . $stmt2->error);
    }
    
    // Commit transaction
    $conn->commit();
    
    echo json_encode([
        "status" => "success", 
        "message" => "User registered successfully"
    ]);

} catch (Exception $e) {
    // Rollback transaction on error
    $conn->rollback();
    echo json_encode([
        "status" => "error", 
        "message" => $e->getMessage()
    ]);
} finally {
    // Close statements and connection
    if (isset($stmt)) $stmt->close();
    if (isset($stmt2)) $stmt2->close();
    $conn->close();
}
?>
