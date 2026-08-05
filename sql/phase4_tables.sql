USE college_erp;

-- 1. Fee Structure Table
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

-- Seed Sample Fee Structure
INSERT INTO fee_structure (dept_id, semester, tuition_fee, exam_fee, other_fee) VALUES
(1, 1, 45000.00, 2500.00, 2500.00), -- CSE Sem 1 = Total 50,000
(1, 2, 45000.00, 2500.00, 2500.00)
ON DUPLICATE KEY UPDATE tuition_fee=VALUES(tuition_fee);

-- 2. Student Payments Table
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
