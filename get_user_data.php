<?php
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

header('Content-Type: application/json');

if (isset($_SESSION['user_id'])) {
    echo json_encode([
        'user_id' => $_SESSION['user_id'],
        'email' => $_SESSION['username'] ?? null,
        'role_id' => $_SESSION['role_id'] ?? 7,
        'status' => $_SESSION['user_status'] ?? 'active'
    ]);
} else {
    http_response_code(401);
    echo json_encode(['error' => 'Not authenticated']);
}
?> 