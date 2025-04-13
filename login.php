<?php
session_start();
$connect = new mysqli('localhost', 'root', '', 'store'); 
if ($connect->connect_error) {
    die("Connection failed: " . $connect->connect_error);
}
header("Content-Type: application/json");

// Get user input
$email = $_POST['email'] ?? '';
$password = $_POST['password'] ?? '';
$query = "SELECT * FROM users WHERE email='$email'";
$res = mysqli_query($connect, $query);
$row = mysqli_fetch_array($res);
$hashpass = $row['password'] ?? '';

if(is_array($row)){
    if($row['status']==='active'){
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
}else{
    echo json_encode([
        "status" => "error", 
        "message" => "User Has Been Blocked"
    ]);
}
} else {
    echo json_encode([
        "status" => "error", 
        "message" => "User not found"
    ]);
}
?>
