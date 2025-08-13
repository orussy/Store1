<?php
session_start();
require_once 'config/db.php';
header('Content-Type: application/json');

$method = $_SERVER['REQUEST_METHOD'];

try {
	if ($method === 'GET') {
		$productId = isset($_GET['product_id']) ? intval($_GET['product_id']) : 0;
		if ($productId <= 0) {
			http_response_code(400);
			echo json_encode(['status' => 'error', 'message' => 'product_id is required']);
			exit;
		}
		$stmt = $conn->prepare(
			"SELECT c.id, c.user_id, c.product_id, c.comment, c.created_at,
					COALESCE(NULLIF(CONCAT(TRIM(u.f_name), ' ', TRIM(u.l_name)), ' '), u.email) AS user_name
			 FROM comments c
			 JOIN users u ON u.id = c.user_id
			 WHERE c.product_id = ?
			 ORDER BY c.created_at DESC, c.id DESC"
		);
		if (!$stmt) throw new Exception('Prepare failed: ' . $conn->error);
		$stmt->bind_param('i', $productId);
		$stmt->execute();
		$res = $stmt->get_result();
		$items = [];
		while ($row = $res->fetch_assoc()) { $items[] = $row; }
		echo json_encode(['status' => 'success', 'items' => $items]);
		exit;
	}

	if ($method === 'POST') {
		if (!isset($_SESSION['user_id'])) {
			http_response_code(401);
			echo json_encode(['status' => 'error', 'message' => 'Authentication required']);
			exit;
		}
		$payload = json_decode(file_get_contents('php://input'), true) ?: [];
		$productId = isset($payload['product_id']) ? intval($payload['product_id']) : 0;
		$comment = isset($payload['comment']) ? trim($payload['comment']) : '';
		if ($productId <= 0 || $comment === '') {
			http_response_code(400);
			echo json_encode(['status' => 'error', 'message' => 'product_id and comment are required']);
			exit;
		}
		$userId = intval($_SESSION['user_id']);
		$stmt = $conn->prepare("INSERT INTO comments (user_id, product_id, comment, created_at) VALUES (?, ?, ?, NOW())");
		if (!$stmt) throw new Exception('Prepare failed: ' . $conn->error);
		$stmt->bind_param('iis', $userId, $productId, $comment);
		$stmt->execute();
		echo json_encode(['status' => 'success', 'id' => $conn->insert_id]);
		exit;
	}

	http_response_code(405);
	echo json_encode(['status' => 'error', 'message' => 'Method not allowed']);
} catch (Exception $e) {
	http_response_code(500);
	echo json_encode(['status' => 'error', 'message' => $e->getMessage()]);
} 