<?php
session_start();
$connect = new mysqli('localhost', 'root', '', 'store');
if ($connect->connect_error) {
    die("Connection failed: " . $connect->connect_error);
}
header("Content-Type: application/json");

// Fixed SQL query
$query = "SELECT * 
          FROM products 
          LEFT JOIN product_skus ON products.id = product_skus.product_id";

$res = mysqli_query($connect, $query);

if (!$res) {
    die(json_encode(['error' => mysqli_error($connect)]));
}

$products = array();
while ($row = mysqli_fetch_assoc($res)) { // Changed to fetch_assoc
    $products[] = $row;
}

// Debug log
error_log('Products array: ' . print_r($products, true));

// Ensure we're sending a valid JSON array
echo json_encode(array_values($products));

$connect->close();
?> 