<?php
error_reporting(0);
ini_set('display_errors', 0);

session_start();
header('Content-Type: application/json');

require_once 'config/db.php';

if (!$conn) {
	http_response_code(500);
	echo json_encode(['status' => 'error', 'message' => 'Database connection failed']);
	exit();
}

// Default country; you can enhance by reading user's address later
$country = 'EG';
$today = date('Y-m-d');

$sql = "SELECT tax_rate FROM tax_rules WHERE country = ? AND is_active = 1 AND (start_date IS NULL OR start_date <= ?) AND (end_date IS NULL OR end_date >= ?) ORDER BY category_id IS NULL DESC, id DESC LIMIT 1";
$stmt = $conn->prepare($sql);
if (!$stmt) {
	http_response_code(500);
	echo json_encode(['status' => 'error', 'message' => 'Prepare failed']);
	exit();
}

$stmt->bind_param('sss', $country, $today, $today);
if (!$stmt->execute()) {
	http_response_code(500);
	echo json_encode(['status' => 'error', 'message' => 'Execute failed']);
	exit();
}

$res = $stmt->get_result();
if ($row = $res->fetch_assoc()) {
	echo json_encode(['status' => 'success', 'tax_rate' => floatval($row['tax_rate'])]);
} else {
	echo json_encode(['status' => 'success', 'tax_rate' => 0]);
}

$conn->close();
?>


