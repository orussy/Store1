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

// Fetch product with variants and cover images from product_skus
$stmt = $connect->prepare("
    SELECT p.*, ps.id as sku_id, ps.sku, ps.price, ps.Currency, ps.quantity, ps.cover as sku_cover,
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
    WHERE p.id = ? AND ps.id IS NOT NULL AND ps.sku IS NOT NULL AND ps.sku != ''
    ORDER BY ps.id
");
$stmt->bind_param("i", $id);
$stmt->execute();
$result = $stmt->get_result();
if ($result->num_rows === 0) {
    echo json_encode(['error' => 'Product not found']);
    exit;
}

// Group variants by product
$product = null;
$variants = [];
$totalQuantity = 0;
$minPrice = null;
$maxPrice = null;

while ($row = $result->fetch_assoc()) {
    if (!$product) {
        // Initialize product data with first variant
        $product = [
            'id' => $row['id'],
            'name' => $row['name'],
            'description' => $row['description'],
            'summary' => $row['summary'],
            'category_id' => $row['category_id'],
            'created_at' => $row['created_at'],
            'cover' => $row['sku_cover'], // Use first variant's cover as default
            'discount_type' => $row['discount_type'],
            'discount_value' => $row['discount_value'],
            'discount_start_date' => $row['start_date'],
            'discount_end_date' => $row['end_date'],
            'has_discount' => !empty($row['discount_type']),
            'variants' => []
        ];
    }
    
    // Add variant information
    $variant = [
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
    ];
    
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
    
    $variants[] = $variant;
    $totalQuantity += floatval($row['quantity']);
    
    // Track price range
    $price = floatval($row['price']);
    if ($minPrice === null || $price < $minPrice) $minPrice = $price;
    if ($maxPrice === null || $price > $maxPrice) $maxPrice = $price;
}

// Set aggregated product data
$product['variants'] = $variants;
$product['total_quantity'] = $totalQuantity;

// Use first variant as default for backward compatibility
if (!empty($variants)) {
    $defaultVariant = $variants[0];
    $product['price'] = $defaultVariant['price'];
    $product['Currency'] = $defaultVariant['Currency'];
    $product['sku_id'] = $defaultVariant['sku_id'];
    $product['original_price'] = $defaultVariant['original_price'];
    $product['final_price'] = $defaultVariant['final_price'];
    
    // Calculate discount information for display
    $originalPrice = floatval($defaultVariant['price']);
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
}

echo json_encode($product);
?> 