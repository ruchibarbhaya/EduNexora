package com.cms.controller;

import com.cms.entity.Course;
import com.cms.entity.Enrollment;
import com.cms.entity.EnrollmentStatus;
import com.cms.exception.ResourceNotFoundException;
import com.cms.security.CustomUserPrincipal;
import com.cms.service.CourseService;
import com.cms.service.EnrollmentService;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/teacher")
@PreAuthorize("hasRole('TEACHER')")
public class TeacherController {

    private final CourseService courseService;
    private final EnrollmentService enrollmentService;

    public TeacherController(CourseService courseService,
                             EnrollmentService enrollmentService) {
        this.courseService = courseService;
        this.enrollmentService = enrollmentService;
    }

    // 1. DASHBOARD
    @GetMapping("/dashboard")
    public String dashboard(@AuthenticationPrincipal CustomUserPrincipal principal, Model model) {
        Long teacherId = principal.getId();
        List<Course> courses = courseService.getCoursesByTeacher(teacherId);
        List<Enrollment> enrollments = enrollmentService.getTeacherEnrollments(teacherId);

        long activeStudents = enrollments.stream()
                .filter(e -> e.getStatus() == EnrollmentStatus.ACTIVE)
                .count();

        model.addAttribute("assignedCoursesCount", courses.size());
        model.addAttribute("totalEnrolledStudents", activeStudents);
        model.addAttribute("recentEnrollments", enrollments.stream().limit(5).toList());

        return "teacher/dashboard";
    }

    // 2. MY COURSES
    @GetMapping("/courses")
    public String myCourses(@AuthenticationPrincipal CustomUserPrincipal principal, Model model) {
        Long teacherId = principal.getId();
        List<Course> courses = courseService.getCoursesByTeacher(teacherId);
        List<Enrollment> allEnrollments = enrollmentService.getTeacherEnrollments(teacherId);

        Map<Long, Long> enrolledCounts = new HashMap<>();
        for (Course c : courses) {
            long count = allEnrollments.stream()
                    .filter(e -> e.getCourse().getId().equals(c.getId()) && e.getStatus() == EnrollmentStatus.ACTIVE)
                    .count();
            enrolledCounts.put(c.getId(), count);
        }

        model.addAttribute("courses", courses);
        model.addAttribute("enrolledCounts", enrolledCounts);
        return "teacher/courses/list";
    }

    // 3. COURSE DETAIL WITH REGISTERED STUDENTS
    @GetMapping("/courses/{id}")
    public String courseDetail(@PathVariable("id") Long id,
                               @AuthenticationPrincipal CustomUserPrincipal principal,
                               Model model) {
        Course course = courseService.getCourseById(id);

        // Security check: teacher isolation
        if (course.getTeacher() == null || !course.getTeacher().getId().equals(principal.getId())) {
            throw new AccessDeniedException("You do not have permission to view courses assigned to other instructors.");
        }

        List<Enrollment> enrollments = enrollmentService.getCourseEnrollments(id);
        model.addAttribute("course", course);
        model.addAttribute("enrollments", enrollments);
        return "teacher/courses/detail";
    }

    // 4. REGISTERED STUDENTS DIRECTORY
    @GetMapping("/students")
    public String registeredStudents(@RequestParam(value = "courseId", required = false) Long courseId,
                                     @RequestParam(value = "status", required = false) EnrollmentStatus status,
                                     @RequestParam(value = "search", required = false) String search,
                                     @RequestParam(value = "page", defaultValue = "0") int page,
                                     @AuthenticationPrincipal CustomUserPrincipal principal,
                                     Model model) {
        Long teacherId = principal.getId();
        Pageable pageable = PageRequest.of(page, 10, Sort.by("id").descending());

        Page<Enrollment> enrollmentPage = enrollmentService.searchTeacherEnrollments(
                teacherId, courseId, status, search, pageable);

        List<Course> myCourses = courseService.getCoursesByTeacher(teacherId);

        model.addAttribute("enrollmentPage", enrollmentPage);
        model.addAttribute("courses", myCourses);
        model.addAttribute("selectedCourseId", courseId);
        model.addAttribute("selectedStatus", status);
        model.addAttribute("search", search);

        return "teacher/students/list";
    }
}
