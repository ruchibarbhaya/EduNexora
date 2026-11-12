package com.cms.service;

import com.cms.entity.*;
import com.cms.exception.DuplicateResourceException;
import com.cms.exception.ResourceNotFoundException;
import com.cms.repository.CourseRepository;
import com.cms.repository.EnrollmentRepository;
import com.cms.repository.StudentRepository;
import com.cms.repository.TeacherRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;

import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest
@Transactional
public class EnrollmentServiceTest {

    @Autowired
    private EnrollmentService enrollmentService;

    @Autowired
    private StudentRepository studentRepository;

    @Autowired
    private TeacherRepository teacherRepository;

    @Autowired
    private CourseRepository courseRepository;

    @Autowired
    private EnrollmentRepository enrollmentRepository;

    private Student testStudent;
    private Teacher testTeacher;
    private Course testCourse;

    @BeforeEach
    void setUp() {
        testTeacher = teacherRepository.save(new Teacher("Prof Test", "proftest@edunexora.com", "9990001111", "Math", "$2a$10$CG02VXxG7oyIdIYkJdBItuWhKR31i3nMcqfwlJSXhtzOgDKxDMGFa"));
        testStudent = studentRepository.save(new Student("Student Test", "studenttest@student.com", "9990002222", "$2a$10$CG02VXxG7oyIdIYkJdBItuWhKR31i3nMcqfwlJSXhtzOgDKxDMGFa"));
        testCourse = courseRepository.save(new Course("Linear Algebra", "MTH201", "Vectors & Matrices", "10 Weeks", new BigDecimal("300.00"), testTeacher));
    }

    @Test
    void testEnrollmentSuccess() {
        Enrollment enrollment = enrollmentService.enrollStudent(testStudent.getId(), testCourse.getId());
        assertNotNull(enrollment.getId());
        assertEquals(EnrollmentStatus.ACTIVE, enrollment.getStatus());
        assertEquals(LocalDate.now(), enrollment.getEnrollmentDate());
        assertEquals(testStudent.getId(), enrollment.getStudent().getId());
        assertEquals(testCourse.getId(), enrollment.getCourse().getId());
    }

    @Test
    void testDuplicateEnrollmentRejection() {
        enrollmentService.enrollStudent(testStudent.getId(), testCourse.getId());

        DuplicateResourceException ex = assertThrows(DuplicateResourceException.class, () -> {
            enrollmentService.enrollStudent(testStudent.getId(), testCourse.getId());
        });
        assertEquals("You are already enrolled in this course", ex.getMessage());
    }

    @Test
    void testCancelEnrollment() {
        Enrollment enrollment = enrollmentService.enrollStudent(testStudent.getId(), testCourse.getId());
        assertEquals(EnrollmentStatus.ACTIVE, enrollment.getStatus());

        enrollmentService.cancelEnrollment(enrollment.getId());

        Enrollment updated = enrollmentService.getEnrollmentById(enrollment.getId());
        assertEquals(EnrollmentStatus.CANCELLED, updated.getStatus());
    }

    @Test
    void testReactivateCancelledEnrollment() {
        Enrollment enrollment = enrollmentService.enrollStudent(testStudent.getId(), testCourse.getId());
        enrollmentService.cancelEnrollment(enrollment.getId());

        Enrollment cancelled = enrollmentService.getEnrollmentById(enrollment.getId());
        assertEquals(EnrollmentStatus.CANCELLED, cancelled.getStatus());

        // Re-enrolling must reactivate the existing row
        Enrollment reactivated = enrollmentService.enrollStudent(testStudent.getId(), testCourse.getId());
        assertEquals(enrollment.getId(), reactivated.getId(), "Should reactivate same row ID");
        assertEquals(EnrollmentStatus.ACTIVE, reactivated.getStatus());
    }

    @Test
    void testEnrollmentFailsIfCourseHasNoTeacher() {
        Course unassignedCourse = courseRepository.save(
                new Course("Unassigned Physics", "PHY999", "No Instructor", "4 Weeks", new BigDecimal("100.00"), null));

        IllegalStateException ex = assertThrows(IllegalStateException.class, () -> {
            enrollmentService.enrollStudent(testStudent.getId(), unassignedCourse.getId());
        });
        assertTrue(ex.getMessage().contains("does not have an assigned teacher"));
    }
}

