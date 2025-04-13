<?php
header('Content-Type: application/json');

$directory = 'img/slideshow/';
$images = [];

if (is_dir($directory)) {
    $files = scandir($directory);
    foreach ($files as $file) {
        if ($file != '.' && $file != '..') {
            $ext = strtolower(pathinfo($file, PATHINFO_EXTENSION));
            if (in_array($ext, ['jpg', 'jpeg', 'png', 'gif', 'webp'])) {
                $images[] = $file;
            }
        }
    }
}

echo json_encode($images);
?> 