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
    if($row['status'] === 'active'){
        if(password_verify($password, $hashpass)){
            $_SESSION['username'] = $row['email'];
            $_SESSION['role'] = $row['role'] ?? 'user';
            $_SESSION['user_id'] = $row['id']; // Store user_id in session
            
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
                "redirect" => $redirect,
                "userData" => [
                    "email" => $row['email'],
                    "role" => $row['role'] ?? 'user',
                    "name" => $row['f_name']." ".$row['l_name'] ?? '',
                    "id" => $row['id']
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
            "message" => "User Has Been blocked"
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
