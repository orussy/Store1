<?php
// Include PHPMailer files
require 'phpmailer/src/PHPMailer.php';
require 'phpmailer/src/SMTP.php';
require 'phpmailer/src/Exception.php';

use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;

// Create PHPMailer object
$mail = new PHPMailer(true);

try {
    // Server settings
    $mail->isSMTP();
    $mail->Host       = 'smtp.gmail.com';
    $mail->SMTPAuth   = true;
    $mail->Username   = 'storestop08@gmail.com';      // Your Gmail
    $mail->Password   = 'inpp dawu ffzf umpt';        // Your Google App Password
    $mail->SMTPSecure = 'tls';                      // Encryption
    $mail->Port       = 587;

    // Recipients
    $mail->setFrom('yourgmail@gmail.com', 'Your Website');
    $mail->addAddress('user@example.com', 'User Name'); // Receiver email

    // Content
    $verification_code = random_int(100000, 999999);
    $mail->isHTML(true);
    $mail->Subject = 'Your Verification Code';
    $mail->Body    = 'Your verification code is: <b>' . $verification_code . '</b>';

    // Send email
    $mail->send();
    echo 'Verification code sent to user@example.com';
} catch (Exception $e) {
    echo "Message could not be sent. Mailer Error: {$mail->ErrorInfo}";
}
?>
