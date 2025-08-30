<?php
session_start();
header("Content-Type: application/json");

require_once 'config/db.php';
// Include PHPMailer
use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;

require 'phpmailer/src/Exception.php';
require 'phpmailer/src/PHPMailer.php';
require 'phpmailer/src/SMTP.php';

// Check if user is logged in
if (!isset($_SESSION['user_id'])) {
    echo json_encode([
        "status" => "error",
        "message" => "User not authenticated"
    ]);
    exit();
}

// Check if it's a POST request
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    echo json_encode([
        "status" => "error",
        "message" => "Invalid request method"
    ]);
    exit();
}

$userId = $_SESSION['user_id'];

try {
    // Get the new email address
    $newEmail = trim($_POST['new_email'] ?? '');
    
    // Validate email format
    if (empty($newEmail) || !filter_var($newEmail, FILTER_VALIDATE_EMAIL)) {
        echo json_encode([
            "status" => "error",
            "message" => "Please provide a valid email address"
        ]);
        exit();
    }
    
    // Check if the new email is different from current email
    $currentEmailQuery = "SELECT email FROM users WHERE id = ? AND deleted_at IS NULL";
    $currentEmailStmt = $conn->prepare($currentEmailQuery);
    $currentEmailStmt->bind_param("i", $userId);
    $currentEmailStmt->execute();
    $currentEmailResult = $currentEmailStmt->get_result();
    
    if ($currentEmailResult->num_rows === 0) {
        echo json_encode([
            "status" => "error",
            "message" => "User not found"
        ]);
        exit();
    }
    
    $currentUser = $currentEmailResult->fetch_assoc();
    if ($newEmail === $currentUser['email']) {
        echo json_encode([
            "status" => "error",
            "message" => "New email must be different from current email"
        ]);
        exit();
    }
    
    // Check if the new email is already in use by another user
    $emailCheckQuery = "SELECT id FROM users WHERE email = ? AND id != ? AND deleted_at IS NULL";
    $emailCheckStmt = $conn->prepare($emailCheckQuery);
    $emailCheckStmt->bind_param("si", $newEmail, $userId);
    $emailCheckStmt->execute();
    $emailCheckResult = $emailCheckStmt->get_result();
    
    if ($emailCheckResult->num_rows > 0) {
        echo json_encode([
            "status" => "error",
            "message" => "This email address is already in use by another account"
        ]);
        exit();
    }
    
    // Generate a 6-digit verification code
    $verificationCode = sprintf("%06d", mt_rand(0, 999999));
    
    // Store the verification code in session with expiration (10 minutes)
    $_SESSION['email_verification'] = [
        'code' => $verificationCode,
        'new_email' => $newEmail,
        'expires' => time() + 600 // 10 minutes
    ];
    
    // Send email with verification code using PHPMailer (same as registration)
    try {
        $mail = new PHPMailer(true);
        
        // Server settings (same as registration page)
        $mail->isSMTP();
        $mail->Host       = 'smtp.gmail.com';
        $mail->SMTPAuth   = true;
        $mail->Username   = 'storestop08@gmail.com';
        $mail->Password   = 'inpp dawu ffzf umpt';
        $mail->SMTPSecure = 'tls';
        $mail->Port       = 587;
        
        // Recipients
        $mail->setFrom('storestop08@gmail.com', 'Store1 Verification');
        $mail->addAddress($newEmail);
        
        // Content (same style as registration)
        $mail->isHTML(true);
        $mail->Subject = 'Email Change Verification - Store1';
        $mail->Body = '
        <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px; background-color: #f9f9f9;">
            <div style="background-color: #0d3b5e; color: white; padding: 20px; text-align: center; border-radius: 8px 8px 0 0;">
                <h1>Store1 Email Change Verification</h1>
            </div>
            <div style="background-color: white; padding: 30px; border-radius: 0 0 8px 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1);">
                <h2>Email Change Request</h2>
                <p>You have requested to change your email address to: <strong>' . $newEmail . '</strong></p>
                <p>To complete this change, please use the verification code below:</p>
                
                <div style="background-color: #f0f0f0; padding: 20px; text-align: center; border-radius: 8px; margin: 20px 0;">
                    <h1 style="color: #0d3b5e; font-size: 32px; margin: 0; letter-spacing: 5px;">' . $verificationCode . '</h1>
                </div>
                
                <p>This code will expire in 10 minutes for security reasons.</p>
                <p>If you did not request this change, please ignore this email and contact our support team immediately.</p>
                
                <div style="margin-top: 30px; padding-top: 20px; border-top: 1px solid #eee; color: #666; font-size: 14px;">
                    <p>Best regards,<br>The Store1 Team</p>
                </div>
            </div>
        </div>';
        
        $mail->send();
        
        echo json_encode([
            "status" => "success",
            "message" => "Verification code sent to your new email address"
        ]);
        
    } catch (Exception $e) {
        // Log the error for debugging
        error_log("PHPMailer Error: " . $e->getMessage());
        
        echo json_encode([
            "status" => "error",
            "message" => "Failed to send verification email. Please try again later."
        ]);
    }
    
    $currentEmailStmt->close();
    $emailCheckStmt->close();
    
} catch (Exception $e) {
    echo json_encode([
        "status" => "error",
        "message" => "An error occurred: " . $e->getMessage()
    ]);
}

$conn->close();
?>
