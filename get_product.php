<?php
session_start();
require_once 'config/db.php';

header("Content-Type: application/json");

// Updated SQL query to include discount information
$query = "SELECT p.*, ps.price, ps.Currency, ps.quantity, ps.id as sku_id,
          d.discount_type, d.discount_value, d.start_date, d.end_date, d.is_active as discount_active
          FROM products p 
          LEFT JOIN product_skus ps ON p.id = ps.product_id
          LEFT JOIN discounts d ON p.id = d.product_id 
          AND d.is_active = 1 
          AND (d.start_date IS NULL OR d.start_date <= CURDATE())
          AND (d.end_date IS NULL OR d.end_date >= CURDATE())
          WHERE p.deleted_at IS NULL";

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
$productMap = array(); // To group products by ID

while ($row = $result->fetch_assoc()) {
    $productId = $row['id'];
    
    if (!isset($productMap[$productId])) {
        // Initialize product data
        $productMap[$productId] = array(
            'id' => $row['id'],
            'name' => $row['name'],
            'description' => $row['description'],
            'summary' => $row['summary'],
            'cover' => $row['cover'],
            'category_id' => $row['category_id'],
            'created_at' => $row['created_at'],
            'price' => $row['price'],
            'Currency' => $row['Currency'],
            'quantity' => $row['quantity'],
            'sku_id' => $row['sku_id'],
            'discount_type' => $row['discount_type'],
            'discount_value' => $row['discount_value'],
            'discount_start_date' => $row['start_date'],
            'discount_end_date' => $row['end_date'],
            'has_discount' => !empty($row['discount_type']),
            'original_price' => $row['price'],
            'final_price' => $row['price']
        );
        
        // Calculate final price if discount exists
        if (!empty($row['discount_type']) && !empty($row['discount_value'])) {
            $originalPrice = floatval($row['price']);
            $discountValue = floatval($row['discount_value']);
            
            if ($row['discount_type'] === 'percentage') {
                $finalPrice = $originalPrice - ($originalPrice * $discountValue / 100);
            } else { // fixed amount
                $finalPrice = $originalPrice - $discountValue;
            }
            
            // Ensure final price doesn't go below 0
            $finalPrice = max(0, $finalPrice);
            
            $productMap[$productId]['final_price'] = number_format($finalPrice, 2);
            $productMap[$productId]['original_price'] = number_format($originalPrice, 2);
        }
    }
}

// Convert map to array
$products = array_values($productMap);

// Debug log
error_log('Products array with discounts: ' . print_r($products, true));

// Ensure we're sending a valid JSON array
echo json_encode($products);

$stmt->close();
$conn->close();
?> 