-- Scratch space for the actual test's SQL questions.
-- A couple of warm-up examples against the seed schema:

-- Average grade per course
SELECT c.code, c.title, ROUND(AVG(e.grade), 2) AS avg_grade
FROM enrollments e
JOIN courses c ON c.course_id = e.course_id
WHERE e.grade IS NOT NULL
GROUP BY c.code, c.title
ORDER BY avg_grade DESC;

-- Students with no completed (graded) enrollments yet
SELECT s.student_id, s.first_name, s.last_name
FROM students s
LEFT JOIN enrollments e ON e.student_id = s.student_id AND e.grade IS NOT NULL
WHERE e.enrollment_id IS NULL;
