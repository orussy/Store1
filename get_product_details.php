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

// Fetch product with aggregated price, currency, quantity, and discount information
$stmt = $connect->prepare("
    SELECT p.*, MIN(ps.price) AS price, MIN(ps.Currency) AS Currency, SUM(ps.quantity) AS total_quantity,
           d.discount_type, d.discount_value, d.start_date, d.end_date, d.is_active as discount_active
    FROM products p 
    LEFT JOIN product_skus ps ON p.id = ps.product_id 
    LEFT JOIN discounts d ON p.id = d.product_id 
    AND d.is_active = 1 
    AND (d.start_date IS NULL OR d.start_date <= CURDATE())
    AND (d.end_date IS NULL OR d.end_date >= CURDATE())
    WHERE p.id = ? 
    GROUP BY p.id
");
$stmt->bind_param("i", $id);
$stmt->execute();
$result = $stmt->get_result();
$product = $result->fetch_assoc();

if (!$product) {
    echo json_encode(['error' => 'Product not found']);
    exit;
}

// Calculate discount information
$originalPrice = floatval($product['price']);
$product['original_price'] = number_format($originalPrice, 2);
$product['final_price'] = number_format($originalPrice, 2);
$product['has_discount'] = false;

if (!empty($product['discount_type']) && !empty($product['discount_value'])) {
    $discountValue = floatval($product['discount_value']);
    
    if ($product['discount_type'] === 'percentage') {
        $finalPrice = $originalPrice - ($originalPrice * $discountValue / 100);
        $product['discount_percentage'] = $discountValue;
        $product['discount_amount'] = number_format($originalPrice * $discountValue / 100, 2);
    } else { // fixed amount
        $finalPrice = $originalPrice - $discountValue;
        $product['discount_amount'] = number_format($discountValue, 2);
        $product['discount_percentage'] = number_format(($discountValue / $originalPrice) * 100, 1);
    }
    
    // Ensure final price doesn't go below 0
    $finalPrice = max(0, $finalPrice);
    
    $product['final_price'] = number_format($finalPrice, 2);
    $product['has_discount'] = true;
}

echo json_encode($product);
?> 