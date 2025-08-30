<?php
session_start();
require_once 'config/db.php';

header("Content-Type: application/json");

// Get user input
$email = $_POST['email'] ?? '';

if (empty($email)) {
    echo json_encode([
        "status" => "error",
        "message" => "Email is required"
    ]);
    exit;
}

// Check if user exists
$query = "SELECT id, f_name, l_name FROM users WHERE email = ? AND status = 'active'";
$stmt = $conn->prepare($query);
$stmt->bind_param("s", $email);
$stmt->execute();
$result = $stmt->get_result();
$user = $result->fetch_assoc();

if (!$user) {
    echo json_encode([
        "status" => "error",
        "message" => "No active account found with this email address"
    ]);
    exit;
}

// Generate reset token
$reset_token = bin2hex(random_bytes(32));
$expires_at = gmdate('Y-m-d H:i:s', strtotime('+1 hour')); // Token expires in 1 hour (UTC)

// Store reset token in database
$insert_query = "INSERT INTO password_resets (user_id, token, expires_at, created_at) VALUES (?, ?, ?, NOW())";
$insert_stmt = $conn->prepare($insert_query);
$insert_stmt->bind_param("iss", $user['id'], $reset_token, $expires_at);

if (!$insert_stmt->execute()) {
    echo json_encode([
        "status" => "error",
        "message" => "Failed to process reset request. Please try again."
    ]);
    exit;
}

// Send reset email
require 'phpmailer/src/PHPMailer.php';
require 'phpmailer/src/SMTP.php';
require 'phpmailer/src/Exception.php';

use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;

$mail = new PHPMailer(true);

try {
    // Server settings
    $mail->isSMTP();
    $mail->Host       = 'smtp.gmail.com';
    $mail->SMTPAuth   = true;
    $mail->Username   = 'storestop08@gmail.com';
    $mail->Password   = 'inpp dawu ffzf umpt';
    $mail->SMTPSecure = 'tls';
    $mail->Port       = 587;

    // Recipients
    $mail->setFrom('storestop08@gmail.com', 'Store1 Password Reset');
    $mail->addAddress($email, $user['f_name'] . ' ' . $user['l_name']);

    // Content
    $mail->isHTML(true);
    $mail->Subject = 'Password Reset Request - Store1';
    
    // Create reset URL - Simplified for local development
    $reset_url = "http://localhost/Store1/reset_password.html?token=" . $reset_token;
    
    $mail->Body = '
    <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px; background-color: #f9f9f9;">
        <div style="background-color: #0d3b5e; color: white; padding: 20px; text-align: center; border-radius: 8px 8px 0 0;">
            <h1>Store1 Password Reset</h1>
        </div>
        <div style="background-color: white; padding: 30px; border-radius: 0 0 8px 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1);">
            <h2>Hello ' . $user['f_name'] . '!</h2>
            <p>We received a request to reset your password for your Store1 account.</p>
            
            <p>Click the button below to reset your password:</p>
            
            <div style="text-align: center; margin: 30px 0;">
                <a href="' . $reset_url . '" style="background-color: #0d3b5e; color: white; padding: 15px 30px; text-decoration: none; border-radius: 5px; display: inline-block; font-weight: bold;">
                    Reset Password
                </a>
            </div>
            
            <p>If the button doesn\'t work, you can copy and paste this link into your browser:</p>
            <p style="word-break: break-all; color: #666; font-size: 14px;">' . $reset_url . '</p>
            
            <p><strong>Important:</strong></p>
            <ul>
                <li>This link will expire in 1 hour for security reasons</li>
                <li>If you didn\'t request a password reset, please ignore this email</li>
                <li>Your password will remain unchanged until you click the link above</li>
            </ul>
            
            <div style="margin-top: 30px; padding-top: 20px; border-top: 1px solid #eee; color: #666; font-size: 14px;">
                <p>Best regards,<br>The Store1 Team</p>
            </div>
        </div>
    </div>';

    $mail->send();
    
    echo json_encode([
        "status" => "success",
        "message" => "Password reset link has been sent to your email address. Please check your inbox and follow the instructions."
    ]);

} catch (Exception $e) {
    echo json_encode([
        "status" => "error",
        "message" => "Failed to send reset email. Please try again later."
    ]);
}

$stmt->close();
$insert_stmt->close();
$conn->close();
?>
