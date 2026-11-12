package com.cms.service;

import com.cms.dto.CourseFormDto;
import com.cms.entity.Course;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.util.List;

public interface CourseService {
    Page<Course> getCourses(String search, Long teacherId, Pageable pageable);
    List<Course> getAllCoursesWithTeacher();
    Course getCourseById(Long id);
    Course createCourse(CourseFormDto dto);
    Course updateCourse(Long id, CourseFormDto dto);
    void deleteCourse(Long id);
    void assignTeacher(Long courseId, Long teacherId);
    Page<Course> getAvailableCoursesForStudents(String search, Pageable pageable);
    List<Course> getCoursesByTeacher(Long teacherId);
}

