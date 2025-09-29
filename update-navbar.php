<?php
/**
 * Script to automatically update all pages with the new navbar
 */

$pages_to_update = [
    'forgot-password.html',
    'reset_password.html', 
    'verify-email.html',
    'google-profile.html',
    'clear_cache.html'
];

$php_pages_to_update = [
    'login.php',
    'reg.php',
    'forgot_password.php',
    'reset_password_process.php',
    'verify_email.php',
    'google_login.php'
];

function updateHtmlPage($filename) {
    if (!file_exists($filename)) {
        echo "File $filename not found\n";
        return false;
    }
    
    $content = file_get_contents($filename);
    
    // Add navbar CSS if not present
    if (strpos($content, 'style/new-navbar.css') === false) {
        $content = preg_replace(
            '/(<link rel="stylesheet" href="style\/[^"]+\.css">)/',
            '$1' . "\n    <link rel=\"stylesheet\" href=\"style/new-navbar.css\">",
            $content
        );
        
        // If no style.css found, add both
        if (strpos($content, 'style/style.css') === false) {
            $content = preg_replace(
                '/(<head>)/',
                '$1' . "\n    <link rel=\"stylesheet\" href=\"style/style.css\">\n    <link rel=\"stylesheet\" href=\"style/new-navbar.css\">\n    <link rel=\"stylesheet\" href=\"https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.2/css/all.min.css\">",
                $content
            );
        }
    }
    
    // Add navbar root div if not present
    if (strpos($content, 'id="navbar-root"') === false) {
        $content = preg_replace(
            '/(<body[^>]*>)/',
            '$1' . "\n    <div id=\"navbar-root\"></div>",
            $content
        );
    }
    
    // Add navbar script if not present
    if (strpos($content, 'js/navbar.js') === false) {
        $content = preg_replace(
            '/(<\/body>)/',
            '    <script src="js/navbar.js"></script>\n$1',
            $content
        );
    }
    
    file_put_contents($filename, $content);
    echo "Updated $filename\n";
    return true;
}

function updatePhpPage($filename) {
    if (!file_exists($filename)) {
        echo "File $filename not found\n";
        return false;
    }
    
    $content = file_get_contents($filename);
    
    // Add navbar CSS if not present
    if (strpos($content, 'style/new-navbar.css') === false) {
        $content = preg_replace(
            '/(<link rel="stylesheet" href="style\/[^"]+\.css">)/',
            '$1' . "\n    <link rel=\"stylesheet\" href=\"style/new-navbar.css\">",
            $content
        );
        
        // If no style.css found, add both
        if (strpos($content, 'style/style.css') === false) {
            $content = preg_replace(
                '/(<head>)/',
                '$1' . "\n    <link rel=\"stylesheet\" href=\"style/style.css\">\n    <link rel=\"stylesheet\" href=\"style/new-navbar.css\">\n    <link rel=\"stylesheet\" href=\"https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.2/css/all.min.css\">",
                $content
            );
        }
    }
    
    // Add navbar root div if not present
    if (strpos($content, 'id="navbar-root"') === false) {
        $content = preg_replace(
            '/(<body[^>]*>)/',
            '$1' . "\n    <div id=\"navbar-root\"></div>",
            $content
        );
    }
    
    // Add navbar script if not present
    if (strpos($content, 'js/navbar.js') === false) {
        $content = preg_replace(
            '/(<\/body>)/',
            '    <script src="js/navbar.js"></script>\n$1',
            $content
        );
    }
    
    file_put_contents($filename, $content);
    echo "Updated $filename\n";
    return true;
}

echo "Updating HTML pages...\n";
foreach ($pages_to_update as $page) {
    updateHtmlPage($page);
}

echo "\nUpdating PHP pages...\n";
foreach ($php_pages_to_update as $page) {
    updatePhpPage($page);
}

echo "\nNavbar update complete!\n";
?>
