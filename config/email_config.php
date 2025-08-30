<?php
// Email Configuration
// Update these settings with your actual email credentials

// SMTP Settings
define('SMTP_HOST', 'smtp.gmail.com'); // Your SMTP server
define('SMTP_PORT', 587); // SMTP port
define('SMTP_USERNAME', 'your-actual-email@gmail.com'); // Replace with your actual Gmail address
define('SMTP_PASSWORD', 'your-16-digit-app-password'); // Replace with your actual App Password
define('SMTP_SECURE', 'tls'); // Security type: 'tls' or 'ssl'

// Email Settings
define('FROM_EMAIL', 'your-actual-email@gmail.com'); // Replace with your actual email
define('FROM_NAME', 'Store1'); // From name

// For Gmail users:
// 1. Enable 2-factor authentication on your Google account
// 2. Generate an App Password: https://myaccount.google.com/apppasswords
// 3. Use the App Password instead of your regular password

// For other email providers, check their SMTP settings:
// - Outlook/Hotmail: smtp-mail.outlook.com, port 587
// - Yahoo: smtp.mail.yahoo.com, port 587
// - Custom domain: Check with your hosting provider

// Example configurations for different providers:

// Gmail Configuration
/*
define('SMTP_HOST', 'smtp.gmail.com');
define('SMTP_PORT', 587);
define('SMTP_USERNAME', 'your-email@gmail.com');
define('SMTP_PASSWORD', 'your-16-digit-app-password');
define('SMTP_SECURE', 'tls');
*/

// Outlook/Hotmail Configuration
/*
define('SMTP_HOST', 'smtp-mail.outlook.com');
define('SMTP_PORT', 587);
define('SMTP_USERNAME', 'your-email@outlook.com');
define('SMTP_PASSWORD', 'your-password');
define('SMTP_SECURE', 'tls');
*/

// Yahoo Configuration
/*
define('SMTP_HOST', 'smtp.mail.yahoo.com');
define('SMTP_PORT', 587);
define('SMTP_USERNAME', 'your-email@yahoo.com');
define('SMTP_PASSWORD', 'your-app-password');
define('SMTP_SECURE', 'tls');
*/
?>
