<?php
// Ensure session cookie works across the whole site and is compatible with modern browsers
if (session_status() === PHP_SESSION_NONE) {
    $cookieParams = session_get_cookie_params();
    session_set_cookie_params([
        'lifetime' => 0,
        'path' => '/',
        'domain' => $cookieParams['domain'] ?? '',
        'secure' => (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off'),
        'httponly' => true,
        'samesite' => 'Lax'
    ]);
    session_start();
}
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
        session_regenerate_id(true);
        $_SESSION['username'] = $row['email'];
        $_SESSION['role_id'] = $row['role_id'] ?? 7; // Default to customer role
        $_SESSION['user_id'] = $row['id'];
        $_SESSION['user_status'] = $row['status'];
        // Ensure session is saved before sending response
        session_write_close();
        
        // Determine redirect based on user role_id
        $redirect = "dashboard.html"; // Default redirect
        if(in_array($_SESSION['role_id'], [1, 2, 3, 4, 5, 6])) {
            $redirect = "admin/admindashboard.php"; // Admin redirect for role_id 1-6
        }
        
        // Send all necessary user data and redirect to HTML page
        echo json_encode([
            "status" => "success",
            "username" => $row['email'],
            "role_id" => $row['role_id'] ?? 7,
            "id" => $row['id'],
            "user_status" => $row['status'],
            "redirect" => $redirect,
            "userData" => [
                "email" => $row['email'],
                "role_id" => $row['role_id'] ?? 7,
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
