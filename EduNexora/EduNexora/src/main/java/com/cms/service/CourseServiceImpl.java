package com.cms.service;

import com.cms.dto.CourseFormDto;
import com.cms.entity.Course;
import com.cms.entity.Teacher;
import com.cms.exception.DuplicateResourceException;
import com.cms.exception.ResourceNotFoundException;
import com.cms.repository.CourseRepository;
import com.cms.repository.EnrollmentRepository;
import com.cms.repository.TeacherRepository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class CourseServiceImpl implements CourseService {

    private final CourseRepository courseRepository;
    private final TeacherRepository teacherRepository;
    private final EnrollmentRepository enrollmentRepository;

    public CourseServiceImpl(CourseRepository courseRepository,
                             TeacherRepository teacherRepository,
                             EnrollmentRepository enrollmentRepository) {
        this.courseRepository = courseRepository;
        this.teacherRepository = teacherRepository;
        this.enrollmentRepository = enrollmentRepository;
    }

    @Override
    @Transactional(readOnly = true)
    public Page<Course> getCourses(String search, Long teacherId, Pageable pageable) {
        String query = (search != null && !search.trim().isEmpty()) ? search.trim() : null;
        return courseRepository.searchCourses(query, teacherId, pageable);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Course> getAllCoursesWithTeacher() {
        return courseRepository.findAllWithTeacher();
    }

    @Override
    @Transactional(readOnly = true)
    public Course getCourseById(Long id) {
        return courseRepository.findByIdWithTeacher(id)
                .orElseThrow(() -> new ResourceNotFoundException("Course not found with ID: " + id));
    }

    @Override
    @Transactional
    public Course createCourse(CourseFormDto dto) {
        if (courseRepository.existsByCourseCode(dto.getCourseCode().trim())) {
            throw new DuplicateResourceException("A course with code '" + dto.getCourseCode() + "' already exists.");
        }

        Teacher teacher = null;
        if (dto.getTeacherId() != null) {
            teacher = teacherRepository.findById(dto.getTeacherId())
                    .orElseThrow(() -> new ResourceNotFoundException("Teacher not found with ID: " + dto.getTeacherId()));
        }

        Course course = new Course(
                dto.getCourseName().trim(),
                dto.getCourseCode().trim().toUpperCase(),
                dto.getDescription() != null ? dto.getDescription().trim() : null,
                dto.getDuration().trim(),
                dto.getFees(),
                teacher
        );

        return courseRepository.save(course);
    }

    @Override
    @Transactional
    public Course updateCourse(Long id, CourseFormDto dto) {
        Course course = getCourseById(id);

        if (courseRepository.existsByCourseCodeAndIdNot(dto.getCourseCode().trim(), id)) {
            throw new DuplicateResourceException("A course with code '" + dto.getCourseCode() + "' already exists.");
        }

        Teacher teacher = null;
        if (dto.getTeacherId() != null) {
            teacher = teacherRepository.findById(dto.getTeacherId())
                    .orElseThrow(() -> new ResourceNotFoundException("Teacher not found with ID: " + dto.getTeacherId()));
        }

        course.setCourseName(dto.getCourseName().trim());
        course.setCourseCode(dto.getCourseCode().trim().toUpperCase());
        course.setDescription(dto.getDescription() != null ? dto.getDescription().trim() : null);
        course.setDuration(dto.getDuration().trim());
        course.setFees(dto.getFees());
        course.setTeacher(teacher);

        return courseRepository.save(course);
    }

    @Override
    @Transactional
    public void deleteCourse(Long id) {
        Course course = getCourseById(id);
        long enrollmentCount = enrollmentRepository.countByCourseId(id);
        if (enrollmentCount > 0) {
            throw new IllegalStateException("Cannot delete course '" + course.getCourseName() + "' because it has " +
                    enrollmentCount + " existing enrollment(s).");
        }
        courseRepository.delete(course);
    }

    @Override
    @Transactional
    public void assignTeacher(Long courseId, Long teacherId) {
        Course course = getCourseById(courseId);
        Teacher teacher = null;
        if (teacherId != null) {
            teacher = teacherRepository.findById(teacherId)
                    .orElseThrow(() -> new ResourceNotFoundException("Teacher not found with ID: " + teacherId));
        }
        course.setTeacher(teacher);
        courseRepository.save(course);
    }

    @Override
    @Transactional(readOnly = true)
    public Page<Course> getAvailableCoursesForStudents(String search, Pageable pageable) {
        String query = (search != null && !search.trim().isEmpty()) ? search.trim() : null;
        return courseRepository.searchAvailableCoursesForStudents(query, pageable);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Course> getCoursesByTeacher(Long teacherId) {
        return courseRepository.findByTeacherIdWithTeacher(teacherId);
    }
}

