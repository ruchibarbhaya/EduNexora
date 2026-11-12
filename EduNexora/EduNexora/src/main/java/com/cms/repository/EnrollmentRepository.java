package com.cms.repository;

import com.cms.entity.Enrollment;
import com.cms.entity.EnrollmentStatus;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface EnrollmentRepository extends JpaRepository<Enrollment, Long> {

    Optional<Enrollment> findByStudentIdAndCourseId(Long studentId, Long courseId);
    boolean existsByStudentIdAndCourseId(Long studentId, Long courseId);
    long countByCourseId(Long courseId);
    long countByCourseIdAndStatus(Long courseId, EnrollmentStatus status);
    long countByStatus(EnrollmentStatus status);

    @Query("SELECT e FROM Enrollment e JOIN FETCH e.student s JOIN FETCH e.course c LEFT JOIN FETCH c.teacher WHERE e.id = :id")
    Optional<Enrollment> findByIdWithDetails(@Param("id") Long id);

    @Query("SELECT e FROM Enrollment e JOIN FETCH e.course c LEFT JOIN FETCH c.teacher WHERE e.student.id = :studentId ORDER BY e.id DESC")
    List<Enrollment> findByStudentIdWithCourse(@Param("studentId") Long studentId);

    @Query("SELECT e FROM Enrollment e JOIN FETCH e.student s JOIN FETCH e.course c LEFT JOIN FETCH c.teacher WHERE c.teacher.id = :teacherId ORDER BY e.id DESC")
    List<Enrollment> findByTeacherIdWithDetails(@Param("teacherId") Long teacherId);

    @Query("SELECT e FROM Enrollment e JOIN FETCH e.student s JOIN FETCH e.course c LEFT JOIN FETCH c.teacher WHERE c.id = :courseId ORDER BY e.id DESC")
    List<Enrollment> findByCourseIdWithDetails(@Param("courseId") Long courseId);

    @Query("SELECT e FROM Enrollment e JOIN FETCH e.student s JOIN FETCH e.course c LEFT JOIN FETCH c.teacher WHERE " +
           "(:courseId IS NULL OR c.id = :courseId) AND " +
           "(:status IS NULL OR e.status = :status) AND " +
           "(:search IS NULL OR LOWER(s.name) LIKE LOWER(CONCAT('%', :search, '%')) OR LOWER(s.email) LIKE LOWER(CONCAT('%', :search, '%')) OR LOWER(c.courseName) LIKE LOWER(CONCAT('%', :search, '%')))")
    Page<Enrollment> searchEnrollments(@Param("courseId") Long courseId,
                                       @Param("status") EnrollmentStatus status,
                                       @Param("search") String search,
                                       Pageable pageable);

    @Query("SELECT e FROM Enrollment e JOIN FETCH e.student s JOIN FETCH e.course c LEFT JOIN FETCH c.teacher WHERE " +
           "c.teacher.id = :teacherId AND " +
           "(:courseId IS NULL OR c.id = :courseId) AND " +
           "(:status IS NULL OR e.status = :status) AND " +
           "(:search IS NULL OR LOWER(s.name) LIKE LOWER(CONCAT('%', :search, '%')) OR LOWER(s.email) LIKE LOWER(CONCAT('%', :search, '%')) OR LOWER(s.phone) LIKE LOWER(CONCAT('%', :search, '%')))")
    Page<Enrollment> searchTeacherEnrollments(@Param("teacherId") Long teacherId,
                                             @Param("courseId") Long courseId,
                                             @Param("status") EnrollmentStatus status,
                                             @Param("search") String search,
                                             Pageable pageable);

    @Query("SELECT c.courseName, COUNT(e) FROM Enrollment e JOIN e.course c WHERE e.status = :status GROUP BY c.courseName ORDER BY COUNT(e) DESC")
    List<Object[]> countEnrollmentsPerCourseByStatus(@Param("status") EnrollmentStatus status);

    @Query("SELECT e.enrollmentDate, COUNT(e) FROM Enrollment e GROUP BY e.enrollmentDate ORDER BY e.enrollmentDate ASC")
    List<Object[]> countEnrollmentsPerDay();
}

