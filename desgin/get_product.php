<?php
session_start();
$connect= new mysqli ('localhost','root','','store'); 
if ($connect->connect_error) {
    die("Connection failed: " . $connect->connect_error);
}
header("Content-Type: application/json");

$query="SELECT * FROM products";
$res=mysqli_query($connect,$query);

if (!$res) {
    die(json_encode([
        'error' => 'Query failed: ' . mysqli_error($connect)
    ]));
}

$products=array();
while($row = mysqli_fetch_array($res)) {
    $products[]=$row;
}
echo json_encode($products);
?> 