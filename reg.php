<?php

session_start();
$connect = new mysqli('localhost', 'root', '', 'store'); 
if ($connect->connect_error) {
    die("Connection failed: " . $connect->connect_error);
}

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
$query = "INSERT INTO users (`avatar`, `f_name`, `l_name`, `email`, `password`, `birthdate`, `phone_no`, `gender`)
VALUES ('$avatar', '$f_name', '$l_name', '$email', '$hashpass', '$birthdate', '$phone_no', '$gender')";

try {
    if (!mysqli_query($connect, $query)) {
        throw new Exception("MySQL Error: " . mysqli_error($connect));
    }
    $query1 = "SELECT id FROM users WHERE email='$email'";
    $result = mysqli_query($connect, $query1);
    if (!$result) {
        throw new Exception("MySQL Error: " . mysqli_error($connect));
    }
    $row = mysqli_fetch_assoc($result);
    $user_id = $row['id'];
    $query2 = "INSERT INTO cart(`user_id`) VALUES('$user_id')";
    if (!mysqli_query($connect, $query2)) {
        throw new Exception("MySQL Error: " . mysqli_error($connect));
    }
    echo json_encode(["status" => "success", "message" => "User registered successfully"]);
} catch (Exception $e) {
    echo json_encode(["status" => "error", "message" => $e->getMessage()]);
}
?>
