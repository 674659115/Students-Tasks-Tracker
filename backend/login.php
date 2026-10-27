<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

require_once "db_config.php";

$rawInput = file_get_contents("php://input");
$data = json_decode($rawInput, true);

if (!$data) {
    $data = $_POST;
}

$email = trim($data["email"] ?? "");
$password = trim($data["password"] ?? "");

if (empty($email) || empty($password)) {
    echo json_encode(["status" => "error", "message" => "Email and password are required."]);
    exit();
}

$stmt = $conn->prepare("SELECT id, name, email, password FROM users WHERE email = ?");
if (!$stmt) {
    echo json_encode(["status" => "error", "message" => "SQL Prepare Error: " . $conn->error]);
    exit();
}

$stmt->bind_param("s", $email);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows === 0) {
    echo json_encode(["status" => "error", "message" => "Invalid email or password."]);
    exit();
}

$user = $result->fetch_assoc();

if (password_verify($password, $user["password"])) {
    echo json_encode([
        "status" => "success",
        "message" => "Login successful!",
        "user" => [
            "id" => (string)$user["id"],
            "name" => $user["name"],
            "email" => $user["email"]
        ]
    ]);
} else {
    echo json_encode(["status" => "error", "message" => "Invalid email or password."]);
}
?>
