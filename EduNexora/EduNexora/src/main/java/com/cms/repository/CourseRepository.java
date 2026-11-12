package com.cms.repository;

import com.cms.entity.Course;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface CourseRepository extends JpaRepository<Course, Long> {
    Optional<Course> findByCourseCode(String courseCode);
    boolean existsByCourseCode(String courseCode);
    boolean existsByCourseCodeAndIdNot(String courseCode, Long id);

    List<Course> findByTeacherId(Long teacherId);
    List<Course> findByTeacherIsNotNull();
    long countByTeacherId(Long teacherId);

    @Query("SELECT c FROM Course c LEFT JOIN FETCH c.teacher WHERE c.id = :id")
    Optional<Course> findByIdWithTeacher(@Param("id") Long id);

    @Query("SELECT c FROM Course c LEFT JOIN FETCH c.teacher ORDER BY c.id DESC")
    List<Course> findAllWithTeacher();

    @Query("SELECT c FROM Course c LEFT JOIN FETCH c.teacher WHERE (:teacherId IS NULL OR c.teacher.id = :teacherId) AND (:search IS NULL OR LOWER(c.courseName) LIKE LOWER(CONCAT('%', :search, '%')) OR LOWER(c.courseCode) LIKE LOWER(CONCAT('%', :search, '%')))")
    Page<Course> searchCourses(@Param("search") String search, @Param("teacherId") Long teacherId, Pageable pageable);

    @Query("SELECT c FROM Course c LEFT JOIN FETCH c.teacher WHERE c.teacher IS NOT NULL AND (:search IS NULL OR LOWER(c.courseName) LIKE LOWER(CONCAT('%', :search, '%')) OR LOWER(c.courseCode) LIKE LOWER(CONCAT('%', :search, '%')))")
    Page<Course> searchAvailableCoursesForStudents(@Param("search") String search, Pageable pageable);

    @Query("SELECT c FROM Course c LEFT JOIN FETCH c.teacher WHERE c.teacher.id = :teacherId")
    List<Course> findByTeacherIdWithTeacher(@Param("teacherId") Long teacherId);
}

