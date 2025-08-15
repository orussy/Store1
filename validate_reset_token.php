<?php
session_start();
require_once 'config/db.php';

header("Content-Type: application/json");

// Get token from POST data
$token = $_POST['token'] ?? '';

// Log the token for debugging
error_log("Token received: " . $token);

if (empty($token)) {
    echo json_encode([
        "status" => "error",
        "message" => "Token is required"
    ]);
    exit;
}

// Check if token exists and is valid
$query = "SELECT pr.*, u.email, u.f_name, u.l_name 
          FROM password_resets pr 
          JOIN users u ON pr.user_id = u.id 
          WHERE pr.token = ? AND pr.expires_at > UTC_TIMESTAMP() AND pr.used = 0";
$stmt = $conn->prepare($query);
$stmt->bind_param("s", $token);
$stmt->execute();
$result = $stmt->get_result();
$reset_data = $result->fetch_assoc();

// Log the query result for debugging
error_log("Query result: " . ($reset_data ? "Found" : "Not found"));

if (!$reset_data) {
    // Let's get more detailed information about why the token is invalid
    $debug_query = "SELECT pr.*, u.email, u.f_name, u.l_name 
                    FROM password_resets pr 
                    JOIN users u ON pr.user_id = u.id 
                    WHERE pr.token = ?";
    $debug_stmt = $conn->prepare($debug_query);
    $debug_stmt->bind_param("s", $token);
    $debug_stmt->execute();
    $debug_result = $debug_stmt->get_result();
    $debug_data = $debug_result->fetch_assoc();
    
    if ($debug_data) {
        $current_time = gmdate('Y-m-d H:i:s');
        $is_expired = strtotime($current_time) > strtotime($debug_data['expires_at']);
        $is_used = $debug_data['used'] == 1;
        
        echo json_encode([
            "status" => "error",
            "message" => "Invalid or expired reset token",
            "debug_info" => [
                "token_exists" => true,
                "current_time" => $current_time,
                "expires_at" => $debug_data['expires_at'],
                "is_expired" => $is_expired,
                "is_used" => $is_used,
                "used" => $debug_data['used']
            ]
        ]);
    } else {
        echo json_encode([
            "status" => "error",
            "message" => "Token not found in database"
        ]);
    }
    $debug_stmt->close();
    exit;
}

// Token is valid
echo json_encode([
    "status" => "success",
    "message" => "Token is valid",
    "user_email" => $reset_data['email'],
    "user_name" => $reset_data['f_name'] . ' ' . $reset_data['l_name']
]);

$stmt->close();
$conn->close();
?>
