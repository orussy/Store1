<?php
// Start session to access user authentication data
session_start();
require_once 'config/db.php';

// Prevent PHP errors from being displayed in the output
error_reporting(0);
ini_set('display_errors', 0);

// Set headers to return JSON
header('Content-Type: application/json');

// Check if user is logged in
if (!isset($_SESSION['user_id'])) {
    echo json_encode(['status' => 'error', 'message' => 'Authentication required. Please log in.']);
    exit();
}

// Get the authenticated user's ID
$authenticated_user_id = $_SESSION['user_id'];

// Get user ID from request
$user_id = null;
if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    $user_id = $_GET['user_id'] ?? null;
    // Debug: Log the user ID
    error_log("GET request - User ID: " . $user_id);
} else {
    $data = json_decode(file_get_contents('php://input'), true);
    $user_id = $data['user_id'] ?? null;
    // Debug: Log the user ID
    error_log("Non-GET request - User ID: " . $user_id);
}

// Validate user ID
if (!$user_id) {
    echo json_encode(['status' => 'error', 'message' => 'User ID is required']);
    exit();
}

// Security check: Ensure user can only access their own wishlist
if ($user_id != $authenticated_user_id) {
    echo json_encode(['status' => 'error', 'message' => 'Unauthorized access. You can only access your own wishlist.']);
    exit();
}

// Handle different HTTP methods
switch ($_SERVER['REQUEST_METHOD']) {
    case 'GET':
        // Get wishlist items
        $stmt = $conn->prepare("
            SELECT w.id, p.id as product_id, p.name, ps.price, ps.Currancy, p.cover,
                   d.discount_type, d.discount_value, d.start_date, d.end_date, d.is_active as discount_active
            FROM whishlist w 
            JOIN products p ON w.product_id = p.id 
            JOIN product_skus ps ON p.id = ps.product_id
            LEFT JOIN discounts d ON p.id = d.product_id 
            AND d.is_active = 1 
            AND (d.start_date IS NULL OR d.start_date <= CURDATE())
            AND (d.end_date IS NULL OR d.end_date >= CURDATE())
            WHERE w.user_id = ? AND w.deleted_at IS NULL
        ");
        if (!$stmt) {
            echo json_encode(['status' => 'error', 'message' => 'Database error: ' . $conn->error]);
            exit();
        }
        
        $stmt->bind_param("i", $user_id);
        $stmt->execute();
        $result = $stmt->get_result();
        
        $items = [];
        while ($row = $result->fetch_assoc()) {
            // Calculate final price with discount
            $originalPrice = floatval($row['price']);
            $finalPrice = $originalPrice;
            $hasDiscount = false;
            
            if (!empty($row['discount_type']) && !empty($row['discount_value'])) {
                $discountValue = floatval($row['discount_value']);
                
                if ($row['discount_type'] === 'percentage') {
                    $finalPrice = $originalPrice - ($originalPrice * $discountValue / 100);
                } else { // fixed amount
                    $finalPrice = $originalPrice - $discountValue;
                }
                
                // Ensure final price doesn't go below 0
                $finalPrice = max(0, $finalPrice);
                $hasDiscount = true;
            }
            
            $row['original_price'] = number_format($originalPrice, 2);
            $row['final_price'] = number_format($finalPrice, 2);
            $row['has_discount'] = $hasDiscount;
            
            $items[] = $row;
        }
        
        // Debug: Log the number of items found
        error_log("Found " . count($items) . " items in wishlist for user ID: " . $user_id);
        
        echo json_encode([
            'status' => 'success',
            'items' => $items
        ]);
        break;

    case 'POST':
        // Add item to wishlist
        $data = json_decode(file_get_contents('php://input'), true);
        $product_id = $data['product_id'] ?? null;

        if (!$product_id) {
            echo json_encode(['status' => 'error', 'message' => 'Product ID is required']);
            exit();
        }

        // Check if item already exists in wishlist
        $check_stmt = $conn->prepare("
            SELECT id FROM whishlist 
            WHERE user_id = ? AND product_id = ? AND deleted_at IS NULL
        ");
        if (!$check_stmt) {
            echo json_encode(['status' => 'error', 'message' => 'Database error: ' . $conn->error]);
            exit();
        }
        
        $check_stmt->bind_param("ii", $user_id, $product_id);
        $check_stmt->execute();
        $check_result = $check_stmt->get_result();

        if ($check_result->num_rows > 0) {
            echo json_encode(['status' => 'error', 'message' => 'Item already in wishlist']);
            exit();
        }

        // Add new item
        $stmt = $conn->prepare("
            INSERT INTO whishlist (user_id, product_id, created_at) 
            VALUES (?, ?, NOW())
        ");
        if (!$stmt) {
            echo json_encode(['status' => 'error', 'message' => 'Database error: ' . $conn->error]);
            exit();
        }
        
        $stmt->bind_param("ii", $user_id, $product_id);
        
        if ($stmt->execute()) {
            echo json_encode(['status' => 'success', 'message' => 'Item added to wishlist']);
        } else {
            echo json_encode(['status' => 'error', 'message' => 'Failed to add item to wishlist: ' . $stmt->error]);
        }
        break;

    case 'DELETE':
        // Remove item from wishlist
        $data = json_decode(file_get_contents('php://input'), true);
        $wishlist_id = $data['wishlist_id'] ?? null;

        if (!$wishlist_id) {
            echo json_encode(['status' => 'error', 'message' => 'Wishlist ID is required']);
            exit();
        }

        // Soft delete by setting deleted_at
        $stmt = $conn->prepare("
            UPDATE whishlist 
            SET deleted_at = NOW() 
            WHERE id = ? AND user_id = ?
        ");
        if (!$stmt) {
            echo json_encode(['status' => 'error', 'message' => 'Database error: ' . $conn->error]);
            exit();
        }
        
        $stmt->bind_param("ii", $wishlist_id, $user_id);
        
        if ($stmt->execute()) {
            echo json_encode(['status' => 'success', 'message' => 'Item removed from wishlist']);
        } else {
            echo json_encode(['status' => 'error', 'message' => 'Failed to remove item from wishlist: ' . $stmt->error]);
        }
        break;

    default:
        echo json_encode(['status' => 'error', 'message' => 'Invalid request method']);
        break;
}

// Close the database connection
$conn->close();
?> 