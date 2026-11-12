package com.cms.service;

import com.cms.entity.Enrollment;
import com.cms.entity.EnrollmentStatus;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.util.List;

public interface EnrollmentService {
    Enrollment enrollStudent(Long studentId, Long courseId);
    void cancelEnrollment(Long enrollmentId);
    Enrollment getEnrollmentById(Long id);
    Page<Enrollment> searchEnrollments(Long courseId, EnrollmentStatus status, String search, Pageable pageable);
    List<Enrollment> getStudentEnrollments(Long studentId);
    List<Enrollment> getTeacherEnrollments(Long teacherId);
    Page<Enrollment> searchTeacherEnrollments(Long teacherId, Long courseId, EnrollmentStatus status, String search, Pageable pageable);
    List<Enrollment> getCourseEnrollments(Long courseId);
    List<Object[]> getCoursePopularityData();
    List<Object[]> getDailyEnrollmentTrends();
}

