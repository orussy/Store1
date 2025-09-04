<?php

session_start();
require_once 'config/db.php';

// Enable detailed error reporting
error_reporting(E_ALL);
ini_set('display_errors', 1);

header("Content-Type: application/json");

$f_name = $_POST['f_name'] ?? '';
$l_name = $_POST['l_name'] ?? '';
$email = $_POST['email'] ?? '';
$password = $_POST['password'] ?? '';
$birthdate = $_POST['birthdate'] ?? '';
$phone_no = $_POST['phone_no'] ?? '';
$gender = $_POST['gender'] ?? '';

// Check if email already exists
$check_stmt = $conn->prepare("SELECT id FROM users WHERE email = ?");
$check_stmt->bind_param("s", $email);
$check_stmt->execute();
$result = $check_stmt->get_result();

if ($result->num_rows > 0) {
    echo json_encode([
        "status" => "error", 
        "message" => "Email already exists"
    ]);
    exit;
}

$hashpass = password_hash($password, PASSWORD_DEFAULT);

// Generate verification code
$verification_code = random_int(100000, 999999);

// Create temporary user with verification code
$temp_user_data = [
    'f_name' => $f_name,
    'l_name' => $l_name,
    'email' => $email,
    'password' => $hashpass,
    'birthdate' => $birthdate,
    'phone_no' => $phone_no,
    'gender' => $gender,
    'verification_code' => (string)$verification_code, // Ensure it's stored as string
    'created_at' => date('Y-m-d H:i:s')
];

// Store in session for verification
$_SESSION['temp_user'] = $temp_user_data;

// Debug: Log the verification code (remove this in production)
error_log("Generated verification code: " . $verification_code);

// Send verification email
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
    $mail->setFrom('storestop08@gmail.com', 'Store Verification');
    $mail->addAddress($email, $f_name . ' ' . $l_name);

    // Content
    $mail->isHTML(true);
    $mail->Subject = 'Email Verification - Store';
    $mail->Body = '
    <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px; background-color: #f9f9f9;">
        <div style="background-color: #0d3b5e; color: white; padding: 20px; text-align: center; border-radius: 8px 8px 0 0;">
            <h1>  Verification</h1>
        </div>
        <div style="background-color: white; padding: 30px; border-radius: 0 0 8px 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1);">
            <h2>Hello ' . $f_name . '!</h2>
            <p>Thank you for registering with Store1. To complete your registration, please use the verification code below:</p>
            
            <div style="background-color: #f0f0f0; padding: 20px; text-align: center; border-radius: 8px; margin: 20px 0;">
                <h1 style="color: #0d3b5e; font-size: 32px; margin: 0; letter-spacing: 5px;">' . $verification_code . '</h1>
            </div>
            
            <p>This code will expire in 10 minutes for security reasons.</p>
            <p>If you did not create an account with Store1, please ignore this email.</p>
            
            <div style="margin-top: 30px; padding-top: 20px; border-top: 1px solid #eee; color: #666; font-size: 14px;">
                <p>Best regards,<br>The Store Team</p>
            </div>
        </div>
    </div>';

    $mail->send();
    
    echo json_encode([
        "status" => "verification_required", 
        "message" => "Please check your email for verification code",
        "email" => $email
    ]);

} catch (Exception $e) {
    echo json_encode([
        "status" => "error", 
        "message" => "Failed to send verification email: " . $e->getMessage()
    ]);
}

$check_stmt->close();
$conn->close();
?>
