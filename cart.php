<?php
session_start();
require_once 'config/db.php';

header('Content-Type: application/json');

// Check if user is logged in
if (!isset($_SESSION['user_id'])) {
    http_response_code(401);
    echo json_encode(['status' => 'error', 'message' => 'Authentication required']);
    exit;
}

$user_id = $_SESSION['user_id'];

// Get request method
$method = $_SERVER['REQUEST_METHOD'];

switch ($method) {
    case 'GET':
        // Get cart items
        getCart($conn, $user_id);
        break;
    case 'POST':
        // Add item to cart
        $data = json_decode(file_get_contents('php://input'), true);
        addToCart($conn, $user_id, $data);
        break;
    case 'PUT':
        // Update cart item quantity
        $data = json_decode(file_get_contents('php://input'), true);
        updateCartItem($conn, $user_id, $data);
        break;
    case 'DELETE':
        // Remove item from cart
        $data = json_decode(file_get_contents('php://input'), true);
        removeFromCart($conn, $user_id, $data);
        break;
    default:
        http_response_code(405);
        echo json_encode(['status' => 'error', 'message' => 'Method not allowed']);
        break;
}

function getCart($conn, $user_id) {
    try {
        // Get or create cart
        $stmt = $conn->prepare("SELECT id FROM cart WHERE user_id = ? ORDER BY created_at DESC LIMIT 1");
        $stmt->bind_param("i", $user_id);
        $stmt->execute();
        $result = $stmt->get_result();
        $cart = $result->fetch_assoc();

        if (!$cart) {
            // Create new cart
            $stmt = $conn->prepare("INSERT INTO cart (user_id, total) VALUES (?, 0)");
            $stmt->bind_param("i", $user_id);
            $stmt->execute();
            $cart_id = $conn->insert_id;
        } else {
            $cart_id = $cart['id'];
        }

        // Get cart items with product details, price from product_skus, and discount information
        $stmt = $conn->prepare(
            "SELECT ci.*, p.name, p.cover, ps.price, ps.Currancy,
                    d.discount_type, d.discount_value, d.start_date, d.end_date, d.is_active as discount_active
             FROM cart_item ci 
             JOIN products p ON ci.product_id = p.id 
             JOIN product_skus ps ON ci.product_sku_id = ps.id 
             LEFT JOIN discounts d ON p.id = d.product_id 
             AND d.is_active = 1 
             AND (d.start_date IS NULL OR d.start_date <= CURDATE())
             AND (d.end_date IS NULL OR d.end_date >= CURDATE())
             WHERE ci.cart_id = ?"
        );
        if (!$stmt) {
            throw new Exception("Prepare failed: " . $conn->error);
        }
        $stmt->bind_param("i", $cart_id);
        $stmt->execute();
        $result = $stmt->get_result();
        $items = [];
        $total = 0;
        while ($item = $result->fetch_assoc()) {
            // Calculate final price with discount
            $originalPrice = floatval($item['price']);
            $finalPrice = $originalPrice;
            $hasDiscount = false;
            
            if (!empty($item['discount_type']) && !empty($item['discount_value'])) {
                $discountValue = floatval($item['discount_value']);
                
                if ($item['discount_type'] === 'percentage') {
                    $finalPrice = $originalPrice - ($originalPrice * $discountValue / 100);
                } else { // fixed amount
                    $finalPrice = $originalPrice - $discountValue;
                }
                
                // Ensure final price doesn't go below 0
                $finalPrice = max(0, $finalPrice);
                $hasDiscount = true;
            }
            
            $item['original_price'] = number_format($originalPrice, 2);
            $item['final_price'] = number_format($finalPrice, 2);
            $item['has_discount'] = $hasDiscount;
            
            $total += $finalPrice * $item['quantity'];
            $items[] = $item;
        }

        // Update cart total
        $stmt = $conn->prepare("UPDATE cart SET total = ? WHERE id = ?");
        $stmt->bind_param("di", $total, $cart_id);
        $stmt->execute();

        echo json_encode([
            'status' => 'success',
            'cart_id' => $cart_id,
            'total' => $total,
            'items' => $items
        ]);
    } catch (Exception $e) {
        http_response_code(500);
        echo json_encode(['status' => 'error', 'message' => 'Database error: ' . $e->getMessage()]);
    }
}

function addToCart($conn, $user_id, $data) {
    try {
        if (!isset($data['product_id']) || !isset($data['quantity'])) {
            throw new Exception('Missing required fields');
        }

        // Start transaction
        $conn->begin_transaction();

        try {
            // Get or create cart
            $stmt = $conn->prepare("SELECT id FROM cart WHERE user_id = ? ORDER BY created_at DESC LIMIT 1");
            if (!$stmt) {
                throw new Exception("Prepare failed: " . $conn->error);
            }
            $stmt->bind_param("i", $user_id);
            $stmt->execute();
            $result = $stmt->get_result();
            $cart = $result->fetch_assoc();

            if (!$cart) {
                // Create new cart
                $stmt = $conn->prepare("INSERT INTO cart (user_id, total) VALUES (?, 0)");
                if (!$stmt) {
                    throw new Exception("Prepare failed: " . $conn->error);
                }
                $stmt->bind_param("i", $user_id);
                $stmt->execute();
                $cart_id = $conn->insert_id;
            } else {
                $cart_id = $cart['id'];
            }

            // Get product SKU price
            $stmt = $conn->prepare("SELECT id, price FROM product_skus WHERE product_id = ? LIMIT 1");
            if (!$stmt) {
                throw new Exception("Prepare failed: " . $conn->error);
            }
            $stmt->bind_param("i", $data['product_id']);
            $stmt->execute();
            $result = $stmt->get_result();
            $sku = $result->fetch_assoc();

            if (!$sku) {
                throw new Exception('Product SKU not found');
            }

            // Check if item already exists in cart
            $stmt = $conn->prepare("SELECT * FROM cart_item WHERE cart_id = ? AND product_id = ?");
            if (!$stmt) {
                throw new Exception("Prepare failed: " . $conn->error);
            }
            $stmt->bind_param("ii", $cart_id, $data['product_id']);
            $stmt->execute();
            $result = $stmt->get_result();
            $existing_item = $result->fetch_assoc();

            if ($existing_item) {
                // Update quantity
                $new_quantity = $existing_item['quantity'] + $data['quantity'];
                $stmt = $conn->prepare("UPDATE cart_item SET quantity = ? WHERE id = ?");
                if (!$stmt) {
                    throw new Exception("Prepare failed: " . $conn->error);
                }
                $stmt->bind_param("ii", $new_quantity, $existing_item['id']);
                $stmt->execute();
            } else {
                // Add new item
                $stmt = $conn->prepare("INSERT INTO cart_item (cart_id, product_id, product_sku_id, quantity) VALUES (?, ?, ?, ?)");
                if (!$stmt) {
                    throw new Exception("Prepare failed: " . $conn->error);
                }
                $stmt->bind_param("iiii", $cart_id, $data['product_id'], $sku['id'], $data['quantity']);
                $stmt->execute();
            }

            // Calculate new total
            $stmt = $conn->prepare("
                SELECT SUM(ci.quantity * ps.price) as total 
                FROM cart_item ci 
                JOIN product_skus ps ON ci.product_sku_id = ps.id 
                WHERE ci.cart_id = ?
            ");
            if (!$stmt) {
                throw new Exception("Prepare failed: " . $conn->error);
            }
            $stmt->bind_param("i", $cart_id);
            $stmt->execute();
            $result = $stmt->get_result();
            $total = $result->fetch_assoc()['total'] ?? 0;

            // Update cart total
            $stmt = $conn->prepare("UPDATE cart SET total = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?");
            if (!$stmt) {
                throw new Exception("Prepare failed: " . $conn->error);
            }
            $stmt->bind_param("di", $total, $cart_id);
            $stmt->execute();

            // Commit transaction
            $conn->commit();

            // Get updated cart
            getCart($conn, $user_id);
        } catch (Exception $e) {
            // Rollback transaction on error
            $conn->rollback();
            throw $e;
        }
    } catch (Exception $e) {
        http_response_code(500);
        echo json_encode(['status' => 'error', 'message' => $e->getMessage()]);
    }
}

function updateCartItem($conn, $user_id, $data) {
    try {
        if (!isset($data['cart_item_id']) || !isset($data['quantity'])) {
            throw new Exception('Missing required fields');
        }

        // Start transaction
        $conn->begin_transaction();

        try {
            // Verify cart ownership and get cart_id
            $stmt = $conn->prepare("SELECT ci.id, ci.cart_id FROM cart_item ci JOIN cart c ON ci.cart_id = c.id WHERE ci.id = ? AND c.user_id = ?");
            if (!$stmt) {
                throw new Exception("Prepare failed: " . $conn->error);
            }
            $stmt->bind_param("ii", $data['cart_item_id'], $user_id);
            $stmt->execute();
            $result = $stmt->get_result();
            $cart_item = $result->fetch_assoc();
            
            if (!$cart_item) {
                throw new Exception('Cart item not found or unauthorized');
            }

            // Update quantity
            $stmt = $conn->prepare("UPDATE cart_item SET quantity = ? WHERE id = ?");
            if (!$stmt) {
                throw new Exception("Prepare failed: " . $conn->error);
            }
            $stmt->bind_param("ii", $data['quantity'], $data['cart_item_id']);
            $stmt->execute();

            // Calculate new total
            $stmt = $conn->prepare("
                SELECT SUM(ci.quantity * ps.price) as total 
                FROM cart_item ci 
                JOIN product_skus ps ON ci.product_sku_id = ps.id 
                WHERE ci.cart_id = ?
            ");
            if (!$stmt) {
                throw new Exception("Prepare failed: " . $conn->error);
            }
            $stmt->bind_param("i", $cart_item['cart_id']);
            $stmt->execute();
            $result = $stmt->get_result();
            $total = $result->fetch_assoc()['total'] ?? 0;

            // Update cart total
            $stmt = $conn->prepare("UPDATE cart SET total = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?");
            if (!$stmt) {
                throw new Exception("Prepare failed: " . $conn->error);
            }
            $stmt->bind_param("di", $total, $cart_item['cart_id']);
            $stmt->execute();

            // Commit transaction
            $conn->commit();

            // Get updated cart
            getCart($conn, $user_id);
        } catch (Exception $e) {
            // Rollback transaction on error
            $conn->rollback();
            throw $e;
        }
    } catch (Exception $e) {
        http_response_code(500);
        echo json_encode(['status' => 'error', 'message' => $e->getMessage()]);
    }
}

function removeFromCart($conn, $user_id, $data) {
    try {
        if (!isset($data['cart_item_id'])) {
            throw new Exception('Missing cart item ID');
        }

        // Start transaction
        $conn->begin_transaction();

        try {
            // Verify cart ownership and get cart_id
            $stmt = $conn->prepare("SELECT ci.id, ci.cart_id FROM cart_item ci JOIN cart c ON ci.cart_id = c.id WHERE ci.id = ? AND c.user_id = ?");
            if (!$stmt) {
                throw new Exception("Prepare failed: " . $conn->error);
            }
            $stmt->bind_param("ii", $data['cart_item_id'], $user_id);
            $stmt->execute();
            $result = $stmt->get_result();
            $cart_item = $result->fetch_assoc();
            
            if (!$cart_item) {
                throw new Exception('Cart item not found or unauthorized');
            }

            // Remove item
            $stmt = $conn->prepare("DELETE FROM cart_item WHERE id = ?");
            if (!$stmt) {
                throw new Exception("Prepare failed: " . $conn->error);
            }
            $stmt->bind_param("i", $data['cart_item_id']);
            $stmt->execute();

            // Calculate new total
            $stmt = $conn->prepare("
                SELECT SUM(ci.quantity * ps.price) as total 
                FROM cart_item ci 
                JOIN product_skus ps ON ci.product_sku_id = ps.id 
                WHERE ci.cart_id = ?
            ");
            if (!$stmt) {
                throw new Exception("Prepare failed: " . $conn->error);
            }
            $stmt->bind_param("i", $cart_item['cart_id']);
            $stmt->execute();
            $result = $stmt->get_result();
            $total = $result->fetch_assoc()['total'] ?? 0;

            // Update cart total
            $stmt = $conn->prepare("UPDATE cart SET total = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?");
            if (!$stmt) {
                throw new Exception("Prepare failed: " . $conn->error);
            }
            $stmt->bind_param("di", $total, $cart_item['cart_id']);
            $stmt->execute();

            // Commit transaction
            $conn->commit();

            // Get updated cart
            getCart($conn, $user_id);
        } catch (Exception $e) {
            // Rollback transaction on error
            $conn->rollback();
            throw $e;
        }
    } catch (Exception $e) {
        http_response_code(500);
        echo json_encode(['status' => 'error', 'message' => $e->getMessage()]);
    }
}
?> 