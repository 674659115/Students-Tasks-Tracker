<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json; charset=UTF-8");

$host = "localhost";
$user = "root";
$password = "";
$database = "students_tasks_tracker_db";

$conn = new mysqli($host, $user, $password, $database);

if ($conn->connect_error) {
    echo json_encode(["status" => "error", "message" => "Database Connection Failed: " . $conn->connect_error]);
    exit();
}
?>
