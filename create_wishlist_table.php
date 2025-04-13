<?php
// Database connection
$connect = new mysqli('localhost', 'root', '', 'store');
if ($connect->connect_error) {
    die("Connection failed: " . $connect->connect_error);
}

// Read and execute SQL file
$sql = file_get_contents('wishlist.sql');
if ($connect->multi_query($sql)) {
    do {
        // Store first result set
        if ($result = $connect->store_result()) {
            $result->free();
        }
    } while ($connect->next_result());
}

if ($connect->error) {
    die("Error creating table: " . $connect->error);
}

echo "Wishlist table created successfully!";
$connect->close();
?> 