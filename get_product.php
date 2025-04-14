<?php
session_start();
require_once 'config/db.php';

header("Content-Type: application/json");

// Fixed SQL query with prepared statement
$query = "SELECT * 
          FROM products 
          LEFT JOIN product_skus ON products.id = product_skus.product_id";

$stmt = $conn->prepare($query);
if (!$stmt) {
    die(json_encode(['error' => $conn->error]));
}

$stmt->execute();
$result = $stmt->get_result();

if (!$result) {
    die(json_encode(['error' => $conn->error]));
}

$products = array();
while ($row = $result->fetch_assoc()) {
    $products[] = $row;
}

// Debug log
error_log('Products array: ' . print_r($products, true));

// Ensure we're sending a valid JSON array
echo json_encode(array_values($products));

$stmt->close();
$conn->close();
?> 