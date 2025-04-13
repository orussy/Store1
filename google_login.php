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
    $google_id = $jwt_payload['sub'] ?? '';
    $phone_no = $jwt_payload['phone_number'] ?? '';

    $name_parts = explode(' ', $name);
    $f_name = $name_parts[0] ?? '';
    $l_name = $name_parts[1] ?? '';

    if (empty($email)) {
        throw new Exception("Missing email");
    }

    // Log the incoming data
    error_log("Attempting to create user - Email: $email, Name: $name");

    // Check if user exists
    $checkStmt = $connect->prepare("SELECT * FROM users WHERE email = ?");
    if (!$checkStmt) {
        throw new Exception("Check prepare failed: " . $connect->error);
    }
    
    $checkStmt->bind_param("s", $email);
    $checkStmt->execute();
    $result = $checkStmt->get_result();

    if ($result->num_rows > 0) {
        // User exists
        $user = $result->fetch_assoc();
        $_SESSION['username'] = $email;
        $_SESSION['role'] = $user['role'];
        
        // Update including the Google profile picture URL
        $updateStmt = $connect->prepare("UPDATE users SET f_name = ?, l_name = ?, avatar = ? WHERE email = ?");
        if ($updateStmt) {
            $updateStmt->bind_param("ssss", $f_name, $l_name, $file_path, $email);
            $updateStmt->execute();
        }
        
        echo json_encode([
            "avatar" => $file_path,  // Local path to the image
            "google_id" => $google_id,
            "status" => "success",
            "email" => $email,
            "role" => $user['role'],
            "f_name" => $user['f_name'],
            "l_name" => $user['l_name'],
            "phone_no" => $user['phone_no'],
            "birthdate" => $user['birthdate'],
            "gender" => $user['gender'],
            "id" => $user['id']
        ]);
    } else {
        // Create new user
        $role = 'user';
        
        // Keep id and fix the SQL statement
        $sql = "INSERT INTO users (id, email, avatar, role, f_name, l_name) VALUES (?, ?, ?, ?, ?, ?)";
        error_log("SQL Query: " . $sql);
        error_log("Google ID: " . $google_id);
        error_log("Picture URL: " . $file_path);
        
        $stmt = $connect->prepare($sql);
        if (!$stmt) {
            throw new Exception("Insert prepare failed: " . $connect->error);
        }
        
        // Fix the trailing comma and match parameters exactly
        $stmt->bind_param("ssssss", 
            $google_id,    // Keep the Google ID as id
            $email,
            $file_path,  // Store local path instead of URL
            $role, 
            $f_name, 
            $l_name       // Remove trailing comma
        );
        
        if (!$stmt->execute()) {
            throw new Exception("Insert execute failed: " . $stmt->error);
        }
        
        $_SESSION['username'] = $email;
        $_SESSION['role'] = $role;
        
        echo json_encode([
            "status" => "success",
            "email" => $email,
            "role" => $role,
            "f_name" => $f_name,
            "l_name" => $l_name,
            "avatar" => $file_path,
            "id" => $google_id,
            "message" => "Please complete your profile with additional information"
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