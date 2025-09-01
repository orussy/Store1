<?php
// Database configuration
define('DB_SERVER', 'localhost');     // Database server
define('DB_USERNAME', 'root');        // Database username
define('DB_PASSWORD', '');            // Database password
define('DB_NAME', 'store');           // Database name

// Attempt to connect to MySQL database
try {
    $conn = new mysqli(DB_SERVER, DB_USERNAME, DB_PASSWORD, DB_NAME);
    
    // Check connection
    if ($conn->connect_error) {
        throw new Exception("Connection failed: " . $conn->connect_error);
    }
    
    // Set charset to utf8mb4
    if (!$conn->set_charset("utf8mb4")) {
        throw new Exception("Error setting charset utf8mb4: " . $conn->error);
    }
    
    // Set timezone to ensure consistent datetime handling
    $conn->query("SET time_zone = '+00:00'");
    
} catch (Exception $e) {
    // Log error (in a production environment, you should log to a file instead)
    error_log("Database Connection Error: " . $e->getMessage());
    
    // Log error only - let the calling script handle output
    error_log("Database Connection Error: " . $e->getMessage());
    die("Connection failed. Please try again later.");
}
?> 