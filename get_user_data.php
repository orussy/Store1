<?php
session_start();

header('Content-Type: application/json');

if (isset($_SESSION['username'])) {
    echo json_encode([
        'username' => $_SESSION['username'],
        'role' => $_SESSION['role'] ?? 'user'
    ]);
} else {
    http_response_code(401);
    echo json_encode(['error' => 'Not authenticated']);
}
?> 