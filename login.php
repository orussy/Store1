<?php
session_start();
require_once 'config/db.php';

header("Content-Type: application/json");

// Get user input
$email = $_POST['email'] ?? '';
$password = $_POST['password'] ?? '';

// Use prepared statement to prevent SQL injection
$query = "SELECT * FROM users WHERE email=?";
$stmt = $conn->prepare($query);
$stmt->bind_param("s", $email);
$stmt->execute();
$result = $stmt->get_result();
$row = $result->fetch_assoc();
$hashpass = $row['password'] ?? '';

if($row){
    // Check if user is blocked (blocked users cannot login)
    if($row['status'] === 'blocked'){
        echo json_encode([
            "status" => "error", 
            "message" => "Your account has been blocked. Please contact support."
        ]);
        $stmt->close();
        $conn->close();
        exit();
    }
    
    // Check if password is correct
    if(password_verify($password, $hashpass)){
        // Auto-reactivate deactivated users when they login
        if($row['status'] === 'deactivated'){
            // Update status to active (using existing status field)
            $updateQuery = "UPDATE users SET status = 'active' WHERE id = ?";
            $updateStmt = $conn->prepare($updateQuery);
            $updateStmt->bind_param("i", $row['id']);
            $updateStmt->execute();
            $updateStmt->close();
            
            // Update the row data
            $row['status'] = 'active';
        }
        
        // Set session variables
        $_SESSION['username'] = $row['email'];
        $_SESSION['role'] = $row['role'] ?? 'user';
        $_SESSION['user_id'] = $row['id'];
        $_SESSION['user_status'] = $row['status'];
        
        // Determine redirect based on user role
        $redirect = "dashboard.html"; // Default redirect
        if(($_SESSION['role'] === 'admin')) {
            $redirect = "admin/admindashboard.php"; // Admin redirect
        }
        
        // Send all necessary user data and redirect to HTML page
        echo json_encode([
            "status" => "success",
            "username" => $row['email'],
            "role" => $row['role'] ?? 'user',
            "id" => $row['id'],
            "user_status" => $row['status'],
            "redirect" => $redirect,
            "userData" => [
                "email" => $row['email'],
                "role" => $row['role'] ?? 'user',
                "name" => $row['f_name']." ".$row['l_name'] ?? '',
                "id" => $row['id'],
                "status" => $row['status'],
                "avatar" => $row['avatar'] ?? ''
            ]
        ]);
    } else {
        echo json_encode([
            "status" => "error", 
            "message" => "Invalid email or password"
        ]);
    }
} else {
    echo json_encode([
        "status" => "error", 
        "message" => "User not found"
    ]);
}

$stmt->close();
$conn->close();
?>
