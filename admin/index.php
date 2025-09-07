<?php
// Redirect to admin dashboard or login based on authentication
require_once 'auth_check.php';

// If we get here, user is authenticated as admin, redirect to dashboard
header('Location: admindashboard.php');
exit();
?>
