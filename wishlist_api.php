<?php
// Prevent any output before JSON response
error_reporting(0);
ini_set('display_errors', 0);

if (session_status() === PHP_SESSION_NONE) {
    $cookieParams = session_get_cookie_params();
    session_set_cookie_params([
        'lifetime' => 0,
        'path' => '/',
        'domain' => $cookieParams['domain'] ?? '',
        'secure' => (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off'),
        'httponly' => true,
        'samesite' => 'Lax'
    ]);
    session_start();
}
header('Content-Type: application/json');

// Check if user is logged in
if (!isset($_SESSION['user_id'])) {
    http_response_code(401);
    echo json_encode(['status' => 'error', 'message' => 'Authentication required']);
    exit();
}

require_once 'config/db.php';

if (!$conn) {
    http_response_code(500);
    echo json_encode(['status' => 'error', 'message' => 'Database connection failed']);
    exit();
}

$method = $_SERVER['REQUEST_METHOD'];
$user_id = $_SESSION['user_id'];

// Helper function to get wishlist data
function getWishlistData($conn, $user_id) {
    // Prefer the specific SKU saved on the wishlist item; otherwise fall back to the first SKU for the product
    $sql = "
        SELECT 
            w.*,
            p.name,
            COALESCE(ps_specific.cover, ps_default.cover) AS cover,
            COALESCE(ps_specific.price, ps_default.price) AS price,
            COALESCE(ps_specific.Currency, ps_default.Currency) AS Currency,
            d.discount_type,
            d.discount_value,
            d.start_date,
            d.end_date,
            d.is_active AS discount_active,
            w.product_sku_id
        FROM whishlist w
        JOIN products p ON w.product_id = p.id
        LEFT JOIN product_skus ps_specific ON ps_specific.id = w.product_sku_id
        LEFT JOIN product_skus ps_default ON ps_default.product_id = p.id 
            AND ps_default.id = (
                SELECT MIN(ps2.id) FROM product_skus ps2 WHERE ps2.product_id = p.id
            )
        LEFT JOIN discounts d ON p.id = d.product_id AND d.is_active = 1
        WHERE w.user_id = ?
    ";
    
    $stmt = $conn->prepare($sql);
    if (!$stmt) {
        return ['status' => 'error', 'message' => 'Database prepare failed: ' . $conn->error];
    }
    
    $stmt->bind_param("i", $user_id);
    if (!$stmt->execute()) {
        return ['status' => 'error', 'message' => 'Database execute failed: ' . $stmt->error];
    }
    
    $result = $stmt->get_result();
    
    $items = [];
    
    while ($row = $result->fetch_assoc()) {
        $price = floatval($row['price']);
        $final_price = $price;
        $has_discount = false;
        $discount_type = '';
        $discount_value = 0;
        
        // Check if discount is active
        if ($row['discount_active'] && $row['start_date'] <= date('Y-m-d') && $row['end_date'] >= date('Y-m-d')) {
            $has_discount = true;
            $discount_type = $row['discount_type'];
            $discount_value = floatval($row['discount_value']);
            
            if ($discount_type === 'percentage') {
                $final_price = $price * (1 - $discount_value / 100);
            } else {
                $final_price = max(0, $price - $discount_value);
            }
        }
        
        $item = [
            'id' => $row['id'],
            'product_id' => $row['product_id'],
            'product_sku_id' => isset($row['product_sku_id']) ? (int)$row['product_sku_id'] : null,
            'name' => $row['name'],
            'cover' => $row['cover'],
            'price' => $price,
            'Currency' => $row['Currency'],
            'has_discount' => $has_discount,
            'discount_type' => $discount_type,
            'discount_value' => $discount_value,
            'final_price' => $final_price,
            'original_price' => $price
        ];
        
        $items[] = $item;
    }
    
    return [
        'status' => 'success',
        'items' => $items
    ];
}

switch ($method) {
    case 'GET':
        // Get wishlist items
        $wishlist_data = getWishlistData($conn, $user_id);
        echo json_encode($wishlist_data);
        break;
        
    case 'POST':
        // Add item to wishlist
        $input = json_decode(file_get_contents('php://input'), true);
        $product_id = intval($input['product_id'] ?? 0);
        // Accept both product_sku_id and sku_id for compatibility
        $product_sku_id = null;
        if (isset($input['product_sku_id'])) {
            $product_sku_id = intval($input['product_sku_id']);
        } elseif (isset($input['sku_id'])) {
            $product_sku_id = intval($input['sku_id']);
        }
        
        if (!$product_id) {
            http_response_code(400);
            echo json_encode(['status' => 'error', 'message' => 'Product ID required']);
            exit();
        }
        
        // Check if product exists
        $product_sql = "SELECT id FROM products WHERE id = ?";
        $product_stmt = $conn->prepare($product_sql);
        if (!$product_stmt) {
            http_response_code(500);
            echo json_encode(['status' => 'error', 'message' => 'Product prepare failed: ' . $conn->error]);
            exit();
        }
        
        $product_stmt->bind_param("i", $product_id);
        if (!$product_stmt->execute()) {
            http_response_code(500);
            echo json_encode(['status' => 'error', 'message' => 'Product execute failed: ' . $product_stmt->error]);
            exit();
        }
        
        $product_result = $product_stmt->get_result();
        
        if ($product_result->num_rows === 0) {
            http_response_code(400);
            echo json_encode(['status' => 'error', 'message' => 'Product not found']);
            exit();
        }
        
        // If a specific SKU is provided, verify it belongs to the product
        if (!is_null($product_sku_id)) {
            $sku_sql = "SELECT id FROM product_skus WHERE id = ? AND product_id = ?";
            $sku_stmt = $conn->prepare($sku_sql);
            if (!$sku_stmt) {
                http_response_code(500);
                echo json_encode(['status' => 'error', 'message' => 'SKU prepare failed: ' . $conn->error]);
                exit();
            }
            $sku_stmt->bind_param("ii", $product_sku_id, $product_id);
            if (!$sku_stmt->execute()) {
                http_response_code(500);
                echo json_encode(['status' => 'error', 'message' => 'SKU execute failed: ' . $sku_stmt->error]);
                exit();
            }
            $sku_result = $sku_stmt->get_result();
            if ($sku_result->num_rows === 0) {
                http_response_code(400);
                echo json_encode(['status' => 'error', 'message' => 'Invalid product_sku_id for product']);
                exit();
            }
        }
        
        // If no SKU provided, select a default one (first/min id) to satisfy NOT NULL schemas
        if (is_null($product_sku_id)) {
            $default_sku_sql = "SELECT MIN(id) AS id FROM product_skus WHERE product_id = ?";
            $default_sku_stmt = $conn->prepare($default_sku_sql);
            if (!$default_sku_stmt) {
                http_response_code(500);
                echo json_encode(['status' => 'error', 'message' => 'Default SKU prepare failed: ' . $conn->error]);
                exit();
            }
            $default_sku_stmt->bind_param("i", $product_id);
            if (!$default_sku_stmt->execute()) {
                http_response_code(500);
                echo json_encode(['status' => 'error', 'message' => 'Default SKU execute failed: ' . $default_sku_stmt->error]);
                exit();
            }
            $default_sku_result = $default_sku_stmt->get_result();
            $default_row = $default_sku_result->fetch_assoc();
            if (!$default_row || !$default_row['id']) {
                http_response_code(400);
                echo json_encode(['status' => 'error', 'message' => 'No SKU found for this product']);
                exit();
            }
            $product_sku_id = intval($default_row['id']);
        }
        
        // Check if item already exists in wishlist (by product_id + product_sku_id)
        $check_sql = "SELECT id FROM whishlist WHERE user_id = ? AND product_id = ? AND product_sku_id = ?";
        $check_stmt = $conn->prepare($check_sql);
        $check_stmt->bind_param("iii", $user_id, $product_id, $product_sku_id);
        
        if (!$check_stmt) {
            http_response_code(500);
            echo json_encode(['status' => 'error', 'message' => 'Check prepare failed: ' . $conn->error]);
            exit();
        }
        
        if (!$check_stmt->execute()) {
            http_response_code(500);
            echo json_encode(['status' => 'error', 'message' => 'Check execute failed: ' . $check_stmt->error]);
            exit();
        }
        
        $check_result = $check_stmt->get_result();
        
        if ($check_result->num_rows > 0) {
            echo json_encode(['status' => 'success', 'message' => 'Product already in wishlist']);
        } else {
            // Insert new item with resolved SKU
            $insert_sql = "INSERT INTO whishlist (user_id, product_id, product_sku_id, created_at) VALUES (?, ?, ?, NOW())";
            $insert_stmt = $conn->prepare($insert_sql);
            if (!$insert_stmt) {
                http_response_code(500);
                echo json_encode(['status' => 'error', 'message' => 'Insert prepare failed: ' . $conn->error]);
                exit();
            }
            $insert_stmt->bind_param("iii", $user_id, $product_id, $product_sku_id);

            if (!$insert_stmt->execute()) {
                http_response_code(500);
                echo json_encode(['status' => 'error', 'message' => 'Insert execute failed: ' . $insert_stmt->error]);
                exit();
            }

            echo json_encode(['status' => 'success', 'message' => 'Product added to wishlist']);
        }
        break;
        
    case 'DELETE':
        // Remove item from wishlist
        $input = json_decode(file_get_contents('php://input'), true);
        $wishlist_item_id = $input['wishlist_item_id'] ?? 0;
        
        if (!$wishlist_item_id) {
            http_response_code(400);
            echo json_encode(['status' => 'error', 'message' => 'Wishlist item ID required']);
            exit();
        }
        
        $delete_sql = "DELETE FROM whishlist WHERE id = ? AND user_id = ?";
        $delete_stmt = $conn->prepare($delete_sql);
        $delete_stmt->bind_param("ii", $wishlist_item_id, $user_id);
        
        if ($delete_stmt->execute()) {
            echo json_encode(['status' => 'success', 'message' => 'Item removed from wishlist']);
        } else {
            http_response_code(500);
            echo json_encode(['status' => 'error', 'message' => 'Failed to remove item']);
        }
        break;
        
    default:
        http_response_code(405);
        echo json_encode(['status' => 'error', 'message' => 'Method not allowed']);
        break;
}

$conn->close();
?>
