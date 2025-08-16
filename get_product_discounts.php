<?php
header('Content-Type: application/json');
require_once 'config/db.php';

// Get active discounts for products
function getProductDiscounts($product_id = null) {
    global $conn;
    
    $query = "SELECT d.*, p.name as product_name 
              FROM discounts d 
              JOIN products p ON d.product_id = p.id 
              WHERE d.is_active = 1 
              AND (d.start_date IS NULL OR d.start_date <= CURDATE())
              AND (d.end_date IS NULL OR d.end_date >= CURDATE())";
    
    if ($product_id) {
        $query .= " AND d.product_id = ?";
        $stmt = $conn->prepare($query);
        $stmt->bind_param("i", $product_id);
    } else {
        $stmt = $conn->prepare($query);
    }
    
    $stmt->execute();
    $result = $stmt->get_result();
    
    $discounts = [];
    while ($row = $result->fetch_assoc()) {
        $discounts[] = $row;
    }
    
    $stmt->close();
    return $discounts;
}

// If product_id is provided, return discounts for that product
if (isset($_GET['product_id'])) {
    $product_id = intval($_GET['product_id']);
    $discounts = getProductDiscounts($product_id);
    echo json_encode($discounts);
} else {
    // Return all active discounts
    $discounts = getProductDiscounts();
    echo json_encode($discounts);
}

$conn->close();
?>
