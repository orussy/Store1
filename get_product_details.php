<?php
header('Content-Type: application/json');

$connect = new mysqli('localhost', 'root', '', 'store');
if ($connect->connect_error) {
    die(json_encode(["error" => "Connection failed: " . $connect->connect_error]));
}

$id = $_GET['id'] ?? '';
if (!$id) {
    echo json_encode(['error' => 'No product ID provided']);
    exit;
}

// Fetch product with aggregated price and currency from product_skus
$stmt = $connect->prepare("SELECT p.*, MIN(ps.price) AS price, MIN(ps.Currancy) AS Currancy FROM products p LEFT JOIN product_skus ps ON p.id = ps.product_id WHERE p.id = ? GROUP BY p.id");
$stmt->bind_param("i", $id);
$stmt->execute();
$result = $stmt->get_result();
$product = $result->fetch_assoc();

if (!$product) {
    echo json_encode(['error' => 'Product not found']);
    exit;
}

echo json_encode($product);
?> 