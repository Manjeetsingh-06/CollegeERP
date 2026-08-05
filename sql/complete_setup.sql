-- =====================================================
-- University of Lucknow ERP — Complete Database Setup
-- Run this file on Railway MySQL or any MySQL 8.0+
-- =====================================================

CREATE DATABASE IF NOT EXISTS college_erp CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE college_erp;

-- 1. USERS TABLE
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL,
    role VARCHAR(20) NOT NULL CHECK (role IN ('ADMIN', 'FACULTY', 'STUDENT')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
INSERT INTO users (username, password, role) VALUES
('admin',    'Manjeet@2007', 'ADMIN'),
('faculty1', 'Faculty@123',  'FACULTY'),
('student1', 'Student@123',  'STUDENT')
ON DUPLICATE KEY UPDATE password=VALUES(password);

-- 2. DEPARTMENTS
CREATE TABLE IF NOT EXISTS departments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    dept_code VARCHAR(10) UNIQUE NOT NULL,
    dept_name VARCHAR(100) NOT NULL
);
INSERT INTO departments (dept_code, dept_name) VALUES
('CSE', 'Computer Science & Engineering'),
('IT',  'Information Technology'),
('ECE', 'Electronics & Communication Engineering'),
('ME',  'Mechanical Engineering'),
('CE',  'Civil Engineering')
ON DUPLICATE KEY UPDATE dept_name=VALUES(dept_name);

-- 3. FACULTY
CREATE TABLE IF NOT EXISTS faculty (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT UNIQUE,
    emp_code VARCHAR(20) UNIQUE NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    phone VARCHAR(15),
    dept_id INT,
    designation VARCHAR(50) DEFAULT 'Assistant Professor',
    FOREIGN KEY (user_id)  REFERENCES users(id)       ON DELETE SET NULL,
    FOREIGN KEY (dept_id)  REFERENCES departments(id)  ON DELETE SET NULL
);
INSERT INTO faculty (user_id, emp_code, full_name, email, phone, dept_id, designation) VALUES
(2, 'FAC001', 'Dr. Ramesh Sharma', 'ramesh@lkouniv.ac.in', '9876543210', 1, 'Associate Professor')
ON DUPLICATE KEY UPDATE full_name=VALUES(full_name);

-- 4. STUDENTS
CREATE TABLE IF NOT EXISTS students (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT UNIQUE,
    roll_number VARCHAR(20) UNIQUE NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    phone VARCHAR(15),
    dept_id INT,
    semester INT DEFAULT 1,
    admission_year INT DEFAULT 2024,
    FOREIGN KEY (user_id)  REFERENCES users(id)       ON DELETE SET NULL,
    FOREIGN KEY (dept_id)  REFERENCES departments(id)  ON DELETE SET NULL
);
INSERT INTO students (user_id, roll_number, full_name, email, phone, dept_id, semester) VALUES
(3, '24CSE001', 'Arjun Kumar',   'arjun@email.com',  '9988776655', 1, 1),
(NULL, '24CSE002', 'Priya Singh',   'priya@email.com',  '9871234567', 1, 1),
(NULL, '24CSE003', 'Rahul Verma',   'rahul@email.com',  '9812345678', 1, 2),
(NULL, '24IT001',  'Sneha Gupta',   'sneha@email.com',  '9823456789', 2, 1),
(NULL, '24ECE001', 'Mohit Tiwari',  'mohit@email.com',  '9834567890', 3, 3)
ON DUPLICATE KEY UPDATE full_name=VALUES(full_name);

-- 5. SUBJECTS
CREATE TABLE IF NOT EXISTS subjects (
    id INT AUTO_INCREMENT PRIMARY KEY,
    subject_code VARCHAR(15) UNIQUE NOT NULL,
    subject_name VARCHAR(100) NOT NULL,
    dept_id INT,
    semester INT NOT NULL,
    credits INT DEFAULT 4,
    FOREIGN KEY (dept_id) REFERENCES departments(id) ON DELETE CASCADE
);
INSERT INTO subjects (subject_code, subject_name, dept_id, semester, credits) VALUES
('CS101', 'Data Structures & Algorithms',    1, 1, 4),
('CS102', 'Database Management Systems',     1, 1, 4),
('CS103', 'Java Enterprise Programming',     1, 1, 3),
('CS104', 'Computer Networks',               1, 2, 4),
('CS105', 'Operating Systems',               1, 2, 4),
('IT101', 'Web Technologies',                2, 1, 4),
('EC101', 'Digital Electronics',             3, 1, 4),
('ME101', 'Engineering Mechanics',           4, 1, 4)
ON DUPLICATE KEY UPDATE subject_name=VALUES(subject_name);

-- 6. ATTENDANCE
CREATE TABLE IF NOT EXISTS attendance (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    subject_id INT NOT NULL,
    attendance_date DATE NOT NULL,
    status VARCHAR(10) NOT NULL CHECK (status IN ('PRESENT', 'ABSENT')),
    marked_by VARCHAR(50) DEFAULT 'Faculty',
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
    FOREIGN KEY (subject_id) REFERENCES subjects(id) ON DELETE CASCADE,
    UNIQUE KEY unique_daily (student_id, subject_id, attendance_date)
);
INSERT INTO attendance (student_id, subject_id, attendance_date, status) VALUES
(1, 1, CURDATE() - INTERVAL 1 DAY, 'PRESENT'),
(1, 1, CURDATE() - INTERVAL 2 DAY, 'PRESENT'),
(1, 1, CURDATE() - INTERVAL 3 DAY, 'ABSENT'),
(1, 2, CURDATE() - INTERVAL 1 DAY, 'PRESENT'),
(2, 1, CURDATE() - INTERVAL 1 DAY, 'PRESENT'),
(2, 1, CURDATE() - INTERVAL 2 DAY, 'ABSENT')
ON DUPLICATE KEY UPDATE status=VALUES(status);

-- 7. MARKS
CREATE TABLE IF NOT EXISTS marks (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    subject_id INT NOT NULL,
    exam_type VARCHAR(30) NOT NULL,
    marks_obtained DECIMAL(5,2) NOT NULL,
    max_marks DECIMAL(5,2) DEFAULT 100.00,
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
    FOREIGN KEY (subject_id) REFERENCES subjects(id) ON DELETE CASCADE,
    UNIQUE KEY unique_exam (student_id, subject_id, exam_type)
);
INSERT INTO marks (student_id, subject_id, exam_type, marks_obtained, max_marks) VALUES
(1, 1, 'Mid Semester', 78.00, 100.00),
(1, 2, 'Mid Semester', 85.00, 100.00),
(1, 3, 'Mid Semester', 91.00, 100.00),
(2, 1, 'Mid Semester', 72.00, 100.00),
(2, 2, 'Mid Semester', 68.00, 100.00)
ON DUPLICATE KEY UPDATE marks_obtained=VALUES(marks_obtained);

-- 8. FEE STRUCTURE
CREATE TABLE IF NOT EXISTS fee_structure (
    id INT AUTO_INCREMENT PRIMARY KEY,
    dept_id INT NOT NULL,
    semester INT NOT NULL,
    tuition_fee DECIMAL(10,2) DEFAULT 0.00,
    exam_fee DECIMAL(10,2) DEFAULT 0.00,
    other_fee DECIMAL(10,2) DEFAULT 0.00,
    total_fee DECIMAL(10,2) GENERATED ALWAYS AS (tuition_fee + exam_fee + other_fee) STORED,
    FOREIGN KEY (dept_id) REFERENCES departments(id) ON DELETE CASCADE,
    UNIQUE KEY unique_dept_sem (dept_id, semester)
);
INSERT INTO fee_structure (dept_id, semester, tuition_fee, exam_fee, other_fee) VALUES
(1,1,55000,4000,8000),(1,2,55000,4000,8000),(1,3,55000,4000,8000),(1,4,55000,4000,8000),
(1,5,55000,4000,8000),(1,6,55000,4000,8000),(1,7,55000,4000,8000),(1,8,55000,4000,8000),
(2,1,52000,4000,7500),(2,2,52000,4000,7500),(2,3,52000,4000,7500),(2,4,52000,4000,7500),
(3,1,50000,3500,6500),(3,2,50000,3500,6500),(3,3,50000,3500,6500),(3,4,50000,3500,6500),
(4,1,48000,3500,6000),(4,2,48000,3500,6000),(4,3,48000,3500,6000),(4,4,48000,3500,6000),
(5,1,45000,3000,5000),(5,2,45000,3000,5000),(5,3,45000,3000,5000),(5,4,45000,3000,5000)
ON DUPLICATE KEY UPDATE tuition_fee=VALUES(tuition_fee), exam_fee=VALUES(exam_fee), other_fee=VALUES(other_fee);

-- 9. PAYMENTS
CREATE TABLE IF NOT EXISTS payments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    receipt_no VARCHAR(30) UNIQUE NOT NULL,
    student_id INT NOT NULL,
    amount_paid DECIMAL(10,2) NOT NULL,
    payment_date DATE NOT NULL,
    payment_mode VARCHAR(20) DEFAULT 'Online',
    transaction_id VARCHAR(50),
    remarks VARCHAR(150),
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE
);
INSERT INTO payments (receipt_no, student_id, amount_paid, payment_date, payment_mode) VALUES
('REC-2024001', 1, 67000.00, '2024-07-15', 'Online'),
('REC-2024002', 2, 30000.00, '2024-07-20', 'Cash')
ON DUPLICATE KEY UPDATE amount_paid=VALUES(amount_paid);

-- 10. BOOKS
CREATE TABLE IF NOT EXISTS books (
    id INT AUTO_INCREMENT PRIMARY KEY,
    isbn VARCHAR(30) UNIQUE NOT NULL,
    title VARCHAR(150) NOT NULL,
    author VARCHAR(100) NOT NULL,
    category VARCHAR(50) DEFAULT 'General',
    total_copies INT DEFAULT 1,
    available_copies INT DEFAULT 1
);
INSERT INTO books (isbn, title, author, category, total_copies, available_copies) VALUES
('978-0134685991', 'Effective Java (3rd Edition)',       'Joshua Bloch',      'Computer Science',    5, 4),
('978-0132350884', 'Clean Code',                         'Robert C. Martin',  'Software Engineering',3, 3),
('978-0201633610', 'Design Patterns (GoF)',              'Gang of Four',      'Computer Science',    2, 2),
('978-1491950357', 'Database Design for Mere Mortals',  'Michael Hernandez', 'Database',            4, 4),
('978-0596009205', 'Head First Java',                   'Kathy Sierra',      'Java Programming',    6, 5)
ON DUPLICATE KEY UPDATE title=VALUES(title);

-- 11. BOOK ISSUES
CREATE TABLE IF NOT EXISTS book_issues (
    id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT NOT NULL,
    student_id INT NOT NULL,
    issue_date DATE NOT NULL,
    due_date DATE NOT NULL,
    return_date DATE,
    fine_amount DECIMAL(8,2) DEFAULT 0.00,
    status VARCHAR(20) DEFAULT 'ISSUED',
    FOREIGN KEY (book_id)    REFERENCES books(id)    ON DELETE CASCADE,
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE
);
INSERT INTO book_issues (book_id, student_id, issue_date, due_date, status) VALUES
(1, 1, CURDATE() - INTERVAL 7 DAY, CURDATE() + INTERVAL 7 DAY, 'ISSUED'),
(5, 3, CURDATE() - INTERVAL 3 DAY, CURDATE() + INTERVAL 11 DAY, 'ISSUED')
ON DUPLICATE KEY UPDATE status=VALUES(status);

-- 12. TIMETABLE
CREATE TABLE IF NOT EXISTS timetable (
    id INT AUTO_INCREMENT PRIMARY KEY,
    dept_id INT NOT NULL,
    semester INT NOT NULL,
    day_of_week VARCHAR(15) NOT NULL,
    subject_id INT NOT NULL,
    time_slot VARCHAR(30) NOT NULL,
    room_no VARCHAR(20) DEFAULT 'Room 101',
    FOREIGN KEY (dept_id)    REFERENCES departments(id) ON DELETE CASCADE,
    FOREIGN KEY (subject_id) REFERENCES subjects(id)    ON DELETE CASCADE
);
INSERT INTO timetable (dept_id, semester, day_of_week, subject_id, time_slot, room_no) VALUES
(1, 1, 'Monday',    1, '09:00 - 10:00', 'CS Lab 1'),
(1, 1, 'Monday',    2, '10:00 - 11:00', 'Room 201'),
(1, 1, 'Tuesday',   3, '09:00 - 10:00', 'CS Lab 2'),
(1, 1, 'Wednesday', 1, '11:00 - 12:00', 'CS Lab 1'),
(1, 1, 'Thursday',  2, '09:00 - 10:00', 'Room 202'),
(1, 1, 'Friday',    3, '02:00 - 03:00', 'CS Lab 2')
ON DUPLICATE KEY UPDATE room_no=VALUES(room_no);

-- 13. COMPLAINTS
CREATE TABLE IF NOT EXISTS complaints (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    subject_title VARCHAR(150) NOT NULL,
    description TEXT NOT NULL,
    status VARCHAR(20) DEFAULT 'PENDING',
    admin_response TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE
);
INSERT INTO complaints (student_id, subject_title, description, status) VALUES
(1, 'Library Book Not Available', 'The book I reserved is not available. Please check.', 'PENDING'),
(2, 'Fee Receipt Issue', 'My fee receipt was not generated after online payment.', 'IN_PROGRESS')
ON DUPLICATE KEY UPDATE status=VALUES(status);

-- 14. NOTICES
CREATE TABLE IF NOT EXISTS notices (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(150) NOT NULL,
    content TEXT NOT NULL,
    posted_by VARCHAR(50) DEFAULT 'Admin',
    target_role VARCHAR(20) DEFAULT 'ALL',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
INSERT INTO notices (title, content, posted_by, target_role) VALUES
('Welcome to University of Lucknow ERP', 'Dear Students, the new ERP portal is now live. Use your credentials to login. Contact admin for any issues.', 'Admin', 'ALL'),
('Mid-Semester Examination Schedule Released', 'Mid-semester exams start from next Monday. Check your timetable for schedule.', 'Examination Cell', 'STUDENT'),
('Faculty Meeting — Important', 'All faculty members are requested to attend the department meeting on Saturday at 10 AM.', 'Admin', 'FACULTY'),
('Fee Submission Deadline Extended', 'Fee submission deadline extended to 31st August 2024. Pay online via the Fee Portal.', 'Finance Office', 'STUDENT')
ON DUPLICATE KEY UPDATE title=VALUES(title);

-- Done!
SELECT 'Database setup complete for University of Lucknow ERP!' AS Status;
