<?php
session_start();
header('Content-Type: text/html');

// Check if user is logged in
if (!isset($_SESSION['user_id'])) {
    echo "User not logged in. Session user_id: " . (isset($_SESSION['user_id']) ? $_SESSION['user_id'] : 'NOT SET') . "<br>";
    echo "Session data: <pre>" . print_r($_SESSION, true) . "</pre>";
    exit();
}

$user_id = $_SESSION['user_id'];
echo "<h2>Testing Address System for User ID: $user_id</h2>";

// Test database connection
echo "<h3>1. Testing Database Connection</h3>";
try {
    require_once 'config/db.php';
    echo "✅ Database connection successful<br>";
    echo "Database host: " . $conn->host_info . "<br>";
} catch (Exception $e) {
    echo "❌ Database connection failed: " . $e->getMessage() . "<br>";
    exit();
}

// Test addresses table structure
echo "<h3>2. Testing Addresses Table Structure</h3>";
try {
    $result = $conn->query("DESCRIBE addresses");
    if ($result) {
        echo "✅ Addresses table structure:<br>";
        echo "<table border='1'>";
        echo "<tr><th>Field</th><th>Type</th><th>Null</th><th>Key</th><th>Default</th><th>Extra</th></tr>";
        while ($row = $result->fetch_assoc()) {
            echo "<tr>";
            echo "<td>" . $row['Field'] . "</td>";
            echo "<td>" . $row['Type'] . "</td>";
            echo "<td>" . $row['Null'] . "</td>";
            echo "<td>" . $row['Key'] . "</td>";
            echo "<td>" . $row['Default'] . "</td>";
            echo "<td>" . $row['Extra'] . "</td>";
            echo "</tr>";
        }
        echo "</table>";
    } else {
        echo "❌ Failed to describe addresses table<br>";
    }
} catch (Exception $e) {
    echo "❌ Error describing table: " . $e->getMessage() . "<br>";
}

// Test fetching addresses
echo "<h3>3. Testing Address Fetching</h3>";
try {
    $stmt = $conn->prepare("SELECT * FROM addresses WHERE user_id = ? AND deleted_at IS NULL ORDER BY created_at DESC");
    $stmt->bind_param("i", $user_id);
    $stmt->execute();
    $result = $stmt->get_result();
    $addresses = $result->fetch_all(MYSQLI_ASSOC);
    
    echo "✅ Found " . count($addresses) . " addresses for user $user_id<br>";
    
    if (count($addresses) > 0) {
        echo "<table border='1'>";
        echo "<tr><th>ID</th><th>Title</th><th>Address1</th><th>City</th><th>Country</th><th>Latitude</th><th>Longitude</th><th>Created</th></tr>";
        foreach ($addresses as $address) {
            echo "<tr>";
            echo "<td>" . $address['id'] . "</td>";
            echo "<td>" . $address['title'] . "</td>";
            echo "<td>" . $address['address1'] . "</td>";
            echo "<td>" . $address['city'] . "</td>";
            echo "<td>" . $address['country'] . "</td>";
            echo "<td>" . ($address['latitude'] ?? 'NULL') . "</td>";
            echo "<td>" . ($address['longitude'] ?? 'NULL') . "</td>";
            echo "<td>" . $address['created_at'] . "</td>";
            echo "</tr>";
        }
        echo "</table>";
    } else {
        echo "No addresses found for this user<br>";
    }
    
    $stmt->close();
} catch (Exception $e) {
    echo "❌ Error fetching addresses: " . $e->getMessage() . "<br>";
}

// Test get_user_addresses.php API
echo "<h3>4. Testing get_user_addresses.php API</h3>";
try {
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, 'http://' . $_SERVER['HTTP_HOST'] . dirname($_SERVER['REQUEST_URI']) . '/get_user_addresses.php');
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_COOKIE, 'PHPSESSID=' . session_id());
    
    $response = curl_exec($ch);
    $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    curl_close($ch);
    
    echo "HTTP Response Code: $httpCode<br>";
    echo "Response: <pre>" . htmlspecialchars($response) . "</pre>";
    
    if ($response) {
        $data = json_decode($response, true);
        if ($data) {
            echo "✅ JSON decoded successfully<br>";
            echo "Status: " . ($data['status'] ?? 'NOT SET') . "<br>";
            echo "Message: " . ($data['message'] ?? 'NOT SET') . "<br>";
            echo "Addresses count: " . (isset($data['addresses']) ? count($data['addresses']) : 'NOT SET') . "<br>";
        } else {
            echo "❌ Failed to decode JSON response<br>";
        }
    }
} catch (Exception $e) {
    echo "❌ Error testing API: " . $e->getMessage() . "<br>";
}

// Test sample data insertion
echo "<h3>5. Testing Sample Data Insertion</h3>";
try {
    // Check if user already has addresses
    $stmt = $conn->prepare("SELECT COUNT(*) as count FROM addresses WHERE user_id = ? AND deleted_at IS NULL");
    $stmt->bind_param("i", $user_id);
    $stmt->execute();
    $result = $stmt->get_result();
    $count = $result->fetch_assoc()['count'];
    $stmt->close();
    
    if ($count == 0) {
        echo "User has no addresses. Inserting sample data...<br>";
        
        $stmt = $conn->prepare("
            INSERT INTO addresses (user_id, title, address1, address2, country, city, postal_code, latitude, longitude, location_accuracy, created_at) 
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW())
        ");
        
        $title = 'Home';
        $address1 = '123 Test Street';
        $address2 = 'Apartment 1A';
        $country = 'Egypt';
        $city = 'Cairo';
        $postal_code = '11511';
        $latitude = 30.0444;
        $longitude = 31.2357;
        $location_accuracy = 'exact';
        
        $stmt->bind_param("issssssdds", $user_id, $title, $address1, $address2, $country, $city, $postal_code, $latitude, $longitude, $location_accuracy);
        
        if ($stmt->execute()) {
            echo "✅ Sample address inserted successfully. ID: " . $conn->insert_id . "<br>";
        } else {
            echo "❌ Failed to insert sample address: " . $stmt->error . "<br>";
        }
        
        $stmt->close();
    } else {
        echo "User already has $count addresses. Skipping sample data insertion.<br>";
    }
} catch (Exception $e) {
    echo "❌ Error with sample data: " . $e->getMessage() . "<br>";
}

echo "<br><h3>Test Complete</h3>";
echo "<a href='user-profile.html'>Go to User Profile</a>";
?>
