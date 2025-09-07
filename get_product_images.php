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

// Get product cover image from product_skus to determine the folder path
$stmt = $connect->prepare("SELECT ps.cover FROM products p 
                          LEFT JOIN product_skus ps ON p.id = ps.product_id 
                          WHERE p.id = ? AND ps.id IS NOT NULL AND ps.cover IS NOT NULL AND ps.cover != ''
                          ORDER BY ps.id LIMIT 1");
$stmt->bind_param("i", $product_id);
$stmt->execute();
$result = $stmt->get_result();
$product = $result->fetch_assoc();

if (!$product) {
    echo json_encode(['error' => 'Product not found or no cover image available']);
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

// Get all variant images from product_skus
$stmt = $connect->prepare("SELECT ps.cover, ps.sku, pa_size.value as size_value, pa_color.value as color_value
                          FROM product_skus ps
                          LEFT JOIN product_attributes pa_size ON ps.size_attribute_id = pa_size.id
                          LEFT JOIN product_attributes pa_color ON ps.color_attribute_id = pa_color.id
                          WHERE ps.product_id = ? AND ps.cover IS NOT NULL AND ps.cover != ''
                          ORDER BY ps.id");
$stmt->bind_param("i", $product_id);
$stmt->execute();
$result = $stmt->get_result();

$images = [];
$variant_images = [];

while ($row = $result->fetch_assoc()) {
    if (!empty($row['cover'])) {
        $variant_images[] = [
            'image' => $row['cover'],
            'sku' => $row['sku'],
            'size' => $row['size_value'],
            'color' => $row['color_value']
        ];
    }
}

// Get additional images from the folder (if any)
$additional_images = [];
if (is_dir($folder_path)) {
    $allowed_extensions = ['jpg', 'jpeg', 'png', 'gif', 'webp'];
    
    $files = scandir($folder_path);
    foreach ($files as $file) {
        if ($file !== '.' && $file !== '..') {
            $extension = strtolower(pathinfo($file, PATHINFO_EXTENSION));
            if (in_array($extension, $allowed_extensions)) {
                $additional_images[] = $folder_path . $file;
            }
        }
    }
    
    // Sort additional images
    sort($additional_images);
    
    // Remove variant images from additional images to avoid duplication
    $variant_image_paths = array_column($variant_images, 'image');
    $additional_images = array_filter($additional_images, function($image) use ($variant_image_paths) {
        return !in_array($image, $variant_image_paths);
    });
    
    // Re-index array after filtering
    $additional_images = array_values($additional_images);
}

// Combine variant images and additional images
$images = array_merge($variant_images, $additional_images);

echo json_encode([
    'status' => 'success',
    'folder_path' => $folder_path,
    'images' => $images,
    'cover_image' => $cover_path,
    'total_images' => count($images)
]);

$connect->close();
?>
