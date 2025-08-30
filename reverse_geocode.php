<?php
header('Content-Type: application/json');

// Get coordinates from request
$lat = $_GET['lat'] ?? null;
$lon = $_GET['lon'] ?? null;

if (!$lat || !$lon) {
    echo json_encode(['status' => 'error', 'message' => 'Latitude and longitude are required']);
    exit();
}

// Validate coordinates
if (!is_numeric($lat) || !is_numeric($lon)) {
    echo json_encode(['status' => 'error', 'message' => 'Invalid coordinates']);
    exit();
}

try {
    // Use OpenStreetMap Nominatim for reverse geocoding (free service)
    $url = "https://nominatim.openstreetmap.org/reverse?format=json&lat={$lat}&lon={$lon}&zoom=18&addressdetails=1";
    
    // Set user agent to avoid being blocked
    $context = stream_context_create([
        'http' => [
            'method' => 'GET',
            'header' => 'User-Agent: Store1-Address-System/1.0'
        ]
    ]);
    
    $response = file_get_contents($url, false, $context);
    
    if ($response === false) {
        throw new Exception('Failed to fetch address data');
    }
    
    $data = json_decode($response, true);
    
    if (!$data || isset($data['error'])) {
        throw new Exception('No address found for these coordinates');
    }
    
    // Extract address components
    $address = $data['address'] ?? [];
    $display_name = $data['display_name'] ?? '';
    
    // Build address components
    $address1 = '';
    $city = '';
    $country = '';
    $postal_code = '';
    
    // Extract house number and road for address1
    if (isset($address['house_number']) && isset($address['road'])) {
        $address1 = $address['house_number'] . ' ' . $address['road'];
    } elseif (isset($address['road'])) {
        $address1 = $address['road'];
    } elseif (isset($address['suburb'])) {
        $address1 = $address['suburb'];
    } else {
        $address1 = $display_name;
    }
    
    // Extract city
    if (isset($address['city'])) {
        $city = $address['city'];
    } elseif (isset($address['town'])) {
        $city = $address['town'];
    } elseif (isset($address['village'])) {
        $city = $address['village'];
    } elseif (isset($address['municipality'])) {
        $city = $address['municipality'];
    }
    
    // Extract country
    if (isset($address['country'])) {
        $country = $address['country'];
    }
    
    // Extract postal code
    if (isset($address['postcode'])) {
        $postal_code = $address['postcode'];
    }
    
    // Clean up address1 if it's too long
    if (strlen($address1) > 255) {
        $address1 = substr($address1, 0, 252) . '...';
    }
    
    echo json_encode([
        'status' => 'success',
        'address' => [
            'address1' => $address1,
            'city' => $city,
            'country' => $country,
            'postal_code' => $postal_code,
            'full_address' => $display_name
        ]
    ]);
    
} catch (Exception $e) {
    echo json_encode([
        'status' => 'error',
        'message' => $e->getMessage()
    ]);
}
?>
