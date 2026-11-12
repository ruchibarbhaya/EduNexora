package com.cms.controller;

import com.cms.entity.Course;
import com.cms.entity.Enrollment;
import com.cms.entity.EnrollmentStatus;
import com.cms.entity.Student;
import com.cms.exception.DuplicateResourceException;
import com.cms.exception.ResourceNotFoundException;
import com.cms.security.CustomUserPrincipal;
import com.cms.service.CourseService;
import com.cms.service.EnrollmentService;
import com.cms.service.StudentService;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

@Controller
@RequestMapping("/student")
@PreAuthorize("hasRole('STUDENT')")
public class StudentController {

    private final CourseService courseService;
    private final EnrollmentService enrollmentService;
    private final StudentService studentService;

    public StudentController(CourseService courseService,
                             EnrollmentService enrollmentService,
                             StudentService studentService) {
        this.courseService = courseService;
        this.enrollmentService = enrollmentService;
        this.studentService = studentService;
    }

    // 1. DASHBOARD
    @GetMapping("/dashboard")
    public String dashboard(@AuthenticationPrincipal CustomUserPrincipal principal, Model model) {
        Long studentId = principal.getId();
        List<Enrollment> enrollments = enrollmentService.getStudentEnrollments(studentId);

        long activeCount = enrollments.stream().filter(e -> e.getStatus() == EnrollmentStatus.ACTIVE).count();
        long availableCourses = courseService.getAvailableCoursesForStudents(null, PageRequest.of(0, 1)).getTotalElements();

        model.addAttribute("myCoursesCount", activeCount);
        model.addAttribute("totalEnrollmentsCount", enrollments.size());
        model.addAttribute("availableCoursesCount", availableCourses);
        model.addAttribute("recentEnrollments", enrollments.stream().limit(5).toList());

        return "student/dashboard";
    }

    // 2. BROWSE COURSES (Cards with search & filter)
    @GetMapping("/courses")
    public String browseCourses(@RequestParam(value = "search", required = false) String search,
                                @RequestParam(value = "page", defaultValue = "0") int page,
                                @AuthenticationPrincipal CustomUserPrincipal principal,
                                Model model) {
        Pageable pageable = PageRequest.of(page, 9, Sort.by("courseName").ascending());
        Page<Course> coursePage = courseService.getAvailableCoursesForStudents(search, pageable);

        // Track courses that the student is already actively enrolled in
        List<Enrollment> studentEnrollments = enrollmentService.getStudentEnrollments(principal.getId());
        Set<Long> enrolledCourseIds = new HashSet<>();
        for (Enrollment e : studentEnrollments) {
            if (e.getStatus() == EnrollmentStatus.ACTIVE) {
                enrolledCourseIds.add(e.getCourse().getId());
            }
        }

        model.addAttribute("coursePage", coursePage);
        model.addAttribute("enrolledCourseIds", enrolledCourseIds);
        model.addAttribute("search", search);
        return "student/courses/list";
    }

    // 3. COURSE DETAIL
    @GetMapping("/courses/{id}")
    public String courseDetail(@PathVariable("id") Long id,
                               @AuthenticationPrincipal CustomUserPrincipal principal,
                               Model model) {
        Course course = courseService.getCourseById(id);
        if (course.getTeacher() == null) {
            throw new ResourceNotFoundException("This course is currently not available for students.");
        }

        List<Enrollment> studentEnrollments = enrollmentService.getStudentEnrollments(principal.getId());
        boolean isEnrolled = studentEnrollments.stream()
                .anyMatch(e -> e.getCourse().getId().equals(id) && e.getStatus() == EnrollmentStatus.ACTIVE);

        model.addAttribute("course", course);
        model.addAttribute("isEnrolled", isEnrolled);
        return "student/courses/detail";
    }

    // 4. CONFIRM ENROLLMENT SCREEN
    @GetMapping("/courses/{id}/enroll")
    public String confirmEnrollment(@PathVariable("id") Long id,
                                    @AuthenticationPrincipal CustomUserPrincipal principal,
                                    Model model,
                                    RedirectAttributes redirectAttributes) {
        Course course = courseService.getCourseById(id);
        if (course.getTeacher() == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "Course has no assigned instructor and is not open for enrollment.");
            return "redirect:/student/courses";
        }

        List<Enrollment> studentEnrollments = enrollmentService.getStudentEnrollments(principal.getId());
        boolean isEnrolled = studentEnrollments.stream()
                .anyMatch(e -> e.getCourse().getId().equals(id) && e.getStatus() == EnrollmentStatus.ACTIVE);

        if (isEnrolled) {
            redirectAttributes.addFlashAttribute("errorMessage", "You are already enrolled in this course");
            return "redirect:/student/courses/" + id;
        }

        model.addAttribute("course", course);
        return "student/courses/confirm";
    }

    // 5. POST ENROLLMENT ACTION
    @PostMapping("/enrollments")
    public String enrollInCourse(@RequestParam("courseId") Long courseId,
                                 @AuthenticationPrincipal CustomUserPrincipal principal,
                                 RedirectAttributes redirectAttributes) {
        Long studentId = principal.getId();
        try {
            Enrollment enrollment = enrollmentService.enrollStudent(studentId, courseId);
            redirectAttributes.addFlashAttribute("successMessage",
                    "Congratulations! You have successfully enrolled in " + enrollment.getCourse().getCourseName() + ".");
            return "redirect:/student/my-courses";
        } catch (DuplicateResourceException ex) {
            redirectAttributes.addFlashAttribute("errorMessage", ex.getMessage());
            return "redirect:/student/courses/" + courseId;
        } catch (IllegalStateException | ResourceNotFoundException ex) {
            redirectAttributes.addFlashAttribute("errorMessage", ex.getMessage());
            return "redirect:/student/courses";
        }
    }

    // 6. MY COURSES
    @GetMapping("/my-courses")
    public String myCourses(@AuthenticationPrincipal CustomUserPrincipal principal, Model model) {
        List<Enrollment> enrollments = enrollmentService.getStudentEnrollments(principal.getId());
        model.addAttribute("enrollments", enrollments);
        return "student/my-courses";
    }

    // 7. PROFILE & PASSWORD CHANGE
    @GetMapping("/profile")
    public String profilePage(@AuthenticationPrincipal CustomUserPrincipal principal, Model model) {
        Student student = studentService.findById(principal.getId());
        model.addAttribute("student", student);
        return "student/profile";
    }

    @PostMapping("/profile")
    public String updateProfile(@AuthenticationPrincipal CustomUserPrincipal principal,
                                @RequestParam("name") String name,
                                @RequestParam("phone") String phone,
                                @RequestParam(value = "newPassword", required = false) String newPassword,
                                @RequestParam(value = "confirmPassword", required = false) String confirmPassword,
                                RedirectAttributes redirectAttributes,
                                Model model) {
        if (name == null || name.trim().isEmpty()) {
            redirectAttributes.addFlashAttribute("errorMessage", "Name cannot be empty.");
            return "redirect:/student/profile";
        }

        if (newPassword != null && !newPassword.trim().isEmpty()) {
            if (!newPassword.equals(confirmPassword)) {
                redirectAttributes.addFlashAttribute("errorMessage", "New password and confirmation do not match.");
                return "redirect:/student/profile";
            }
            if (newPassword.trim().length() < 6) {
                redirectAttributes.addFlashAttribute("errorMessage", "New password must be at least 6 characters.");
                return "redirect:/student/profile";
            }
        }

        try {
            studentService.updateProfile(principal.getId(), name, phone, newPassword);
            redirectAttributes.addFlashAttribute("successMessage", "Profile information updated successfully.");
        } catch (Exception ex) {
            redirectAttributes.addFlashAttribute("errorMessage", "Error updating profile: " + ex.getMessage());
        }
        return "redirect:/student/profile";
    }
}
