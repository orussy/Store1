<?php
session_start();
header('Content-Type: application/json');

if (!isset($_SESSION['username'])) {
    echo json_encode([
        "status" => "error",
        "message" => "Not logged in"
    ]);
    exit;
}

try {
    $connect = new mysqli('localhost', 'root', '', 'store');
    if ($connect->connect_error) {
        throw new Exception("Connection failed: " . $connect->connect_error);
    }

    $data = json_decode(file_get_contents('php://input'), true);
    
    $email = $_SESSION['username'];
    $f_name = $data['f_name'] ?? '';
    $l_name = $data['l_name'] ?? '';
    $birthdate = $data['birthdate'] ?? null;
    $phone_no = $data['phone_no'] ?? '';
    $gender = $data['gender'] ?? '';

    $sql = "UPDATE users SET 
            f_name = ?, 
            l_name = ?, 
            birthdate = ?, 
            phone_no = ?, 
            gender = ? 
            WHERE email = ?";

    $stmt = $connect->prepare($sql);
    if (!$stmt) {
        throw new Exception("Prepare failed: " . $connect->error);
    }

    $stmt->bind_param("ssssss", $f_name, $l_name, $birthdate, $phone_no, $gender, $email);
    
    if (!$stmt->execute()) {
        throw new Exception("Update failed: " . $stmt->error);
    }

    echo json_encode([
        "status" => "success",
        "message" => "Profile updated successfully"
    ]);

} catch (Exception $e) {
    echo json_encode([
        "status" => "error",
        "message" => $e->getMessage()
    ]);
}

$connect->close();
?> 