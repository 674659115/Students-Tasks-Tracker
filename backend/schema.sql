-- Database setup script for Students Task Tracker
CREATE DATABASE IF NOT EXISTS students_tasks_tracker_db;
USE students_tasks_tracker_db;

CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Seed default sample user:
-- Email: SirWilliam@gmail.com
-- Password: password123
INSERT INTO users (name, email, password)
VALUES (
    'Sir William',
    'SirWilliam@gmail.com',
    '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.XoBxMbfPO'
)
ON DUPLICATE KEY UPDATE name = VALUES(name);
