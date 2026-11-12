package com.cms.repository;

import com.cms.entity.*;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest
@Transactional
public class RepositoryIntegrationTest {

    @Autowired
    private AdminRepository adminRepository;

    @Autowired
    private TeacherRepository teacherRepository;

    @Autowired
    private StudentRepository studentRepository;

    @Autowired
    private CourseRepository courseRepository;

    @Autowired
    private EnrollmentRepository enrollmentRepository;

    @Test
    void testSaveAndReadEachEntity() {
        // 1. Admin
        Admin admin = new Admin("testadmin", "testadmin@edunexora.com", "$2a$10$CG02VXxG7oyIdIYkJdBItuWhKR31i3nMcqfwlJSXhtzOgDKxDMGFa");
        Admin savedAdmin = adminRepository.save(admin);
        assertNotNull(savedAdmin.getId());
        Optional<Admin> foundAdmin = adminRepository.findByUsername("testadmin");
        assertTrue(foundAdmin.isPresent());
        assertEquals("testadmin@edunexora.com", foundAdmin.get().getEmail());

        // 2. Teacher
        Teacher teacher = new Teacher("Test Prof", "test.prof@edunexora.com", "9998887770", "Physics", "$2a$10$CG02VXxG7oyIdIYkJdBItuWhKR31i3nMcqfwlJSXhtzOgDKxDMGFa");
        Teacher savedTeacher = teacherRepository.save(teacher);
        assertNotNull(savedTeacher.getId());
        Optional<Teacher> foundTeacher = teacherRepository.findByEmail("test.prof@edunexora.com");
        assertTrue(foundTeacher.isPresent());
        assertEquals("Test Prof", foundTeacher.get().getName());

        // 3. Student
        Student student = new Student("Test Student", "test.student@student.com", "9998887771", "$2a$10$CG02VXxG7oyIdIYkJdBItuWhKR31i3nMcqfwlJSXhtzOgDKxDMGFa");
        Student savedStudent = studentRepository.save(student);
        assertNotNull(savedStudent.getId());
        Optional<Student> foundStudent = studentRepository.findByEmail("test.student@student.com");
        assertTrue(foundStudent.isPresent());
        assertEquals("Test Student", foundStudent.get().getName());

        // 4. Course
        Course course = new Course("Quantum Computing", "PHY501", "Introduction to Quantum Algorithms", "8 Weeks", new BigDecimal("599.00"), savedTeacher);
        Course savedCourse = courseRepository.save(course);
        assertNotNull(savedCourse.getId());
        Optional<Course> foundCourse = courseRepository.findByCourseCode("PHY501");
        assertTrue(foundCourse.isPresent());
        assertEquals("Quantum Computing", foundCourse.get().getCourseName());
        assertNotNull(foundCourse.get().getTeacher());

        // 5. Enrollment
        Enrollment enrollment = new Enrollment(savedStudent, savedCourse, LocalDate.now(), EnrollmentStatus.ACTIVE);
        Enrollment savedEnrollment = enrollmentRepository.save(enrollment);
        assertNotNull(savedEnrollment.getId());
        Optional<Enrollment> foundEnrollment = enrollmentRepository.findByStudentIdAndCourseId(savedStudent.getId(), savedCourse.getId());
        assertTrue(foundEnrollment.isPresent());
        assertEquals(EnrollmentStatus.ACTIVE, foundEnrollment.get().getStatus());
    }

    @Test
    void testSampleDataQueriesAndFetchJoins() {
        List<Teacher> teachers = teacherRepository.findAll();
        assertFalse(teachers.isEmpty(), "Sample teachers should exist");

        List<Course> courses = courseRepository.findAllWithTeacher();
        assertFalse(courses.isEmpty(), "Sample courses should exist");
        for (Course c : courses) {
            if (c.getTeacher() != null) {
                assertNotNull(c.getTeacher().getName(), "Teacher should be loaded via fetch join");
            }
        }

        List<Object[]> courseCounts = enrollmentRepository.countEnrollmentsPerCourseByStatus(EnrollmentStatus.ACTIVE);
        assertNotNull(courseCounts);

        List<Object[]> dailyCounts = enrollmentRepository.countEnrollmentsPerDay();
        assertNotNull(dailyCounts);
    }
}

