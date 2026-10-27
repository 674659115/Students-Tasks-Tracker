<?php
require_once "db_config.php";

$data = json_decode(file_get_contents("php://input"), true);

$email = trim($data["email"] ?? "");
$password = trim($data["password"] ?? "");

if (empty($email) || empty($password)) {
    echo json_encode(["status" => "error", "message" => "Email and password are required."]);
    exit();
}

$stmt = $conn->prepare("SELECT id, name, email, password FROM users WHERE email = ?");
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
