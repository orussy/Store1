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
    $currentPassword = $_POST['current_password'] ?? '';
    $newPassword = $_POST['new_password'] ?? '';
    $confirmPassword = $_POST['confirm_password'] ?? '';
    
    // Validate inputs
    if (empty($currentPassword)) {
        echo json_encode([
            "status" => "error",
            "message" => "Current password is required"
        ]);
        exit();
    }
    
    if (empty($newPassword)) {
        echo json_encode([
            "status" => "error",
            "message" => "New password is required"
        ]);
        exit();
    }
    
    if (empty($confirmPassword)) {
        echo json_encode([
            "status" => "error",
            "message" => "Please confirm your new password"
        ]);
        exit();
    }
    
    // Validate password length
    if (strlen($newPassword) < 8) {
        echo json_encode([
            "status" => "error",
            "message" => "New password must be at least 8 characters long"
        ]);
        exit();
    }
    
    // Check if passwords match
    if ($newPassword !== $confirmPassword) {
        echo json_encode([
            "status" => "error",
            "message" => "New passwords do not match"
        ]);
        exit();
    }
    
    // Check if new password is different from current password
    if ($currentPassword === $newPassword) {
        echo json_encode([
            "status" => "error",
            "message" => "New password must be different from current password"
        ]);
        exit();
    }
    
    // Get current user's password hash
    $userQuery = "SELECT password FROM users WHERE id = ? AND deleted_at IS NULL";
    $userStmt = $conn->prepare($userQuery);
    $userStmt->bind_param("i", $userId);
    $userStmt->execute();
    $userResult = $userStmt->get_result();
    
    if ($userResult->num_rows === 0) {
        echo json_encode([
            "status" => "error",
            "message" => "User not found"
        ]);
        exit();
    }
    
    $user = $userResult->fetch_assoc();
    
    // Verify current password
    if (!password_verify($currentPassword, $user['password'])) {
        echo json_encode([
            "status" => "error",
            "message" => "Current password is incorrect"
        ]);
        exit();
    }
    
    // Hash the new password
    $hashedPassword = password_hash($newPassword, PASSWORD_DEFAULT);
    
    // Update the password
    $updateQuery = "UPDATE users SET password = ? WHERE id = ? AND deleted_at IS NULL";
    $updateStmt = $conn->prepare($updateQuery);
    $updateStmt->bind_param("si", $hashedPassword, $userId);
    
    if ($updateStmt->execute()) {
        if ($updateStmt->affected_rows > 0) {
            // Get user's email for notification
            $emailQuery = "SELECT email FROM users WHERE id = ? AND deleted_at IS NULL";
            $emailStmt = $conn->prepare($emailQuery);
            $emailStmt->bind_param("i", $userId);
            $emailStmt->execute();
            $emailResult = $emailStmt->get_result();
            $userEmail = $emailResult->fetch_assoc()['email'];
            
            // Send password change notification email using PHPMailer (same as registration)
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
                $mail->addAddress($userEmail);
                
                // Content (same style as registration)
                $mail->isHTML(true);
                $mail->Subject = 'Password Changed - Store1';
                $mail->Body = '
                <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px; background-color: #f9f9f9;">
                    <div style="background-color: #dc3545; color: white; padding: 20px; text-align: center; border-radius: 8px 8px 0 0;">
                        <h1>Password Changed Successfully</h1>
                    </div>
                    <div style="background-color: white; padding: 30px; border-radius: 0 0 8px 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1);">
                        <h2>Password Change Confirmed</h2>
                        <p>Your password has been successfully changed.</p>
                        <p><strong>If you did not make this change, please contact our support team immediately and consider changing your password again.</strong></p>
                        <p>For security reasons, we recommend using a strong, unique password.</p>
                        
                        <div style="margin-top: 30px; padding-top: 20px; border-top: 1px solid #eee; color: #666; font-size: 14px;">
                            <p>Best regards,<br>The Store Team</p>
                        </div>
                    </div>
                </div>';
                
                $mail->send();
                
            } catch (Exception $e) {
                // Log the error for debugging
                error_log("PHPMailer Error (password change notification): " . $e->getMessage());
                // Don't fail the entire operation if notification email fails
            }
            
            echo json_encode([
                "status" => "success",
                "message" => "Password changed successfully"
            ]);
        } else {
            echo json_encode([
                "status" => "error",
                "message" => "Failed to update password"
            ]);
        }
    } else {
        echo json_encode([
            "status" => "error",
            "message" => "Database error occurred"
        ]);
    }
    
    $userStmt->close();
    $updateStmt->close();
    $emailStmt->close();
    
} catch (Exception $e) {
    echo json_encode([
        "status" => "error",
        "message" => "An error occurred: " . $e->getMessage()
    ]);
}

$conn->close();
?>
