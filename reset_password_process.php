<?php
session_start();
require_once 'config/db.php';

// PHPMailer use statements must be at file level
use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;

header("Content-Type: application/json");

// Get user input
$token = $_POST['token'] ?? '';
$password = $_POST['password'] ?? '';

if (empty($token) || empty($password)) {
    echo json_encode([
        "status" => "error",
        "message" => "Token and password are required"
    ]);
    exit;
}

// Validate password length
if (strlen($password) < 8) {
    echo json_encode([
        "status" => "error",
        "message" => "Password must be at least 8 characters long"
    ]);
    exit;
}

// Check if token exists and is valid
$query = "SELECT pr.*, u.email, u.f_name, u.l_name, u.role_id 
          FROM password_resets pr 
          JOIN users u ON pr.user_id = u.id 
          WHERE pr.token = ? AND pr.expires_at > UTC_TIMESTAMP() AND pr.used = 0";
$stmt = $conn->prepare($query);
$stmt->bind_param("s", $token);
$stmt->execute();
$result = $stmt->get_result();
$reset_data = $result->fetch_assoc();

if (!$reset_data) {
    echo json_encode([
        "status" => "error",
        "message" => "Invalid or expired reset token"
    ]);
    exit;
}

// Hash the new password (received password is SHA-256 hashed from client)
$hashed_password = password_hash($password, PASSWORD_DEFAULT);

// Start transaction
$conn->begin_transaction();

try {
    // Update user password
    $update_user_query = "UPDATE users SET password = ? WHERE id = ?";
    $update_user_stmt = $conn->prepare($update_user_query);
    $update_user_stmt->bind_param("si", $hashed_password, $reset_data['user_id']);
    
    if (!$update_user_stmt->execute()) {
        throw new Exception("Failed to update password");
    }
    
    // Mark reset token as used
    $mark_used_query = "UPDATE password_resets SET used = 1, used_at = NOW() WHERE token = ?";
    $mark_used_stmt = $conn->prepare($mark_used_query);
    $mark_used_stmt->bind_param("s", $token);
    
    if (!$mark_used_stmt->execute()) {
        throw new Exception("Failed to mark token as used");
    }
    
    // Commit transaction
    $conn->commit();
    
    // Send confirmation email
    require 'phpmailer/src/PHPMailer.php';
    require 'phpmailer/src/SMTP.php';
    require 'phpmailer/src/Exception.php';

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
        $mail->setFrom('storestop08@gmail.com', 'Store Password Reset');
        $mail->addAddress($reset_data['email'], $reset_data['f_name'] . ' ' . $reset_data['l_name']);

        // Content
        $mail->isHTML(true);
        $mail->Subject = 'Password Successfully Reset - Store';
        
        $mail->Body = '
        <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px; background-color: #f9f9f9;">
            <div style="background-color: #0d3b5e; color: white; padding: 20px; text-align: center; border-radius: 8px 8px 0 0;">
                <h1>Password Reset Successful</h1>
            </div>
            <div style="background-color: white; padding: 30px; border-radius: 0 0 8px 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1);">
                <h2>Hello ' . $reset_data['f_name'] . '!</h2>
                <p>Your password has been successfully reset for your Store account.</p>
                
                <div style="background-color: #d4edda; color: #155724; padding: 15px; border-radius: 5px; border: 1px solid #c3e6cb; margin: 20px 0;">
                    <strong>✅ Password Reset Completed</strong>
                </div>
                
                <p>You can now log in to your account using your new password.</p>
                
                <div style="text-align: center; margin: 30px 0;">
                    <a href="http://' . $_SERVER['HTTP_HOST'] . dirname($_SERVER['REQUEST_URI']) . '/index.html" style="background-color: #0d3b5e; color: white; padding: 15px 30px; text-decoration: none; border-radius: 5px; display: inline-block; font-weight: bold;">
                        Login to Your Account
                    </a>
                </div>
                
                <p><strong>Security Notice:</strong></p>
                <ul>
                    <li>If you did not request this password reset, please contact our support team immediately</li>
                    <li>For security reasons, all other password reset tokens for your account have been invalidated</li>
                    <li>We recommend using a strong, unique password for your account</li>
                </ul>
                
                <div style="margin-top: 30px; padding-top: 20px; border-top: 1px solid #eee; color: #666; font-size: 14px;">
                    <p>Best regards,<br>The Store Team</p>
                </div>
            </div>
        </div>';

        $mail->send();
        
    } catch (Exception $e) {
        // Email sending failed, but password reset was successful
        // Log the error but don't fail the entire operation
        error_log("Failed to send password reset confirmation email: " . $e->getMessage());
    }
    
    echo json_encode([
        "status" => "success",
        "message" => "Password has been successfully reset. You can now log in with your new password.",
        "userData" => [
            "email" => $reset_data['email'],
            "role" => $reset_data['role'] ?? 'user',
            "name" => $reset_data['f_name'] . " " . $reset_data['l_name'],
            "id" => $reset_data['user_id']
        ]
    ]);

} catch (Exception $e) {
    // Rollback transaction on error
    $conn->rollback();
    
    echo json_encode([
        "status" => "error",
        "message" => "Failed to reset password. Please try again."
    ]);
}

$stmt->close();
$update_user_stmt->close();
$mark_used_stmt->close();
$conn->close();
?>
