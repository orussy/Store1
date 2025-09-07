<?php
session_start();
require_once '../config/db.php';

// Check if user is admin
if (!isset($_SESSION['role']) || $_SESSION['role'] !== 'admin') {
    header('Location: ../index.html');
    exit();
}

header("Content-Type: application/json");

try {
    // Get all users (using existing database structure)
    $query = "SELECT id, f_name, l_name, email, status, role FROM users ORDER BY id";
    $stmt = $conn->prepare($query);
    $stmt->execute();
    $result = $stmt->get_result();
    
    $users = [];
    while ($row = $result->fetch_assoc()) {
        $users[] = [
            "id" => $row['id'],
            "f_name" => $row['f_name'],
            "l_name" => $row['l_name'],
            "email" => $row['email'],
            "status" => $row['status'],
            "role" => $row['role']
        ];
    }
    
    $stmt->close();
    
    echo json_encode([
        "status" => "success",
        "users" => $users
    ]);
    
} catch (Exception $e) {
    echo json_encode([
        "status" => "error",
        "message" => "Database error: " . $e->getMessage()
    ]);
}

$conn->close();
?>
