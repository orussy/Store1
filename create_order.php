<?php
error_reporting(0);
ini_set('display_errors', 0);

session_start();
header('Content-Type: application/json');

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

$user_id = intval($_SESSION['user_id']);
$input = json_decode(file_get_contents('php://input'), true) ?: [];
$payment_method = isset($input['payment_method']) ? trim($input['payment_method']) : 'cash';
$address_id = isset($input['address_id']) ? intval($input['address_id']) : 0;
$promo_code = isset($input['promocode']) ? trim($input['promocode']) : '';

// Fetch user's cart and items
$cart_sql = "SELECT id, total FROM cart WHERE user_id = ? LIMIT 1";
$cart_stmt = $conn->prepare($cart_sql);
$cart_stmt->bind_param('i', $user_id);
if (!$cart_stmt->execute()) { echo json_encode(['status'=>'error','message'=>'Failed to load cart']); exit(); }
$cart_res = $cart_stmt->get_result();
if ($cart_res->num_rows === 0) { echo json_encode(['status'=>'error','message'=>'Cart is empty']); exit(); }
$cart_row = $cart_res->fetch_assoc();
$cart_id = intval($cart_row['id']);

$items_sql = "SELECT ci.product_id, ci.product_sku_id, ci.quantity, ps.price, d.discount_type, d.discount_value, d.is_active,
                     d.start_date, d.end_date
              FROM cart_item ci
              JOIN product_skus ps ON ps.id = ci.product_sku_id
              LEFT JOIN discounts d ON d.product_id = ci.product_id AND d.is_active = 1
              WHERE ci.cart_id = ?";
$items_stmt = $conn->prepare($items_sql);
$items_stmt->bind_param('i', $cart_id);
if (!$items_stmt->execute()) { echo json_encode(['status'=>'error','message'=>'Failed to load items']); exit(); }
$items_res = $items_stmt->get_result();

$items = [];
$subtotal = 0.0;
$today = date('Y-m-d');
while ($r = $items_res->fetch_assoc()) {
	$price = floatval($r['price']);
	$final = $price;
	if ($r['is_active'] && $r['start_date'] <= $today && ($r['end_date'] === null || $r['end_date'] >= $today)) {
		if ($r['discount_type'] === 'percentage') $final = $price * (1 - floatval($r['discount_value'])/100);
		else $final = max(0, $price - floatval($r['discount_value']));
	}
	$qty = floatval($r['quantity']);
	$items[] = [
		'product_id' => intval($r['product_id']),
		'product_sku_id' => intval($r['product_sku_id']),
		'quantity' => $qty,
		'unit_price' => $final
	];
	$subtotal += $final * $qty;
}
if (empty($items)) { echo json_encode(['status'=>'error','message'=>'Cart has no items']); exit(); }

// Tax rate (compute amount AFTER discount below)
$tax_rate = 0.0;
$tax_q = $conn->query("SELECT tax_rate FROM tax_rules WHERE country='EG' AND is_active=1 ORDER BY category_id IS NULL DESC, id DESC LIMIT 1");
if ($tax_q && $tax_q->num_rows > 0) { $tax_rate = floatval($tax_q->fetch_assoc()['tax_rate']); }
$tax_amount = 0.0;
$discount_amount = 0.0;
if ($promo_code !== '') {
    $promo_stmt = $conn->prepare("SELECT id, discount_type, discount_value, min_cart_total, max_uses, max_uses_per_user, start_date, end_date, is_active FROM promocodes WHERE code=? LIMIT 1");
	$promo_stmt->bind_param('s', $promo_code);
	if ($promo_stmt->execute()) {
		$pr = $promo_stmt->get_result();
		if ($pr->num_rows > 0) {
			$p = $pr->fetch_assoc();
			$valid = intval($p['is_active']) === 1 && (empty($p['start_date']) || $p['start_date'] <= $today) && (empty($p['end_date']) || $p['end_date'] >= $today) && ($subtotal >= floatval($p['min_cart_total'] ?? 0));
			if ($valid) {
                // Check usage limits
                $promo_id = intval($p['id']);
                $maxUses = isset($p['max_uses']) ? intval($p['max_uses']) : null;
                $maxPerUser = isset($p['max_uses_per_user']) ? intval($p['max_uses_per_user']) : null;

                // Global usage
                $total_used = 0;
                $tuStmt = $conn->prepare("SELECT COALESCE(SUM(used_count),0) as total_used FROM user_promocode_usage WHERE promocode_id = ?");
                $tuStmt->bind_param('i', $promo_id);
                if ($tuStmt->execute()) { $total_used = intval(($tuStmt->get_result()->fetch_assoc())['total_used']); }
                if (!is_null($maxUses) && $maxUses > 0 && $total_used >= $maxUses) { $valid = false; }

                // Per-user usage
                $user_used = 0;
                $uuStmt = $conn->prepare("SELECT used_count FROM user_promocode_usage WHERE user_id = ? AND promocode_id = ? LIMIT 1");
                $uuStmt->bind_param('ii', $user_id, $promo_id);
                if ($uuStmt->execute()) { $r = $uuStmt->get_result(); if ($r->num_rows > 0) { $user_used = intval($r->fetch_assoc()['used_count']); } }
                if (!is_null($maxPerUser) && $maxPerUser > 0 && $user_used >= $maxPerUser) { $valid = false; }

                if ($valid) {
				if ($p['discount_type'] === 'percentage') { $discount_amount = $subtotal * (floatval($p['discount_value'])/100.0); }
				else { $discount_amount = floatval($p['discount_value']); }
				$subtotal = max(0, $subtotal - $discount_amount);
				$applied_promocode_id = intval($p['id']);
                }
			}
		}
	}
}

// Compute tax after applying any promo discounts
$tax_amount = $subtotal * ($tax_rate/100.0);
$grand_total = $subtotal + $tax_amount;

$conn->begin_transaction();
try {
	// Validate address (must belong to current user)
	if ($address_id > 0) {
		$addr_sql = "SELECT id FROM addresses WHERE id = ? AND user_id = ? LIMIT 1";
		$addr_stmt = $conn->prepare($addr_sql);
		$addr_stmt->bind_param('ii', $address_id, $user_id);
		if (!$addr_stmt->execute()) { throw new Exception('Failed to validate address'); }
		$addr_res = $addr_stmt->get_result();
		if ($addr_res->num_rows === 0) { throw new Exception('Invalid delivery address'); }
	} else {
		throw new Exception('Delivery address is required');
	}
    // Create order_details (with address) — store total without tax; tax in tax_amount
    $ins_order_sql = "INSERT INTO order_details (user_id, cart_id, total, status, tax_amount, tax_rate, add_id) VALUES (?, ?, ?, 'Pending', ?, ?, ?)";
    $ins_order = $conn->prepare($ins_order_sql);
    $ins_order->bind_param('iiddii', $user_id, $cart_id, $subtotal, $tax_amount, $tax_rate, $address_id);
	if (!$ins_order->execute()) { throw new Exception('Failed to create order'); }
	$order_id = $conn->insert_id;

	// Insert order items
	$ins_item_sql = "INSERT INTO order_item (order_id, product_id, product_sku_id, quantity) VALUES (?, ?, ?, ?)";
	$ins_item = $conn->prepare($ins_item_sql);
	foreach ($items as $it) {
		$ins_item->bind_param('iiid', $order_id, $it['product_id'], $it['product_sku_id'], $it['quantity']);
		if (!$ins_item->execute()) { throw new Exception('Failed to insert order item'); }
	}

	// Record applied promocode to cart_promocodes
    if (!empty($applied_promocode_id)) {
        // Record cart->promocode link
        $ins_cp = $conn->prepare("INSERT INTO cart_promocodes (cart_id, promocode_id) VALUES (?, ?)");
        $ins_cp->bind_param('ii', $cart_id, $applied_promocode_id);
        if (!$ins_cp->execute()) { throw new Exception('Failed to record promo code'); }

        // Upsert user usage count
        $sel_uu = $conn->prepare("SELECT id, used_count FROM user_promocode_usage WHERE user_id = ? AND promocode_id = ? LIMIT 1");
        $sel_uu->bind_param('ii', $user_id, $applied_promocode_id);
        if (!$sel_uu->execute()) { throw new Exception('Failed to read promo usage'); }
        $uuRes = $sel_uu->get_result();
        if ($uuRes->num_rows > 0) {
            $row = $uuRes->fetch_assoc();
            $newCount = intval($row['used_count']) + 1;
            $upd_uu = $conn->prepare("UPDATE user_promocode_usage SET used_count = ? WHERE id = ?");
            $upd_uu->bind_param('ii', $newCount, $row['id']);
            if (!$upd_uu->execute()) { throw new Exception('Failed to update promo usage'); }
        } else {
            $ins_uu = $conn->prepare("INSERT INTO user_promocode_usage (user_id, promocode_id, used_count) VALUES (?, ?, 1)");
            $ins_uu->bind_param('ii', $user_id, $applied_promocode_id);
            if (!$ins_uu->execute()) { throw new Exception('Failed to insert promo usage'); }
        }
    }

	// Insert payment details
	$provider = ($payment_method === 'visa' || $payment_method === 'card' || $payment_method === 'credit') ? 'credit' : 'cash';
	$pay_sql = "INSERT INTO payment_details (order_id, amount, provider, status) VALUES (?, ?, ?, ?)";
	$pay = $conn->prepare($pay_sql);
	$status = 'pending';
	$pay->bind_param('idss', $order_id, $grand_total, $provider, $status);
	if (!$pay->execute()) { throw new Exception('Failed to insert payment'); }

	// Empty cart items and reset cart total
	$del_sql = "DELETE FROM cart_item WHERE cart_id = ?";
	$del_stmt = $conn->prepare($del_sql);
	$del_stmt->bind_param('i', $cart_id);
	if (!$del_stmt->execute()) { throw new Exception('Failed to clear cart items'); }

	$upd_cart_sql = "UPDATE cart SET total = 0, updated_at = NOW() WHERE id = ?";
	$upd_cart = $conn->prepare($upd_cart_sql);
	$upd_cart->bind_param('i', $cart_id);
	if (!$upd_cart->execute()) { throw new Exception('Failed to reset cart total'); }

	$conn->commit();
	echo json_encode(['status' => 'success', 'order_id' => $order_id]);
} catch (Exception $e) {
	$conn->rollback();
	http_response_code(500);
	echo json_encode(['status' => 'error', 'message' => $e->getMessage()]);
}

$conn->close();
?>


