<?php
session_start();
require_once 'config/db.php';

header("Content-Type: application/json");

// Updated SQL query to include discount information and product attributes
$query = "SELECT p.*, ps.price, ps.Currency, ps.quantity, ps.id as sku_id, ps.sku, ps.cover as sku_cover,
          pa_size.value as size_value, pa_color.value as color_value,
          d.discount_type, d.discount_value, d.start_date, d.end_date, d.is_active as discount_active
          FROM products p 
          LEFT JOIN product_skus ps ON p.id = ps.product_id
          LEFT JOIN product_attributes pa_size ON ps.size_attribute_id = pa_size.id
          LEFT JOIN product_attributes pa_color ON ps.color_attribute_id = pa_color.id
          LEFT JOIN discounts d ON p.id = d.product_id 
          AND d.is_active = 1 
          AND (d.start_date IS NULL OR d.start_date <= CURDATE())
          AND (d.end_date IS NULL OR d.end_date >= CURDATE())
          WHERE p.deleted_at IS NULL AND ps.deleted_at IS NULL 
          AND ps.id IS NOT NULL AND ps.sku IS NOT NULL AND ps.sku != ''";

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
$productMap = array(); // To group products by base SKU

while ($row = $result->fetch_assoc()) {
    // Extract base SKU (remove size and color from SKU)
    $baseSku = preg_replace('/-[A-Z]+$/', '', $row['sku']); // Remove last part after dash
    
    if (!isset($productMap[$baseSku])) {
        // Initialize product data
        $productMap[$baseSku] = array(
            'id' => $row['id'],
            'name' => $row['name'],
            'description' => $row['description'],
            'summary' => $row['summary'],
            'cover' => $row['sku_cover'], // Use sku_cover instead of cover
            'category_id' => $row['category_id'],
            'created_at' => $row['created_at'],
            'base_sku' => $baseSku,
            'variants' => array(),
            'discount_type' => $row['discount_type'],
            'discount_value' => $row['discount_value'],
            'discount_start_date' => $row['start_date'],
            'discount_end_date' => $row['end_date'],
            'has_discount' => !empty($row['discount_type'])
        );
    }
    
    // Add variant information
    $variant = array(
        'sku_id' => $row['sku_id'],
        'sku' => $row['sku'],
        'price' => $row['price'],
        'Currency' => $row['Currency'],
        'quantity' => $row['quantity'],
        'size' => $row['size_value'],
        'color' => $row['color_value'],
        'cover' => $row['sku_cover'],
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
        
        $variant['final_price'] = number_format($finalPrice, 2);
        $variant['original_price'] = number_format($originalPrice, 2);
    }
    
    $productMap[$baseSku]['variants'][] = $variant;
}

// Convert map to array and set default variant for each product
$products = array();
foreach ($productMap as $baseSku => $product) {
    // Set the first variant as default for backward compatibility
    if (!empty($product['variants'])) {
        $defaultVariant = $product['variants'][0];
        $product['price'] = $defaultVariant['price'];
        $product['Currency'] = $defaultVariant['Currency'];
        $product['quantity'] = $defaultVariant['quantity'];
        $product['sku_id'] = $defaultVariant['sku_id'];
        $product['cover'] = $defaultVariant['cover']; // Use variant's cover image
        $product['original_price'] = $defaultVariant['original_price'];
        $product['final_price'] = $defaultVariant['final_price'];
    }
    
    $products[] = $product;
}

// Debug log
error_log('Products array with variants: ' . print_r($products, true));

// Ensure we're sending a valid JSON array
echo json_encode($products);

$stmt->close();
$conn->close();
?> 