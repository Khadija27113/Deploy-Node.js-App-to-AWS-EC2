-- database/schema.sql
CREATE DATABASE IF NOT EXISTS myapp;
USE myapp;

CREATE TABLE IF NOT EXISTS tasks (
  id INT AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  -- Renamed 'completed' to 'is_completed' to match the Node.js logic
  -- Using TINYINT(1) which is the standard MySQL way to represent Booleans
  is_completed TINYINT(1) DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert sample tasks for testing
INSERT INTO tasks (title, is_completed) VALUES ('Build full-stack app', 1); 
INSERT INTO tasks (title, is_completed) VALUES ('Deploy to AWS', 0);