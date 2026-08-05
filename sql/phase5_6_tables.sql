USE college_erp;

-- 1. Books Table
CREATE TABLE IF NOT EXISTS books (
    id INT AUTO_INCREMENT PRIMARY KEY,
    isbn VARCHAR(30) UNIQUE NOT NULL,
    title VARCHAR(150) NOT NULL,
    author VARCHAR(100) NOT NULL,
    category VARCHAR(50) DEFAULT 'General',
    total_copies INT DEFAULT 1,
    available_copies INT DEFAULT 1
);

-- Seed Sample Books
INSERT INTO books (isbn, title, author, category, total_copies, available_copies) VALUES
('978-0134685991', 'Effective Java (3rd Edition)', 'Joshua Bloch', 'Computer Science', 5, 5),
('978-0132350884', 'Clean Code', 'Robert C. Martin', 'Software Engineering', 3, 3)
ON DUPLICATE KEY UPDATE title=VALUES(title);

-- 2. Book Issues Table
CREATE TABLE IF NOT EXISTS book_issues (
    id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT NOT NULL,
    student_id INT NOT NULL,
    issue_date DATE NOT NULL,
    due_date DATE NOT NULL,
    return_date DATE,
    fine_amount DECIMAL(8,2) DEFAULT 0.00,
    status VARCHAR(20) DEFAULT 'ISSUED',
    FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE CASCADE,
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE
);

-- 3. Timetable Table
CREATE TABLE IF NOT EXISTS timetable (
    id INT AUTO_INCREMENT PRIMARY KEY,
    dept_id INT NOT NULL,
    semester INT NOT NULL,
    day_of_week VARCHAR(15) NOT NULL,
    subject_id INT NOT NULL,
    time_slot VARCHAR(30) NOT NULL,
    room_no VARCHAR(20) DEFAULT 'Lab 101',
    FOREIGN KEY (dept_id) REFERENCES departments(id) ON DELETE CASCADE,
    FOREIGN KEY (subject_id) REFERENCES subjects(id) ON DELETE CASCADE
);

-- 4. Complaints System Table
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
