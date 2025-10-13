<?php
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

if (!isset($_SESSION['user_id'])) {
	http_response_code(401);
	echo json_encode(['status' => 'error', 'message' => 'Not authenticated']);
	exit();
}

require_once 'config/db.php';
if (!$conn) { http_response_code(500); echo json_encode(['status'=>'error','message'=>'DB failed']); exit(); }

$input = json_decode(file_get_contents('php://input'), true) ?: [];
$code = isset($input['code']) ? trim($input['code']) : '';
if ($code === '') { http_response_code(400); echo json_encode(['status'=>'error','message'=>'Code required']); exit(); }

$user_id = intval($_SESSION['user_id']);

// Compute current subtotal for user's cart
$sql = "SELECT ci.quantity, ps.price, d.discount_type, d.discount_value, d.is_active, d.start_date, d.end_date
        FROM cart_item ci
        JOIN cart c ON c.id = ci.cart_id AND c.user_id = ?
        JOIN product_skus ps ON ps.id = ci.product_sku_id
        LEFT JOIN discounts d ON d.product_id = ci.product_id AND d.is_active = 1";
$stmt = $conn->prepare($sql);
$stmt->bind_param('i', $user_id);
if (!$stmt->execute()) { http_response_code(500); echo json_encode(['status'=>'error','message'=>'Failed to compute subtotal']); exit(); }
$res = $stmt->get_result();
$subtotal = 0.0; $today = date('Y-m-d');
while ($r = $res->fetch_assoc()) {
	$price = floatval($r['price']);
	$final = $price;
	if ($r['is_active'] && $r['start_date'] <= $today && ($r['end_date'] === null || $r['end_date'] >= $today)) {
		if ($r['discount_type'] === 'percentage') $final = $price * (1 - floatval($r['discount_value'])/100);
		else $final = max(0, $price - floatval($r['discount_value']));
	}
	$subtotal += $final * floatval($r['quantity']);
}

// Validate promocode
$promo_sql = "SELECT id, code, discount_type, discount_value, min_cart_total, max_uses, max_uses_per_user, start_date, end_date, is_active
              FROM promocodes WHERE code = ? LIMIT 1";
$promo = $conn->prepare($promo_sql);
$promo->bind_param('s', $code);
if (!$promo->execute()) { http_response_code(500); echo json_encode(['status'=>'error','message'=>'Failed to validate code']); exit(); }
$pRes = $promo->get_result();
if ($pRes->num_rows === 0) { echo json_encode(['status'=>'error','message'=>'Invalid promo code']); exit(); }
$p = $pRes->fetch_assoc();

if (intval($p['is_active']) !== 1) { echo json_encode(['status'=>'error','message'=>'Promo code inactive']); exit(); }
$today = date('Y-m-d');
if (!empty($p['start_date']) && $p['start_date'] > $today) { echo json_encode(['status'=>'error','message'=>'Promo not started']); exit(); }
if (!empty($p['end_date']) && $p['end_date'] < $today) { echo json_encode(['status'=>'error','message'=>'Promo expired']); exit(); }

$minTotal = is_null($p['min_cart_total']) ? 0.0 : floatval($p['min_cart_total']);
if ($subtotal < $minTotal) { echo json_encode(['status'=>'error','message'=>'Minimum cart total not met']); exit(); }

// Usage limits (global and per-user)
$promo_id = intval($p['id']);
$maxUses = isset($p['max_uses']) ? intval($p['max_uses']) : null;
$maxPerUser = isset($p['max_uses_per_user']) ? intval($p['max_uses_per_user']) : null;

// Global usage count
$total_used = 0;
$tuStmt = $conn->prepare("SELECT COALESCE(SUM(used_count),0) as total_used FROM user_promocode_usage WHERE promocode_id = ?");
$tuStmt->bind_param('i', $promo_id);
if ($tuStmt->execute()) { $total_used = intval(($tuStmt->get_result()->fetch_assoc())['total_used']); }
if (!is_null($maxUses) && $maxUses > 0 && $total_used >= $maxUses) {
    echo json_encode(['status'=>'error','message'=>'Promo code usage limit reached']);
    exit();
}

// Per-user usage count
$user_used = 0;
$uuStmt = $conn->prepare("SELECT used_count FROM user_promocode_usage WHERE user_id = ? AND promocode_id = ? LIMIT 1");
$uuStmt->bind_param('ii', $user_id, $promo_id);
if ($uuStmt->execute()) {
    $r = $uuStmt->get_result();
    if ($r->num_rows > 0) { $user_used = intval($r->fetch_assoc()['used_count']); }
}
if (!is_null($maxPerUser) && $maxPerUser > 0 && $user_used >= $maxPerUser) {
    echo json_encode(['status'=>'error','message'=>'You have already used this promo the maximum number of times']);
    exit();
}

// Compute discounted subtotal
$discountType = $p['discount_type'];
$discountValue = floatval($p['discount_value']);
$discountAmount = 0.0;
if ($discountType === 'percentage') { $discountAmount = $subtotal * ($discountValue/100.0); }
else { $discountAmount = $discountValue; }
$discountedSubtotal = max(0, $subtotal - $discountAmount);

echo json_encode([
	'status' => 'success',
	'promocode' => [
		'id' => intval($p['id']),
		'code' => $p['code'],
		'discount_type' => $discountType,
		'discount_value' => $discountValue,
		'min_cart_total' => $minTotal,
		'max_uses' => is_null($maxUses) ? null : $maxUses,
		'max_uses_per_user' => is_null($maxPerUser) ? null : $maxPerUser,
		'global_used' => $total_used,
		'user_used' => $user_used
	],
	'subtotal' => $subtotal,
	'discount_amount' => $discountAmount,
	'discounted_subtotal' => $discountedSubtotal
]);

$conn->close();
?>


