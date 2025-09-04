
<?php
// Prevent any output before JSON response
error_reporting(0);
ini_set('display_errors', 0);

session_start();
header('Content-Type: application/json');

// Check if user is logged in
if (!isset($_SESSION['user_id'])) {
    http_response_code(401);
    echo json_encode(['status' => 'error', 'message' => 'Not authenticated']);
    exit();
}

require_once 'config/db.php';

if (!$conn) {
    http_response_code(500);
    echo json_encode(['status' => 'error', 'message' => 'Database connection failed']);
    exit();
}

// Check if cart_item table exists
$table_check = $conn->query("SHOW TABLES LIKE 'cart_item'");
if (!$table_check || $table_check->num_rows === 0) {
    http_response_code(500);
    echo json_encode(['status' => 'error', 'message' => 'Cart table not found']);
    exit();
}

$method = $_SERVER['REQUEST_METHOD'];
$user_id = $_SESSION['user_id'];

// Helper function to get cart data
function getCartData($conn, $user_id) {
    $sql = "SELECT ci.*, p.name, p.cover, ps.price, ps.Currency,
            d.discount_type, d.discount_value, d.start_date, d.end_date, d.is_active as discount_active
            FROM cart_item ci
            JOIN cart c ON ci.cart_id = c.id
            JOIN products p ON ci.product_id = p.id
            JOIN product_skus ps ON ci.product_sku_id = ps.id
            LEFT JOIN discounts d ON p.id = d.product_id AND d.is_active = 1
            WHERE c.user_id = ?";
    
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
    $total = 0;
    
    while ($row = $result->fetch_assoc()) {
        $price = floatval($row['price']);
        $quantity = intval($row['quantity']);
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
            'product_sku_id' => $row['product_sku_id'],
            'name' => $row['name'],
            'cover' => $row['cover'],
            'price' => $price,
            'Currency' => $row['Currency'],
            'quantity' => $quantity,
            'has_discount' => $has_discount,
            'discount_type' => $discount_type,
            'discount_value' => $discount_value,
            'final_price' => $final_price,
            'original_price' => $price
        ];
        
        $items[] = $item;
        $total += $final_price * $quantity;
    }
    
    return [
        'status' => 'success',
        'items' => $items,
        'total' => $total
    ];
}

switch ($method) {
    case 'GET':
        // Get cart items
        $cart_data = getCartData($conn, $user_id);
        echo json_encode($cart_data);
        break;
        
    case 'POST':
        // Add item to cart
        $input = json_decode(file_get_contents('php://input'), true);
        $product_id = $input['product_id'] ?? 0;
        $quantity = $input['quantity'] ?? 1;
        
        if (!$product_id) {
            http_response_code(400);
            echo json_encode(['status' => 'error', 'message' => 'Product ID required']);
            exit();
        }
        
        // Get default product_sku_id
        $sku_sql = "SELECT id FROM product_skus WHERE product_id = ? LIMIT 1";
        $sku_stmt = $conn->prepare($sku_sql);
        if (!$sku_stmt) {
            http_response_code(500);
            echo json_encode(['status' => 'error', 'message' => 'SKU prepare failed: ' . $conn->error]);
            exit();
        }
        
        $sku_stmt->bind_param("i", $product_id);
        if (!$sku_stmt->execute()) {
            http_response_code(500);
            echo json_encode(['status' => 'error', 'message' => 'SKU execute failed: ' . $sku_stmt->error]);
            exit();
        }
        
        $sku_result = $sku_stmt->get_result();
        $sku_row = $sku_result->fetch_assoc();
        
        if (!$sku_row) {
            http_response_code(400);
            echo json_encode(['status' => 'error', 'message' => 'Product SKU not found']);
            exit();
        }
        
        $product_sku_id = $sku_row['id'];
        
        // Get or create cart for user
        $cart_sql = "SELECT id FROM cart WHERE user_id = ?";
        $cart_stmt = $conn->prepare($cart_sql);
        if (!$cart_stmt) {
            http_response_code(500);
            echo json_encode(['status' => 'error', 'message' => 'Cart prepare failed: ' . $conn->error]);
            exit();
        }
        
        $cart_stmt->bind_param("i", $user_id);
        if (!$cart_stmt->execute()) {
            http_response_code(500);
            echo json_encode(['status' => 'error', 'message' => 'Cart execute failed: ' . $cart_stmt->error]);
            exit();
        }
        
        $cart_result = $cart_stmt->get_result();
        
        if ($cart_result->num_rows > 0) {
            $cart_row = $cart_result->fetch_assoc();
            $cart_id = $cart_row['id'];
        } else {
            // Create new cart for user
            $create_cart_sql = "INSERT INTO cart (user_id, total) VALUES (?, 0)";
            $create_cart_stmt = $conn->prepare($create_cart_sql);
            if (!$create_cart_stmt) {
                http_response_code(500);
                echo json_encode(['status' => 'error', 'message' => 'Create cart prepare failed: ' . $conn->error]);
                exit();
            }
            
            $create_cart_stmt->bind_param("i", $user_id);
            if (!$create_cart_stmt->execute()) {
                http_response_code(500);
                echo json_encode(['status' => 'error', 'message' => 'Create cart execute failed: ' . $create_cart_stmt->error]);
                exit();
            }
            
            $cart_id = $conn->insert_id;
        }
        
        // Check if item already exists in cart
        $check_sql = "SELECT id, quantity FROM cart_item WHERE cart_id = ? AND product_id = ? AND product_sku_id = ?";
        $check_stmt = $conn->prepare($check_sql);
        if (!$check_stmt) {
            http_response_code(500);
            echo json_encode(['status' => 'error', 'message' => 'Check prepare failed: ' . $conn->error]);
            exit();
        }
        
        $check_stmt->bind_param("iii", $cart_id, $product_id, $product_sku_id);
        if (!$check_stmt->execute()) {
            http_response_code(500);
            echo json_encode(['status' => 'error', 'message' => 'Check execute failed: ' . $check_stmt->error]);
            exit();
        }
        
        $check_result = $check_stmt->get_result();
        
        if ($check_result->num_rows > 0) {
            // Update quantity
            $existing = $check_result->fetch_assoc();
            $new_quantity = $existing['quantity'] + $quantity;
            $update_sql = "UPDATE cart_item SET quantity = ? WHERE id = ?";
            $update_stmt = $conn->prepare($update_sql);
            if (!$update_stmt) {
                http_response_code(500);
                echo json_encode(['status' => 'error', 'message' => 'Update prepare failed: ' . $conn->error]);
                exit();
            }
            
            $update_stmt->bind_param("ii", $new_quantity, $existing['id']);
            if (!$update_stmt->execute()) {
                http_response_code(500);
                echo json_encode(['status' => 'error', 'message' => 'Update execute failed: ' . $update_stmt->error]);
                exit();
            }
        } else {
            // Insert new item
            $insert_sql = "INSERT INTO cart_item (cart_id, product_id, product_sku_id, quantity) VALUES (?, ?, ?, ?)";
            $insert_stmt = $conn->prepare($insert_sql);
            if (!$insert_stmt) {
                http_response_code(500);
                echo json_encode(['status' => 'error', 'message' => 'Insert prepare failed: ' . $conn->error]);
                exit();
            }
            
            $insert_stmt->bind_param("iiii", $cart_id, $product_id, $product_sku_id, $quantity);
            if (!$insert_stmt->execute()) {
                http_response_code(500);
                echo json_encode(['status' => 'error', 'message' => 'Insert execute failed: ' . $insert_stmt->error]);
                exit();
            }
        }
        
        // Return updated cart data
        $cart_data = getCartData($conn, $user_id);
        echo json_encode($cart_data);
        break;
        
    case 'PUT':
        // Update cart item quantity
        $input = json_decode(file_get_contents('php://input'), true);
        $cart_item_id = $input['cart_item_id'] ?? 0;
        $quantity = $input['quantity'] ?? 1;
        
        if (!$cart_item_id || $quantity < 1) {
            http_response_code(400);
            echo json_encode(['status' => 'error', 'message' => 'Invalid parameters']);
            exit();
        }
        
        $update_sql = "UPDATE cart_item SET quantity = ? WHERE id = ? AND cart_id IN (SELECT id FROM cart WHERE user_id = ?)";
        $update_stmt = $conn->prepare($update_sql);
        $update_stmt->bind_param("iii", $quantity, $cart_item_id, $user_id);
        
        if ($update_stmt->execute()) {
            // Return updated cart data
            $cart_data = getCartData($conn, $user_id);
            echo json_encode($cart_data);
        } else {
            http_response_code(500);
            echo json_encode(['status' => 'error', 'message' => 'Failed to update cart']);
        }
        break;
        
    case 'DELETE':
        // Remove item from cart
        $input = json_decode(file_get_contents('php://input'), true);
        $cart_item_id = $input['cart_item_id'] ?? 0;
        
        if (!$cart_item_id) {
            http_response_code(400);
            echo json_encode(['status' => 'error', 'message' => 'Cart item ID required']);
            exit();
        }
        
        $delete_sql = "DELETE FROM cart_item WHERE id = ? AND cart_id IN (SELECT id FROM cart WHERE user_id = ?)";
        $delete_stmt = $conn->prepare($delete_sql);
        $delete_stmt->bind_param("ii", $cart_item_id, $user_id);
        
        if ($delete_stmt->execute()) {
            // Return updated cart data
            $cart_data = getCartData($conn, $user_id);
            echo json_encode($cart_data);
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
