<?php
session_start();
require_once 'config/db.php';

header("Content-Type: application/json");

// Check if user has temporary data in session
if (!isset($_SESSION['temp_user'])) {
    echo json_encode([
        "status" => "error",
        "message" => "No verification session found. Please register again."
    ]);
    exit;
}

$temp_user = $_SESSION['temp_user'];

// Generate new verification code
$new_verification_code = random_int(100000, 999999);

// Update the verification code in session
$_SESSION['temp_user']['verification_code'] = (string)$new_verification_code; // Ensure it's stored as string
$_SESSION['temp_user']['created_at'] = date('Y-m-d H:i:s');

// Debug: Log the new verification code (remove this in production)
error_log("New verification code: " . $new_verification_code);

// Send new verification email
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
    $mail->setFrom('storestop08@gmail.com', 'StoreStop Verification');
    $mail->addAddress($temp_user['email'], $temp_user['f_name'] . ' ' . $temp_user['l_name']);

    // Content
    $mail->isHTML(true);
    $mail->Subject = 'New Verification Code - StoreStop';
    $mail->Body = '
    <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px; background-color: #f9f9f9;">
        <div style="background-color: #0d3b5e; color: white; padding: 20px; text-align: center; border-radius: 8px 8px 0 0;">
            <h1>StoreStop Email Verification</h1>
        </div>
        <div style="background-color: white; padding: 30px; border-radius: 0 0 8px 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1);">
            <h2>Hello ' . $temp_user['f_name'] . '!</h2>
            <p>You requested a new verification code. Here is your new 6-digit verification code:</p>
            
            <div style="background-color: #f0f0f0; padding: 20px; text-align: center; border-radius: 8px; margin: 20px 0;">
                <h1 style="color: #0d3b5e; font-size: 32px; margin: 0; letter-spacing: 5px;">' . $new_verification_code . '</h1>
            </div>
            
            <p>This code will expire in 10 minutes for security reasons.</p>
            <p>If you did not request this code, please ignore this email.</p>
            
            <div style="margin-top: 30px; padding-top: 20px; border-top: 1px solid #eee; color: #666; font-size: 14px;">
                <p>Best regards,<br>The Storestop Team</p>
            </div>
        </div>
    </div>';

    $mail->send();
    
    echo json_encode([
        "status" => "success",
        "message" => "New verification code sent successfully!"
    ]);

} catch (Exception $e) {
    echo json_encode([
        "status" => "error",
        "message" => "Failed to send verification email: " . $e->getMessage()
    ]);
}
?>
