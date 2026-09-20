"""Starter ETL module. Replace with the actual test's task."""

from __future__ import annotations

import pandas as pd


def average_grade_per_course(enrollments: pd.DataFrame, courses: pd.DataFrame) -> pd.DataFrame:
    """Join enrollments to courses and return average grade per course code.

    enrollments: columns [student_id, course_id, term, grade]
    courses: columns [course_id, code, title, credits, department]
    """
    graded = enrollments.dropna(subset=["grade"])
    merged = graded.merge(courses, on="course_id")
    result = (
        merged.groupby(["code", "title"])["grade"]
        .mean()
        .round(2)
        .reset_index(name="avg_grade")
        .sort_values("avg_grade", ascending=False)
    )
    return result.reset_index(drop=True)
