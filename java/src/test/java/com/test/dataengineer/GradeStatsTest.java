package com.test.dataengineer;

import org.junit.jupiter.api.Test;

import java.util.List;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.assertEquals;

class GradeStatsTest {

    @Test
    void averagesGradesPerCourseAndSkipsNulls() {
        List<GradeStats.Enrollment> enrollments = List.of(
                new GradeStats.Enrollment("CS101", 5.0),
                new GradeStats.Enrollment("CS101", 4.0),
                new GradeStats.Enrollment("CS101", null),
                new GradeStats.Enrollment("MA101", 3.5)
        );

        Map<String, Double> result = GradeStats.averageGradePerCourse(enrollments);

        assertEquals(4.5, result.get("CS101"));
        assertEquals(3.5, result.get("MA101"));
    }
}
