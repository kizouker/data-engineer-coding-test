import pandas as pd

from src.etl import average_grade_per_course


def test_average_grade_per_course():
    enrollments = pd.DataFrame(
        [
            {"student_id": 1, "course_id": 1, "term": "2024-FALL", "grade": 5.0},
            {"student_id": 2, "course_id": 1, "term": "2024-FALL", "grade": 4.0},
            {"student_id": 3, "course_id": 1, "term": "2025-SPRING", "grade": None},
        ]
    )
    courses = pd.DataFrame(
        [{"course_id": 1, "code": "CS101", "title": "Intro to Programming"}]
    )

    result = average_grade_per_course(enrollments, courses)

    assert list(result.columns) == ["code", "title", "avg_grade"]
    assert result.loc[0, "code"] == "CS101"
    assert result.loc[0, "avg_grade"] == 4.5
