-- College ERP Management System Database Schema

CREATE DATABASE IF NOT EXISTS college_erp;
USE college_erp;

-- 1. Users Table (Authentication & Access Control)
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL,
    role VARCHAR(20) NOT NULL CHECK (role IN ('ADMIN', 'FACULTY', 'STUDENT')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Seed Default Admin User
INSERT INTO users (username, password, role) 
VALUES ('admin', 'Manjeet@2007', 'ADMIN')
ON DUPLICATE KEY UPDATE password='Manjeet@2007';

-- Seed Sample Faculty User
INSERT INTO users (username, password, role) 
VALUES ('faculty1', 'Faculty@123', 'FACULTY')
ON DUPLICATE KEY UPDATE password='Faculty@123';

-- Seed Sample Student User
INSERT INTO users (username, password, role) 
VALUES ('student1', 'Student@123', 'STUDENT')
ON DUPLICATE KEY UPDATE password='Student@123';

-- 2. Departments Table
CREATE TABLE IF NOT EXISTS departments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    dept_code VARCHAR(10) UNIQUE NOT NULL,
    dept_name VARCHAR(100) NOT NULL
);

INSERT INTO departments (dept_code, dept_name) VALUES
('CSE', 'Computer Science & Engineering'),
('ECE', 'Electronics & Communication Engineering'),
('ME', 'Mechanical Engineering')
ON DUPLICATE KEY UPDATE dept_name=VALUES(dept_name);

-- 3. Faculty Details Table
CREATE TABLE IF NOT EXISTS faculty (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT UNIQUE,
    emp_code VARCHAR(20) UNIQUE NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    phone VARCHAR(15),
    dept_id INT,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL,
    FOREIGN KEY (dept_id) REFERENCES departments(id) ON DELETE SET NULL
);

-- 4. Students Table
CREATE TABLE IF NOT EXISTS students (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT UNIQUE,
    roll_number VARCHAR(20) UNIQUE NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    phone VARCHAR(15),
    dept_id INT,
    semester INT DEFAULT 1,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL,
    FOREIGN KEY (dept_id) REFERENCES departments(id) ON DELETE SET NULL
);

-- 5. Courses / Subjects Table
CREATE TABLE IF NOT EXISTS subjects (
    id INT AUTO_INCREMENT PRIMARY KEY,
    subject_code VARCHAR(15) UNIQUE NOT NULL,
    subject_name VARCHAR(100) NOT NULL,
    dept_id INT,
    semester INT NOT NULL,
    FOREIGN KEY (dept_id) REFERENCES departments(id) ON DELETE CASCADE
);

-- 6. Notices Table
CREATE TABLE IF NOT EXISTS notices (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(150) NOT NULL,
    content TEXT NOT NULL,
    posted_by VARCHAR(50) DEFAULT 'Admin',
    target_role VARCHAR(20) DEFAULT 'ALL',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO notices (title, content, posted_by, target_role) VALUES
('Welcome to College ERP', 'The new ERP portal is live for all Students, Faculty, and Staff members.', 'Admin', 'ALL'),
('Mid-Semester Examination Schedule', 'Mid-semester examinations start from next Monday. Check your timetable.', 'Examination Cell', 'ALL');
