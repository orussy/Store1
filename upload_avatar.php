<?php
session_start();
header('Content-Type: application/json');

require_once 'config/db.php';

// Ensure user is authenticated
if (!isset($_SESSION['user_id'])) {
	echo json_encode([
		"status" => "error",
		"message" => "User not authenticated"
	]);
	exit();
}

// Only allow POST with file upload
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
	echo json_encode([
		"status" => "error",
		"message" => "Invalid request method"
	]);
	exit();
}

if (!isset($_FILES['avatar']) || $_FILES['avatar']['error'] !== UPLOAD_ERR_OK) {
	echo json_encode([
		"status" => "error",
		"message" => "No image uploaded or upload error"
	]);
	exit();
}

$userId = intval($_SESSION['user_id']);
$file = $_FILES['avatar'];

// Basic validation
$allowedMime = ['image/jpeg', 'image/png', 'image/webp'];
$finfo = finfo_open(FILEINFO_MIME_TYPE);
$mime = finfo_file($finfo, $file['tmp_name']);
finfo_close($finfo);

if (!in_array($mime, $allowedMime)) {
	echo json_encode([
		"status" => "error",
		"message" => "Only JPG, PNG, or WEBP images are allowed"
	]);
	exit();
}

// Limit size to ~5MB
if ($file['size'] > 5 * 1024 * 1024) {
	echo json_encode([
		"status" => "error",
		"message" => "Image is too large (max 5MB)"
	]);
	exit();
}

// Ensure upload directory exists
$uploadDir = __DIR__ . DIRECTORY_SEPARATOR . 'uploads' . DIRECTORY_SEPARATOR . 'profile_pictures' . DIRECTORY_SEPARATOR;
if (!is_dir($uploadDir)) {
	@mkdir($uploadDir, 0777, true);
}

// Build deterministic filename: <userId>_avatar.<ext>
$ext = 'png';
switch ($mime) {
	case 'image/jpeg':
		$ext = 'jpg';
		break;
	case 'image/png':
		$ext = 'png';
		break;
	case 'image/webp':
		$ext = 'webp';
		break;
}

$filename = $userId . '_avatar.' . $ext;
$targetPath = $uploadDir . $filename;

// Move uploaded file
if (!move_uploaded_file($file['tmp_name'], $targetPath)) {
	echo json_encode([
		"status" => "error",
		"message" => "Failed to save uploaded image"
	]);
	exit();
}

// Public path to store in DB (relative to project root)
$publicPath = 'uploads/profile_pictures/' . $filename;

// Update users.avatar path
$stmt = $conn->prepare("UPDATE users SET avatar = ? WHERE id = ? AND deleted_at IS NULL");
$stmt->bind_param('si', $publicPath, $userId);

if (!$stmt->execute()) {
	echo json_encode([
		"status" => "error",
		"message" => "Database update failed"
	]);
	$stmt->close();
	exit();
}

$stmt->close();

// Respond with cache-busted URL
$avatarUrl = $publicPath . (strpos($publicPath, '?') === false ? ('?ts=' . time()) : ('&ts=' . time()));

echo json_encode([
	"status" => "success",
	"message" => "Avatar updated successfully",
	"avatar" => $avatarUrl
]);

$conn->close();
?>


