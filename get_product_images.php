<?php
header('Content-Type: application/json');

// Get product ID from request
$product_id = $_GET['id'] ?? '';

if (!$product_id) {
    echo json_encode(['error' => 'Product ID is required']);
    exit;
}

// Database connection
$connect = new mysqli('localhost', 'root', '', 'store');
if ($connect->connect_error) {
    die(json_encode(["error" => "Connection failed: " . $connect->connect_error]));
}

// Get product cover image to determine the folder path
$stmt = $connect->prepare("SELECT cover FROM products WHERE id = ?");
$stmt->bind_param("i", $product_id);
$stmt->execute();
$result = $stmt->get_result();
$product = $result->fetch_assoc();

if (!$product) {
    echo json_encode(['error' => 'Product not found']);
    exit;
}

// Extract folder path from cover image
$cover_path = $product['cover'];
$folder_path = '';

// Extract the directory path from the cover image
if (preg_match('/^(.*\/)[^\/]+$/', $cover_path, $matches)) {
    $folder_path = $matches[1];
} else {
    // If no directory structure, use the default product images folder
    $folder_path = 'img/product/';
}

// Get all images from the folder
$images = [];
if (is_dir($folder_path)) {
    $allowed_extensions = ['jpg', 'jpeg', 'png', 'gif', 'webp'];
    
    $files = scandir($folder_path);
    foreach ($files as $file) {
        if ($file !== '.' && $file !== '..') {
            $extension = strtolower(pathinfo($file, PATHINFO_EXTENSION));
            if (in_array($extension, $allowed_extensions)) {
                $images[] = $folder_path . $file;
            }
        }
    }
    
    // Sort images to ensure consistent order
    sort($images);
    
    // Remove the cover image from the additional images list to avoid duplication
    $images = array_filter($images, function($image) use ($cover_path) {
        return $image !== $cover_path;
    });
    
    // Re-index array after filtering
    $images = array_values($images);
}

echo json_encode([
    'status' => 'success',
    'folder_path' => $folder_path,
    'images' => $images,
    'cover_image' => $cover_path,
    'total_images' => count($images)
]);

$connect->close();
?>
