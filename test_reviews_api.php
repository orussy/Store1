<?php
// Simple test for the reviews API
echo "<h2>Testing Reviews API</h2>";

// Test 1: Check if the API file exists and is accessible
echo "<h3>Test 1: API File Check</h3>";
if (file_exists('product_reviews_api.php')) {
    echo "✅ product_reviews_api.php exists<br>";
} else {
    echo "❌ product_reviews_api.php not found<br>";
}

// Test 2: Test API call
echo "<h3>Test 2: API Call Test</h3>";
$url = 'http://localhost/Store/product_reviews_api.php?product_id=1';
echo "Testing URL: " . $url . "<br>";

$context = stream_context_create([
    'http' => [
        'method' => 'GET',
        'header' => 'Content-Type: application/json'
    ]
]);

$response = file_get_contents($url, false, $context);
if ($response === false) {
    echo "❌ API call failed<br>";
    echo "Error: " . error_get_last()['message'] . "<br>";
} else {
    echo "✅ API call successful<br>";
    echo "Response: <pre>" . htmlspecialchars($response) . "</pre>";
}

// Test 3: Check database connection
echo "<h3>Test 3: Database Connection</h3>";
require_once 'config/db.php';

if ($conn) {
    echo "✅ Database connection successful<br>";
    
    // Test if product_reviews table exists
    $result = $conn->query("SHOW TABLES LIKE 'product_reviews'");
    if ($result->num_rows > 0) {
        echo "✅ product_reviews table exists<br>";
        
        // Check table structure
        $result = $conn->query("DESCRIBE product_reviews");
        echo "Table structure:<br>";
        echo "<table border='1'><tr><th>Field</th><th>Type</th><th>Null</th><th>Key</th><th>Default</th></tr>";
        while ($row = $result->fetch_assoc()) {
            echo "<tr><td>" . $row['Field'] . "</td><td>" . $row['Type'] . "</td><td>" . $row['Null'] . "</td><td>" . $row['Key'] . "</td><td>" . $row['Default'] . "</td></tr>";
        }
        echo "</table>";
        
        // Check if there are any reviews
        $result = $conn->query("SELECT COUNT(*) as count FROM product_reviews");
        $count = $result->fetch_assoc()['count'];
        echo "Total reviews in database: " . $count . "<br>";
        
    } else {
        echo "❌ product_reviews table does not exist<br>";
    }
} else {
    echo "❌ Database connection failed<br>";
}

$conn->close();
?>

