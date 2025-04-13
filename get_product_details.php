<?php
header('Content-Type: application/json');

$connect = new mysqli('localhost', 'root', '', 'store');
if ($connect->connect_error) {
    die("Connection failed: " . $connect->connect_error);
}

$id = $_GET['id'] ?? '';
if (!$id) {
    echo json_encode(['error' => 'No product ID provided']);
    exit;
}

$stmt = $connect->prepare("SELECT * FROM products WHERE id = ?");
$stmt->bind_param("i", $id);
$stmt->execute();
$result = $stmt->get_result();
$product = $result->fetch_assoc();

echo json_encode($product);
?> 