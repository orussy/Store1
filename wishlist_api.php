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
    $sql = "SELECT w.*, p.name, ps.cover, ps.price, ps.Currency,
            d.discount_type, d.discount_value, d.start_date, d.end_date, d.is_active as discount_active
            FROM whishlist w
            JOIN products p ON w.product_id = p.id
            JOIN product_skus ps ON p.id = ps.product_id
            LEFT JOIN discounts d ON p.id = d.product_id AND d.is_active = 1
            WHERE w.user_id = ?";
    
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
        $product_id = $input['product_id'] ?? 0;
        
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
        
        // Check if item already exists in wishlist
        $check_sql = "SELECT id FROM whishlist WHERE user_id = ? AND product_id = ?";
        $check_stmt = $conn->prepare($check_sql);
        if (!$check_stmt) {
            http_response_code(500);
            echo json_encode(['status' => 'error', 'message' => 'Check prepare failed: ' . $conn->error]);
            exit();
        }
        
        $check_stmt->bind_param("ii", $user_id, $product_id);
        if (!$check_stmt->execute()) {
            http_response_code(500);
            echo json_encode(['status' => 'error', 'message' => 'Check execute failed: ' . $check_stmt->error]);
            exit();
        }
        
        $check_result = $check_stmt->get_result();
        
        if ($check_result->num_rows > 0) {
            echo json_encode(['status' => 'success', 'message' => 'Product already in wishlist']);
        } else {
            // Insert new item
            $insert_sql = "INSERT INTO whishlist (user_id, product_id, created_at) VALUES (?, ?, NOW())";
            $insert_stmt = $conn->prepare($insert_sql);
            if (!$insert_stmt) {
                http_response_code(500);
                echo json_encode(['status' => 'error', 'message' => 'Insert prepare failed: ' . $conn->error]);
                exit();
            }
            
            $insert_stmt->bind_param("ii", $user_id, $product_id);
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
