<?php
require_once "db_config.php";

$rawInput = file_get_contents("php://input");
$data = json_decode($rawInput, true);

if (!$data) {
    $data = $_POST;
}

$name = trim($data["name"] ?? "");
$email = trim($data["email"] ?? "");
$password = trim($data["password"] ?? "");

if (empty($name) || empty($email) || empty($password)) {
    echo json_encode(["status" => "error", "message" => "Name, email, and password are required."]);
    exit();
}

// Name & Surname Check (at least two words)
$nameParts = array_filter(explode(" ", $name));
if (count($nameParts) < 2) {
    echo json_encode(["status" => "error", "message" => "Please enter both First Name and Surname (e.g. John Doe)."]);
    exit();
}

// Check existing email
$stmt = $conn->prepare("SELECT id FROM users WHERE email = ?");
$stmt->bind_param("s", $email);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows > 0) {
    echo json_encode(["status" => "error", "message" => "Email address is already registered."]);
    exit();
}

// Insert user into MySQL database
$hashedPassword = password_hash($password, PASSWORD_DEFAULT);
$stmt = $conn->prepare("INSERT INTO users (name, email, password) VALUES (?, ?, ?)");
$stmt->bind_param("sss", $name, $email, $hashedPassword);

if ($stmt->execute()) {
    $userId = $conn->insert_id;
    echo json_encode([
        "status" => "success",
        "message" => "Registration successful!",
        "user" => [
            "id" => (string)$userId,
            "name" => $name,
            "email" => $email
        ]
    ]);
} else {
    echo json_encode(["status" => "error", "message" => "Failed to create user account: " . $conn->error]);
}
?>
