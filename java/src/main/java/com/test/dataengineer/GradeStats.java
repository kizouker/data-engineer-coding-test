package com.test.dataengineer;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/** Starter class. Replace with whatever the actual test's Java task requires. */
public class GradeStats {

    public record Enrollment(String courseCode, Double grade) {}

    /** Average grade per course code, skipping ungraded enrollments. */
    public static Map<String, Double> averageGradePerCourse(List<Enrollment> enrollments) {
        return enrollments.stream()
                .filter(e -> e.grade() != null)
                .collect(Collectors.groupingBy(
                        Enrollment::courseCode,
                        Collectors.averagingDouble(Enrollment::grade)));
    }
}
