-- EduNexora Course Management System
-- Sample Data
-- Password for all sample teachers and students is: Password@123
-- BCrypt Hash: $2a$10$CG02VXxG7oyIdIYkJdBItuWhKR31i3nMcqfwlJSXhtzOgDKxDMGFa

-- Insert 3 Teachers
INSERT INTO teacher (id, name, email, phone, department, password, created_at) VALUES
(1, 'Dr. Alan Turing', 'alan.turing@edunexora.com', '9876543210', 'Computer Science', '$2a$10$CG02VXxG7oyIdIYkJdBItuWhKR31i3nMcqfwlJSXhtzOgDKxDMGFa', NOW()),
(2, 'Prof. Ada Lovelace', 'ada.lovelace@edunexora.com', '9876543211', 'Software Engineering', '$2a$10$CG02VXxG7oyIdIYkJdBItuWhKR31i3nMcqfwlJSXhtzOgDKxDMGFa', NOW()),
(3, 'Dr. Grace Hopper', 'grace.hopper@edunexora.com', '9876543212', 'Information Systems', '$2a$10$CG02VXxG7oyIdIYkJdBItuWhKR31i3nMcqfwlJSXhtzOgDKxDMGFa', NOW());

-- Insert 5 Courses
INSERT INTO course (id, course_name, course_code, description, duration, fees, teacher_id, created_at) VALUES
(1, 'Full Stack Java & Spring Boot', 'CS101', 'Master enterprise Java development, Spring Boot, Spring Data JPA, Spring Security, and modern full-stack web applications.', '12 Weeks', 499.00, 1, NOW()),
(2, 'Data Structures & Algorithms', 'CS102', 'In-depth study of core data structures, graph algorithms, dynamic programming, and algorithm complexity analysis.', '10 Weeks', 399.00, 1, NOW()),
(3, 'Cloud Architecture with AWS', 'SE201', 'Learn to design, deploy, and scale resilient cloud infrastructures using AWS core services, Docker, and CI/CD pipelines.', '8 Weeks', 450.00, 2, NOW()),
(4, 'Database Design & MySQL Optimization', 'SE202', 'Advanced database normalization, query profiling, indexing strategies, transactions, and performance tuning.', '6 Weeks', 350.00, 2, NOW()),
(5, 'Cybersecurity & Ethical Hacking', 'IS301', 'Comprehensive fundamentals of network defense, web vulnerabilities, penetration testing, and security compliance.', '8 Weeks', 550.00, 3, NOW());

-- Insert 5 Students
INSERT INTO student (id, name, email, phone, password, created_at) VALUES
(1, 'Alice Smith', 'alice.smith@student.com', '9123456780', '$2a$10$CG02VXxG7oyIdIYkJdBItuWhKR31i3nMcqfwlJSXhtzOgDKxDMGFa', NOW()),
(2, 'Bob Johnson', 'bob.johnson@student.com', '9123456781', '$2a$10$CG02VXxG7oyIdIYkJdBItuWhKR31i3nMcqfwlJSXhtzOgDKxDMGFa', NOW()),
(3, 'Charlie Brown', 'charlie.brown@student.com', '9123456782', '$2a$10$CG02VXxG7oyIdIYkJdBItuWhKR31i3nMcqfwlJSXhtzOgDKxDMGFa', NOW()),
(4, 'Diana Prince', 'diana.prince@student.com', '9123456783', '$2a$10$CG02VXxG7oyIdIYkJdBItuWhKR31i3nMcqfwlJSXhtzOgDKxDMGFa', NOW()),
(5, 'Edward Davis', 'edward.davis@student.com', '9123456784', '$2a$10$CG02VXxG7oyIdIYkJdBItuWhKR31i3nMcqfwlJSXhtzOgDKxDMGFa', NOW());

-- Insert Enrollments
INSERT INTO enrollment (id, student_id, course_id, enrollment_date, status, created_at) VALUES
(1, 1, 1, '2026-11-01', 'ACTIVE', NOW()),
(2, 1, 2, '2026-11-02', 'ACTIVE', NOW()),
(3, 2, 1, '2026-11-03', 'ACTIVE', NOW()),
(4, 2, 3, '2026-11-04', 'ACTIVE', NOW()),
(5, 3, 2, '2026-11-05', 'ACTIVE', NOW()),
(6, 4, 4, '2026-11-06', 'ACTIVE', NOW()),
(7, 5, 5, '2026-11-07', 'CANCELLED', NOW());

