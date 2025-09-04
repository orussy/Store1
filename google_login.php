<?php
session_start();
header('Content-Type: application/json');

// Enable all error reporting
error_reporting(E_ALL);
ini_set('display_errors', 1);

try {
    // Log raw input
    $raw_input = file_get_contents('php://input');
    error_log("Raw input: " . $raw_input);

    $data = json_decode($raw_input, true);
    error_log("Decoded data: " . print_r($data, true));

    if (!$data) {
        throw new Exception("Invalid request data");
    }

    // Get credential and decode it
    $credential = $data['credential'] ?? '';
    error_log("Credential: " . $credential);

    // Decode JWT token
    $jwt_parts = explode('.', $credential);
    $jwt_payload = json_decode(base64_decode($jwt_parts[1]), true);
    error_log("JWT Payload: " . print_r($jwt_payload, true));

    // Get picture URL
    $picture_url = $jwt_payload['picture'] ?? '';
    error_log("Picture URL: " . $picture_url);

    if ($picture_url) {
        // Create directory
        $upload_dir = 'uploads/profile_pictures/';
        if (!file_exists($upload_dir)) {
            mkdir($upload_dir, 0777, true);
            error_log("Created directory: " . $upload_dir);
        }

        // Set file path
        $filename = md5($jwt_payload['email']) . '.jpg';
        $file_path = $upload_dir . $filename;
        error_log("File path: " . $file_path);

        // Download image
        $picture_content = file_get_contents($picture_url);
        if ($picture_content !== false) {
            // Save image
            if (file_put_contents($file_path, $picture_content)) {
                error_log("Image saved successfully to: " . $file_path);
            } else {
                error_log("Failed to save image to: " . $file_path);
            }
        } else {
            error_log("Failed to download image from: " . $picture_url);
        }
    }

    $connect = new mysqli('localhost', 'root', '', 'store');
    if ($connect->connect_error) {
        throw new Exception("Connection failed: " . $connect->connect_error);
    }

    $email = $jwt_payload['email'] ?? '';
    $name = $jwt_payload['name'] ?? '';
    $google_id = trim($jwt_payload['sub'] ?? '');
    $phone_no = $jwt_payload['phone_number'] ?? '';

    $name_parts = explode(' ', $name);
    $f_name = $name_parts[0] ?? '';
    $l_name = $name_parts[1] ?? '';

    if (empty($email)) {
        throw new Exception("Missing email");
    }

    // Log the incoming data
    error_log("Attempting to create user - Email: $email, Name: $name");

    // 1. Check if user exists by email
    $checkStmt = $connect->prepare("SELECT * FROM users WHERE email = ?");
    if (!$checkStmt) {
        throw new Exception("Check prepare failed: " . $connect->error);
    }
    $checkStmt->bind_param("s", $email);
    $checkStmt->execute();
    $result = $checkStmt->get_result();
    error_log('Email to check: ' . $email);
    error_log('Rows found: ' . $result->num_rows);

    if ($result->num_rows > 0) {
        // User exists
        $user = $result->fetch_assoc();

        // Block login for blocked users
        if (isset($user['status']) && strtolower($user['status']) === 'blocked') {
            http_response_code(403);
            echo json_encode([
                "status" => "error",
                "message" => "Your account has been blocked. Please contact support."
            ]);
            exit();
        }

        // Set session variables using role_id
        $_SESSION['user_id'] = $user['id'];
        $_SESSION['username'] = $user['email'];
        $_SESSION['role_id'] = $user['role_id'] ?? 7; // Default to customer role
        $_SESSION['user_status'] = $user['status'] ?? 'active';
        
        // Optionally update profile info and Google_ID
        $updateStmt = $connect->prepare("UPDATE users SET f_name = ?, l_name = ?, avatar = ?, Google_ID = ? WHERE email = ?");
        if ($updateStmt) {
            $updateStmt->bind_param("sssss", $f_name, $l_name, $file_path, $google_id, $email);
            $updateStmt->execute();
        }
        
        // Determine redirect based on user role_id
        $redirect = "dashboard.html"; // Default redirect
        if(in_array($_SESSION['role_id'], [1, 2, 3, 4, 5, 6])) {
            $redirect = "admin/admindashboard.php"; // Admin redirect for role_id 1-6
        }
        
        echo json_encode([
            "status" => "success",
            "id" => $user['id'],
            "email" => $user['email'],
            "role_id" => $user['role_id'] ?? 7,
            "f_name" => $user['f_name'],
            "l_name" => $user['l_name'],
            "avatar" => $user['avatar'],
            "google_id" => $user['Google_ID'],
            "redirect" => $redirect,
            "message" => "Logged in with Google account"
        ]);
    } else {
        // 2. If not, create new user with role_id = 7 (Customer)
        $role_id = 7; // Customer role
        $sql = "INSERT INTO users (Google_ID, email, avatar, role_id, f_name, l_name, status) VALUES (?, ?, ?, ?, ?, ?, 'active')";
        $stmt = $connect->prepare($sql);
        if (!$stmt) {
            throw new Exception("Insert prepare failed: " . $connect->error);
        }
        $stmt->bind_param("ssisss", $google_id, $email, $file_path, $role_id, $f_name, $l_name);
        if (!$stmt->execute()) {
            throw new Exception("Insert execute failed: " . $stmt->error);
        }
        $new_user_id = $stmt->insert_id;
        
        // Set session variables for new user
        $_SESSION['user_id'] = $new_user_id;
        $_SESSION['username'] = $email;
        $_SESSION['role_id'] = $role_id;
        $_SESSION['user_status'] = 'active';
        
        // New users are always redirected to user dashboard
        $redirect = 'dashboard.html';
        echo json_encode([
            "status" => "success",
            "id" => $new_user_id,
            "email" => $email,
            "role_id" => $role_id,
            "f_name" => $f_name,
            "l_name" => $l_name,
            "avatar" => $file_path,
            "google_id" => $google_id,
            "redirect" => $redirect,
            "message" => "Registered new Google user"
        ]);
    }
} catch (Exception $e) {
    error_log("Error: " . $e->getMessage());
    error_log("Stack trace: " . $e->getTraceAsString());
    echo json_encode([
        "status" => "error",
        "message" => $e->getMessage()
    ]);
}

if (isset($connect)) {
    $connect->close();
}
?> 