<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

// Handle preflight OPTIONS request
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

require_once 'config/db.php';

// Function to get user ID from session or token
function getUserId() {
    session_start();
    
    // Check if user is logged in via session
    if (isset($_SESSION['user_id'])) {
        return $_SESSION['user_id'];
    }
    
    // Check if user data is provided in request
    if (isset($_POST['user_id']) || isset($_GET['user_id'])) {
        $user_id = $_POST['user_id'] ?? $_GET['user_id'];
        
        // Validate user exists
        global $conn;
        $stmt = $conn->prepare("SELECT id FROM users WHERE id = ? AND status = 'active'");
        $stmt->bind_param("i", $user_id);
        $stmt->execute();
        $result = $stmt->get_result();
        
        if ($result->num_rows > 0) {
            return $user_id;
        }
    }
    
    return null;
}

// Function to validate rating (1-5)
function validateRating($rating) {
    $rating = intval($rating);
    return ($rating >= 1 && $rating <= 5) ? $rating : false;
}

// Function to sanitize review text
function sanitizeReview($review) {
    return trim(htmlspecialchars($review, ENT_QUOTES, 'UTF-8'));
}

// Handle different HTTP methods
$method = $_SERVER['REQUEST_METHOD'];

try {
    switch ($method) {
        case 'GET':
            // Get reviews for a product
            if (!isset($_GET['product_id'])) {
                throw new Exception('Product ID is required');
            }
            
            $product_id = intval($_GET['product_id']);
            
            // Get reviews with user information
            $stmt = $conn->prepare("
                SELECT 
                    pr.id,
                    pr.product_id,
                    pr.user_id,
                    pr.rating,
                    pr.review,
                    pr.created_at,
                    u.f_name,
                    u.l_name,
                    u.avatar
                FROM product_reviews pr
                JOIN users u ON pr.user_id = u.id
                WHERE pr.product_id = ?
                ORDER BY pr.created_at DESC
            ");
            
            if (!$stmt) {
                throw new Exception('Database prepare failed: ' . $conn->error);
            }
            
            $stmt->bind_param("i", $product_id);
            $stmt->execute();
            $result = $stmt->get_result();
            
            $reviews = [];
            while ($row = $result->fetch_assoc()) {
                $reviews[] = [
                    'id' => $row['id'],
                    'product_id' => $row['product_id'],
                    'user_id' => $row['user_id'],
                    'rating' => $row['rating'],
                    'review' => $row['review'],
                    'created_at' => $row['created_at'],
                    'user_name' => $row['f_name'] . ' ' . $row['l_name'],
                    'user_avatar' => $row['avatar'] ?: 'uploads/avatar.png'
                ];
            }
            
            // Calculate average rating
            $avg_stmt = $conn->prepare("
                SELECT 
                    AVG(rating) as avg_rating,
                    COUNT(*) as total_reviews
                FROM product_reviews 
                WHERE product_id = ?
            ");
            
            if (!$avg_stmt) {
                throw new Exception('Average rating prepare failed: ' . $conn->error);
            }
            
            $avg_stmt->bind_param("i", $product_id);
            $avg_stmt->execute();
            $avg_result = $avg_stmt->get_result()->fetch_assoc();
            
            echo json_encode([
                'status' => 'success',
                'reviews' => $reviews,
                'average_rating' => round($avg_result['avg_rating'], 1),
                'total_reviews' => $avg_result['total_reviews']
            ]);
            break;
            
        case 'POST':
            // Add a new review
            $user_id = getUserId();
            if (!$user_id) {
                throw new Exception('Authentication required');
            }
            
            $input = json_decode(file_get_contents('php://input'), true);
            if (!$input) {
                $input = $_POST;
            }
            
            if (!isset($input['product_id']) || !isset($input['rating'])) {
                throw new Exception('Product ID and rating are required');
            }
            
            $product_id = intval($input['product_id']);
            $rating = validateRating($input['rating']);
            $review = isset($input['review']) ? sanitizeReview($input['review']) : '';
            
            if (!$rating) {
                throw new Exception('Rating must be between 1 and 5');
            }
            
            // Check if user already reviewed this product
            $check_stmt = $conn->prepare("
                SELECT id FROM product_reviews 
                WHERE product_id = ? AND user_id = ?
            ");
            $check_stmt->bind_param("ii", $product_id, $user_id);
            $check_stmt->execute();
            
            if ($check_stmt->get_result()->num_rows > 0) {
                throw new Exception('You have already reviewed this product');
            }
            
            // Insert new review
            $stmt = $conn->prepare("
                INSERT INTO product_reviews (product_id, user_id, rating, review) 
                VALUES (?, ?, ?, ?)
            ");
            $stmt->bind_param("iiis", $product_id, $user_id, $rating, $review);
            
            if ($stmt->execute()) {
                $review_id = $conn->insert_id;
                
                // Get the created review with user info
                $get_stmt = $conn->prepare("
                    SELECT 
                        pr.id,
                        pr.product_id,
                        pr.user_id,
                        pr.rating,
                        pr.review,
                        pr.created_at,
                        u.f_name,
                        u.l_name,
                        u.avatar
                    FROM product_reviews pr
                    JOIN users u ON pr.user_id = u.id
                    WHERE pr.id = ?
                ");
                $get_stmt->bind_param("i", $review_id);
                $get_stmt->execute();
                $new_review = $get_stmt->get_result()->fetch_assoc();
                
                echo json_encode([
                    'status' => 'success',
                    'message' => 'Review added successfully',
                    'review' => [
                        'id' => $new_review['id'],
                        'product_id' => $new_review['product_id'],
                        'user_id' => $new_review['user_id'],
                        'rating' => $new_review['rating'],
                        'review' => $new_review['review'],
                        'created_at' => $new_review['created_at'],
                        'user_name' => $new_review['f_name'] . ' ' . $new_review['l_name'],
                        'user_avatar' => $new_review['avatar'] ?: 'uploads/avatar.png'
                    ]
                ]);
            } else {
                throw new Exception('Failed to add review');
            }
            break;
            
        case 'DELETE':
            // Delete a review
            $user_id = getUserId();
            if (!$user_id) {
                throw new Exception('Authentication required');
            }
            
            $input = json_decode(file_get_contents('php://input'), true);
            if (!$input) {
                parse_str(file_get_contents('php://input'), $input);
            }
            
            if (!isset($input['review_id'])) {
                throw new Exception('Review ID is required');
            }
            
            $review_id = intval($input['review_id']);
            
            // Check if user owns this review
            $check_stmt = $conn->prepare("
                SELECT id FROM product_reviews 
                WHERE id = ? AND user_id = ?
            ");
            $check_stmt->bind_param("ii", $review_id, $user_id);
            $check_stmt->execute();
            
            if ($check_stmt->get_result()->num_rows === 0) {
                throw new Exception('You can only delete your own reviews');
            }
            
            // Delete the review
            $stmt = $conn->prepare("DELETE FROM product_reviews WHERE id = ?");
            $stmt->bind_param("i", $review_id);
            
            if ($stmt->execute()) {
                echo json_encode([
                    'status' => 'success',
                    'message' => 'Review deleted successfully'
                ]);
            } else {
                throw new Exception('Failed to delete review');
            }
            break;
            
        default:
            throw new Exception('Method not allowed');
    }
    
} catch (Exception $e) {
    http_response_code(400);
    echo json_encode([
        'status' => 'error',
        'message' => $e->getMessage()
    ]);
}

$conn->close();
?>
