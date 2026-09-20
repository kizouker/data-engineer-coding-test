-- Starter schema: small academic domain.
-- Replace/extend with whatever schema the actual test specifies.

DROP TABLE IF EXISTS enrollments;
DROP TABLE IF EXISTS courses;
DROP TABLE IF EXISTS students;

CREATE TABLE students (
    student_id   SERIAL PRIMARY KEY,
    first_name   TEXT NOT NULL,
    last_name    TEXT NOT NULL,
    email        TEXT UNIQUE NOT NULL,
    enrolled_on  DATE NOT NULL
);

CREATE TABLE courses (
    course_id    SERIAL PRIMARY KEY,
    code         TEXT UNIQUE NOT NULL,
    title        TEXT NOT NULL,
    credits      INTEGER NOT NULL CHECK (credits > 0),
    department   TEXT NOT NULL
);

CREATE TABLE enrollments (
    enrollment_id SERIAL PRIMARY KEY,
    student_id    INTEGER NOT NULL REFERENCES students(student_id),
    course_id     INTEGER NOT NULL REFERENCES courses(course_id),
    term          TEXT NOT NULL,       -- e.g. '2025-FALL'
    grade         NUMERIC(4,2),        -- NULL if in progress
    UNIQUE (student_id, course_id, term)
);
