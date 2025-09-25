<?php
session_start();
require_once '../config/db.php';

// Check if user is admin (role_id 1 or 2)
if (!isset($_SESSION['role_id']) || !in_array($_SESSION['role_id'], [1, 2])) {
    header('Location: ../index.html');
    exit();
}

header("Content-Type: application/json");

try {
    // Get all users with role information
    $query = "SELECT u.id, u.f_name, u.l_name, u.email, u.status, u.role_id, r.name as role_name 
              FROM users u 
              LEFT JOIN roles r ON u.role_id = r.id 
              ORDER BY u.id";
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
            "role_id" => $row['role_id'],
            "role_name" => $row['role_name'] ?? 'Unknown'
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
