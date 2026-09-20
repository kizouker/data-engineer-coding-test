INSERT INTO students (first_name, last_name, email, enrolled_on) VALUES
    ('Ada',    'Lovelace', 'ada.lovelace@example.edu',    '2024-09-01'),
    ('Alan',   'Turing',   'alan.turing@example.edu',     '2024-09-01'),
    ('Grace',  'Hopper',   'grace.hopper@example.edu',    '2025-01-15'),
    ('Donald', 'Knuth',    'donald.knuth@example.edu',    '2025-01-15');

INSERT INTO courses (code, title, credits, department) VALUES
    ('CS101', 'Intro to Programming', 5, 'Computer Science'),
    ('CS201', 'Data Structures',      5, 'Computer Science'),
    ('MA101', 'Discrete Math',        4, 'Mathematics');

INSERT INTO enrollments (student_id, course_id, term, grade) VALUES
    (1, 1, '2024-FALL', 5.0),
    (1, 2, '2025-SPRING', 4.5),
    (2, 1, '2024-FALL', 4.0),
    (2, 3, '2024-FALL', 3.5),
    (3, 1, '2025-SPRING', NULL),
    (4, 2, '2025-SPRING', 5.0),
    (4, 3, '2025-SPRING', 4.0);
