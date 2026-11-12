package com.cms.service;

import com.cms.entity.*;
import com.cms.exception.DuplicateResourceException;
import com.cms.exception.ResourceNotFoundException;
import com.cms.repository.CourseRepository;
import com.cms.repository.EnrollmentRepository;
import com.cms.repository.StudentRepository;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Service
public class EnrollmentServiceImpl implements EnrollmentService {

    private final EnrollmentRepository enrollmentRepository;
    private final StudentRepository studentRepository;
    private final CourseRepository courseRepository;

    public EnrollmentServiceImpl(EnrollmentRepository enrollmentRepository,
                                 StudentRepository studentRepository,
                                 CourseRepository courseRepository) {
        this.enrollmentRepository = enrollmentRepository;
        this.studentRepository = studentRepository;
        this.courseRepository = courseRepository;
    }

    @Override
    @Transactional
    public Enrollment enrollStudent(Long studentId, Long courseId) {
        Student student = studentRepository.findById(studentId)
                .orElseThrow(() -> new ResourceNotFoundException("Student not found with ID: " + studentId));

        Course course = courseRepository.findByIdWithTeacher(courseId)
                .orElseThrow(() -> new ResourceNotFoundException("Course not found with ID: " + courseId));

        if (course.getTeacher() == null) {
            throw new IllegalStateException("This course currently does not have an assigned teacher and is not open for enrollment.");
        }

        Optional<Enrollment> existingOpt = enrollmentRepository.findByStudentIdAndCourseId(studentId, courseId);
        if (existingOpt.isPresent()) {
            Enrollment existing = existingOpt.get();
            if (existing.getStatus() == EnrollmentStatus.ACTIVE) {
                throw new DuplicateResourceException("You are already enrolled in this course");
            } else {
                // Re-enrolling after a cancellation reactivates the existing enrollment row
                existing.setStatus(EnrollmentStatus.ACTIVE);
                existing.setEnrollmentDate(LocalDate.now());
                return enrollmentRepository.save(existing);
            }
        }

        try {
            Enrollment newEnrollment = new Enrollment(student, course, LocalDate.now(), EnrollmentStatus.ACTIVE);
            return enrollmentRepository.saveAndFlush(newEnrollment);
        } catch (DataIntegrityViolationException ex) {
            // Handle double-submit race condition on composite unique constraint
            throw new DuplicateResourceException("You are already enrolled in this course");
        }
    }

    @Override
    @Transactional
    public void cancelEnrollment(Long enrollmentId) {
        Enrollment enrollment = enrollmentRepository.findById(enrollmentId)
                .orElseThrow(() -> new ResourceNotFoundException("Enrollment not found with ID: " + enrollmentId));
        enrollment.setStatus(EnrollmentStatus.CANCELLED);
        enrollmentRepository.save(enrollment);
    }

    @Override
    @Transactional(readOnly = true)
    public Enrollment getEnrollmentById(Long id) {
        return enrollmentRepository.findByIdWithDetails(id)
                .orElseThrow(() -> new ResourceNotFoundException("Enrollment record not found with ID: " + id));
    }

    @Override
    @Transactional(readOnly = true)
    public Page<Enrollment> searchEnrollments(Long courseId, EnrollmentStatus status, String search, Pageable pageable) {
        String query = (search != null && !search.trim().isEmpty()) ? search.trim() : null;
        return enrollmentRepository.searchEnrollments(courseId, status, query, pageable);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Enrollment> getStudentEnrollments(Long studentId) {
        return enrollmentRepository.findByStudentIdWithCourse(studentId);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Enrollment> getTeacherEnrollments(Long teacherId) {
        return enrollmentRepository.findByTeacherIdWithDetails(teacherId);
    }

    @Override
    @Transactional(readOnly = true)
    public Page<Enrollment> searchTeacherEnrollments(Long teacherId, Long courseId, EnrollmentStatus status, String search, Pageable pageable) {
        String query = (search != null && !search.trim().isEmpty()) ? search.trim() : null;
        return enrollmentRepository.searchTeacherEnrollments(teacherId, courseId, status, query, pageable);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Enrollment> getCourseEnrollments(Long courseId) {
        return enrollmentRepository.findByCourseIdWithDetails(courseId);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Object[]> getCoursePopularityData() {
        return enrollmentRepository.countEnrollmentsPerCourseByStatus(EnrollmentStatus.ACTIVE);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Object[]> getDailyEnrollmentTrends() {
        return enrollmentRepository.countEnrollmentsPerDay();
    }
}

