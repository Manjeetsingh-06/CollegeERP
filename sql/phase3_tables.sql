USE college_erp;

-- 1. Subjects Table
CREATE TABLE IF NOT EXISTS subjects (
    id INT AUTO_INCREMENT PRIMARY KEY,
    subject_code VARCHAR(15) UNIQUE NOT NULL,
    subject_name VARCHAR(100) NOT NULL,
    dept_id INT,
    semester INT NOT NULL,
    FOREIGN KEY (dept_id) REFERENCES departments(id) ON DELETE CASCADE
);

-- Seed Sample Subjects
INSERT INTO subjects (subject_code, subject_name, dept_id, semester) VALUES
('CS101', 'Data Structures & Algorithms', 1, 1),
('CS102', 'Database Management Systems', 1, 1),
('CS103', 'Java Enterprise Programming', 1, 1)
ON DUPLICATE KEY UPDATE subject_name=VALUES(subject_name);

-- 2. Attendance Table
CREATE TABLE IF NOT EXISTS attendance (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    subject_id INT NOT NULL,
    attendance_date DATE NOT NULL,
    status VARCHAR(10) NOT NULL CHECK (status IN ('PRESENT', 'ABSENT')),
    marked_by VARCHAR(50) DEFAULT 'Faculty',
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
    FOREIGN KEY (subject_id) REFERENCES subjects(id) ON DELETE CASCADE,
    UNIQUE KEY unique_daily_attendance (student_id, subject_id, attendance_date)
);

-- 3. Marks Table
CREATE TABLE IF NOT EXISTS marks (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    subject_id INT NOT NULL,
    exam_type VARCHAR(30) NOT NULL,
    marks_obtained DECIMAL(5,2) NOT NULL,
    max_marks DECIMAL(5,2) DEFAULT 100.00,
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
    FOREIGN KEY (subject_id) REFERENCES subjects(id) ON DELETE CASCADE,
    UNIQUE KEY unique_student_exam (student_id, subject_id, exam_type)
);
