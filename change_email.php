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
    // Get form data
    $newEmail = trim($_POST['new_email'] ?? '');
    $verificationCode = trim($_POST['verification_code'] ?? '');
    
    // Validate inputs
    if (empty($newEmail) || !filter_var($newEmail, FILTER_VALIDATE_EMAIL)) {
        echo json_encode([
            "status" => "error",
            "message" => "Please provide a valid email address"
        ]);
        exit();
    }
    
    if (empty($verificationCode) || strlen($verificationCode) !== 6) {
        echo json_encode([
            "status" => "error",
            "message" => "Please provide a valid 6-digit verification code"
        ]);
        exit();
    }
    
    // Check if verification session exists
    if (!isset($_SESSION['email_verification'])) {
        echo json_encode([
            "status" => "error",
            "message" => "No email verification request found. Please request a new verification code."
        ]);
        exit();
    }
    
    $verification = $_SESSION['email_verification'];
    
    // Check if verification has expired
    if (time() > $verification['expires']) {
        unset($_SESSION['email_verification']);
        echo json_encode([
            "status" => "error",
            "message" => "Verification code has expired. Please request a new one."
        ]);
        exit();
    }
    
    // Check if the new email matches the one in verification
    if ($newEmail !== $verification['new_email']) {
        echo json_encode([
            "status" => "error",
            "message" => "Email address does not match the verification request"
        ]);
        exit();
    }
    
    // Check if verification code matches
    if ($verificationCode !== $verification['code']) {
        echo json_encode([
            "status" => "error",
            "message" => "Invalid verification code"
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
    
    // Update the user's email
    $updateQuery = "UPDATE users SET email = ? WHERE id = ? AND deleted_at IS NULL";
    $updateStmt = $conn->prepare($updateQuery);
    $updateStmt->bind_param("si", $newEmail, $userId);
    
    if ($updateStmt->execute()) {
        if ($updateStmt->affected_rows > 0) {
            // Clear the verification session
            unset($_SESSION['email_verification']);
            
            // Send confirmation email to the new email address using PHPMailer (same as registration)
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
                $mail->setFrom('storestop08@gmail.com', 'Store Verification');
                $mail->addAddress($newEmail);
                
                // Content (same style as registration)
                $mail->isHTML(true);
                $mail->Subject = 'Email Address Changed - Store1';
                $mail->Body = '
                <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px; background-color: #f9f9f9;">
                    <div style="background-color: #28a745; color: white; padding: 20px; text-align: center; border-radius: 8px 8px 0 0;">
                        <h1>Email Address Changed Successfully</h1>
                    </div>
                    <div style="background-color: white; padding: 30px; border-radius: 0 0 8px 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1);">
                        <h2>Email Change Confirmed</h2>
                        <p>Your email address has been successfully changed to: <strong>' . $newEmail . '</strong></p>
                        <p>You can now use this email address to log in to your account.</p>
                        <p><strong>If you did not make this change, please contact our support team immediately.</strong></p>
                        
                        <div style="margin-top: 30px; padding-top: 20px; border-top: 1px solid #eee; color: #666; font-size: 14px;">
                            <p>Best regards,<br>The Store Team</p>
                        </div>
                    </div>
                </div>';
                
                $mail->send();
                
            } catch (Exception $e) {
                // Log the error for debugging
                error_log("PHPMailer Error (confirmation email): " . $e->getMessage());
                // Don't fail the entire operation if confirmation email fails
            }
            
            echo json_encode([
                "status" => "success",
                "message" => "Email address changed successfully"
            ]);
        } else {
            echo json_encode([
                "status" => "error",
                "message" => "Failed to update email address"
            ]);
        }
    } else {
        echo json_encode([
            "status" => "error",
            "message" => "Database error occurred"
        ]);
    }
    
    $emailCheckStmt->close();
    $updateStmt->close();
    
} catch (Exception $e) {
    echo json_encode([
        "status" => "error",
        "message" => "An error occurred: " . $e->getMessage()
    ]);
}

$conn->close();
?>
