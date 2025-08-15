<?php
// Temporary script to update product cover for testing image gallery
require_once 'config/db.php';

// Update product ID 1 to use the r50i folder
$new_cover = 'img/product/r50i/1(1).jpg';
$product_id = 1;

$stmt = $conn->prepare("UPDATE products SET cover = ? WHERE id = ?");
$stmt->bind_param("si", $new_cover, $product_id);

if ($stmt->execute()) {
    echo "Product cover updated successfully to: " . $new_cover;
} else {
    echo "Error updating product cover: " . $stmt->error;
}

$stmt->close();
$conn->close();
?>
