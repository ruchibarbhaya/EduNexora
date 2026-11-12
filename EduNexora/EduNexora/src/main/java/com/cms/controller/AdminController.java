package com.cms.controller;

import com.cms.dto.CourseFormDto;
import com.cms.dto.TeacherFormDto;
import com.cms.entity.Course;
import com.cms.entity.Enrollment;
import com.cms.entity.EnrollmentStatus;
import com.cms.entity.Student;
import com.cms.entity.Teacher;
import com.cms.exception.DuplicateResourceException;
import com.cms.exception.ResourceNotFoundException;
import com.cms.repository.AdminRepository;
import com.cms.repository.CourseRepository;
import com.cms.repository.EnrollmentRepository;
import com.cms.repository.StudentRepository;
import com.cms.repository.TeacherRepository;
import com.cms.service.CourseService;
import com.cms.service.EnrollmentService;
import com.cms.service.TeacherService;
import jakarta.validation.Valid;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.ArrayList;
import java.util.List;

@Controller
@RequestMapping("/admin")
@PreAuthorize("hasRole('ADMIN')")
public class AdminController {

    private final StudentRepository studentRepository;
    private final TeacherRepository teacherRepository;
    private final CourseRepository courseRepository;
    private final EnrollmentRepository enrollmentRepository;
    private final TeacherService teacherService;
    private final CourseService courseService;
    private final EnrollmentService enrollmentService;

    public AdminController(StudentRepository studentRepository,
                           TeacherRepository teacherRepository,
                           CourseRepository courseRepository,
                           EnrollmentRepository enrollmentRepository,
                           TeacherService teacherService,
                           CourseService courseService,
                           EnrollmentService enrollmentService) {
        this.studentRepository = studentRepository;
        this.teacherRepository = teacherRepository;
        this.courseRepository = courseRepository;
        this.enrollmentRepository = enrollmentRepository;
        this.teacherService = teacherService;
        this.courseService = courseService;
        this.enrollmentService = enrollmentService;
    }

    // 1. DASHBOARD
    @GetMapping("/dashboard")
    public String dashboard(Model model) {
        model.addAttribute("totalStudents", studentRepository.count());
        model.addAttribute("totalTeachers", teacherRepository.count());
        model.addAttribute("totalCourses", courseRepository.count());
        model.addAttribute("totalEnrollments", enrollmentRepository.count());

        List<Object[]> popularityData = enrollmentService.getCoursePopularityData();
        List<String> courseLabels = new ArrayList<>();
        List<Long> courseCounts = new ArrayList<>();
        for (Object[] row : popularityData) {
            courseLabels.add("\"" + row[0].toString().replace("\"", "\\\"") + "\"");
            courseCounts.add(((Number) row[1]).longValue());
        }

        List<Object[]> trendData = enrollmentService.getDailyEnrollmentTrends();
        List<String> trendLabels = new ArrayList<>();
        List<Long> trendCounts = new ArrayList<>();
        for (Object[] row : trendData) {
            trendLabels.add("\"" + row[0].toString() + "\"");
            trendCounts.add(((Number) row[1]).longValue());
        }

        model.addAttribute("chartCourseLabels", "[" + String.join(",", courseLabels) + "]");
        model.addAttribute("chartCourseData", courseCounts.toString());
        model.addAttribute("chartTrendLabels", "[" + String.join(",", trendLabels) + "]");
        model.addAttribute("chartTrendData", trendCounts.toString());

        return "admin/dashboard";
    }

    // 2. TEACHERS
    @GetMapping("/teachers")
    public String listTeachers(@RequestParam(value = "search", required = false) String search,
                               @RequestParam(value = "page", defaultValue = "0") int page,
                               Model model) {
        Pageable pageable = PageRequest.of(page, 10, Sort.by("name").ascending());
        Page<Teacher> teacherPage = teacherService.getTeachers(search, pageable);

        model.addAttribute("teacherPage", teacherPage);
        model.addAttribute("search", search);
        return "admin/teachers/list";
    }

    @GetMapping("/teachers/new")
    public String newTeacherForm(Model model) {
        if (!model.containsAttribute("teacherForm")) {
            model.addAttribute("teacherForm", new TeacherFormDto());
        }
        return "admin/teachers/form";
    }

    @PostMapping("/teachers/new")
    public String createTeacher(@Valid @ModelAttribute("teacherForm") TeacherFormDto form,
                                BindingResult bindingResult,
                                RedirectAttributes redirectAttributes) {
        if (bindingResult.hasErrors()) {
            return "admin/teachers/form";
        }
        try {
            teacherService.createTeacher(form);
            redirectAttributes.addFlashAttribute("successMessage", "Teacher '" + form.getName() + "' created successfully.");
            return "redirect:/admin/teachers";
        } catch (DuplicateResourceException ex) {
            bindingResult.rejectValue("email", "error.teacherForm", ex.getMessage());
            return "admin/teachers/form";
        }
    }

    @GetMapping("/teachers/{id}/edit")
    public String editTeacherForm(@PathVariable("id") Long id, Model model) {
        Teacher teacher = teacherService.getTeacherById(id);
        TeacherFormDto form = new TeacherFormDto();
        form.setId(teacher.getId());
        form.setName(teacher.getName());
        form.setEmail(teacher.getEmail());
        form.setPhone(teacher.getPhone());
        form.setDepartment(teacher.getDepartment());

        model.addAttribute("teacherForm", form);
        return "admin/teachers/form";
    }

    @PostMapping("/teachers/{id}/edit")
    public String updateTeacher(@PathVariable("id") Long id,
                                @Valid @ModelAttribute("teacherForm") TeacherFormDto form,
                                BindingResult bindingResult,
                                RedirectAttributes redirectAttributes) {
        if (bindingResult.hasErrors()) {
            return "admin/teachers/form";
        }
        try {
            teacherService.updateTeacher(id, form);
            redirectAttributes.addFlashAttribute("successMessage", "Teacher updated successfully.");
            return "redirect:/admin/teachers";
        } catch (DuplicateResourceException ex) {
            bindingResult.rejectValue("email", "error.teacherForm", ex.getMessage());
            return "admin/teachers/form";
        }
    }

    @PostMapping("/teachers/{id}/delete")
    public String deleteTeacher(@PathVariable("id") Long id, RedirectAttributes redirectAttributes) {
        try {
            teacherService.deleteTeacher(id);
            redirectAttributes.addFlashAttribute("successMessage", "Teacher deleted successfully.");
        } catch (IllegalStateException | ResourceNotFoundException ex) {
            redirectAttributes.addFlashAttribute("errorMessage", ex.getMessage());
        }
        return "redirect:/admin/teachers";
    }

    // 3. COURSES
    @GetMapping("/courses")
    public String listCourses(@RequestParam(value = "search", required = false) String search,
                              @RequestParam(value = "teacherId", required = false) Long teacherId,
                              @RequestParam(value = "page", defaultValue = "0") int page,
                              Model model) {
        Pageable pageable = PageRequest.of(page, 10, Sort.by("id").descending());
        Page<Course> coursePage = courseService.getCourses(search, teacherId, pageable);

        model.addAttribute("coursePage", coursePage);
        model.addAttribute("teachers", teacherService.getAllTeachers());
        model.addAttribute("search", search);
        model.addAttribute("selectedTeacherId", teacherId);
        return "admin/courses/list";
    }

    @GetMapping("/courses/new")
    public String newCourseForm(Model model) {
        if (!model.containsAttribute("courseForm")) {
            model.addAttribute("courseForm", new CourseFormDto());
        }
        model.addAttribute("teachers", teacherService.getAllTeachers());
        return "admin/courses/form";
    }

    @PostMapping("/courses/new")
    public String createCourse(@Valid @ModelAttribute("courseForm") CourseFormDto form,
                               BindingResult bindingResult,
                               RedirectAttributes redirectAttributes,
                               Model model) {
        if (bindingResult.hasErrors()) {
            model.addAttribute("teachers", teacherService.getAllTeachers());
            return "admin/courses/form";
        }
        try {
            courseService.createCourse(form);
            redirectAttributes.addFlashAttribute("successMessage", "Course '" + form.getCourseName() + "' created successfully.");
            return "redirect:/admin/courses";
        } catch (DuplicateResourceException ex) {
            bindingResult.rejectValue("courseCode", "error.courseForm", ex.getMessage());
            model.addAttribute("teachers", teacherService.getAllTeachers());
            return "admin/courses/form";
        }
    }

    @GetMapping("/courses/{id}/edit")
    public String editCourseForm(@PathVariable("id") Long id, Model model) {
        Course course = courseService.getCourseById(id);
        CourseFormDto form = new CourseFormDto();
        form.setId(course.getId());
        form.setCourseName(course.getCourseName());
        form.setCourseCode(course.getCourseCode());
        form.setDescription(course.getDescription());
        form.setDuration(course.getDuration());
        form.setFees(course.getFees());
        form.setTeacherId(course.getTeacher() != null ? course.getTeacher().getId() : null);

        model.addAttribute("courseForm", form);
        model.addAttribute("teachers", teacherService.getAllTeachers());
        return "admin/courses/form";
    }

    @PostMapping("/courses/{id}/edit")
    public String updateCourse(@PathVariable("id") Long id,
                               @Valid @ModelAttribute("courseForm") CourseFormDto form,
                               BindingResult bindingResult,
                               RedirectAttributes redirectAttributes,
                               Model model) {
        if (bindingResult.hasErrors()) {
            model.addAttribute("teachers", teacherService.getAllTeachers());
            return "admin/courses/form";
        }
        try {
            courseService.updateCourse(id, form);
            redirectAttributes.addFlashAttribute("successMessage", "Course updated successfully.");
            return "redirect:/admin/courses";
        } catch (DuplicateResourceException ex) {
            bindingResult.rejectValue("courseCode", "error.courseForm", ex.getMessage());
            model.addAttribute("teachers", teacherService.getAllTeachers());
            return "admin/courses/form";
        }
    }

    @PostMapping("/courses/{id}/delete")
    public String deleteCourse(@PathVariable("id") Long id, RedirectAttributes redirectAttributes) {
        try {
            courseService.deleteCourse(id);
            redirectAttributes.addFlashAttribute("successMessage", "Course deleted successfully.");
        } catch (IllegalStateException | ResourceNotFoundException ex) {
            redirectAttributes.addFlashAttribute("errorMessage", ex.getMessage());
        }
        return "redirect:/admin/courses";
    }

    @GetMapping("/courses/{id}/students")
    public String viewCourseStudents(@PathVariable("id") Long id, Model model) {
        Course course = courseService.getCourseById(id);
        List<Enrollment> enrollments = enrollmentService.getCourseEnrollments(id);
        model.addAttribute("course", course);
        model.addAttribute("enrollments", enrollments);
        return "admin/courses/students";
    }

    // 4. STUDENTS
    @GetMapping("/students")
    public String listStudents(@RequestParam(value = "search", required = false) String search,
                               @RequestParam(value = "page", defaultValue = "0") int page,
                               Model model) {
        Pageable pageable = PageRequest.of(page, 10, Sort.by("name").ascending());
        String query = (search != null && !search.trim().isEmpty()) ? search.trim() : null;
        Page<Student> studentPage = studentRepository.searchStudents(query, pageable);

        model.addAttribute("studentPage", studentPage);
        model.addAttribute("search", search);
        return "admin/students/list";
    }

    @GetMapping("/students/{id}")
    public String viewStudent(@PathVariable("id") Long id, Model model) {
        Student student = studentRepository.findByIdWithEnrollments(id)
                .orElseThrow(() -> new ResourceNotFoundException("Student not found with ID: " + id));
        model.addAttribute("student", student);
        return "admin/students/detail";
    }

    // 5. ENROLLMENTS
    @GetMapping("/enrollments")
    public String listEnrollments(@RequestParam(value = "courseId", required = false) Long courseId,
                                  @RequestParam(value = "status", required = false) EnrollmentStatus status,
                                  @RequestParam(value = "search", required = false) String search,
                                  @RequestParam(value = "page", defaultValue = "0") int page,
                                  Model model) {
        Pageable pageable = PageRequest.of(page, 10, Sort.by("id").descending());
        Page<Enrollment> enrollmentPage = enrollmentService.searchEnrollments(courseId, status, search, pageable);

        model.addAttribute("enrollmentPage", enrollmentPage);
        model.addAttribute("courses", courseService.getAllCoursesWithTeacher());
        model.addAttribute("selectedCourseId", courseId);
        model.addAttribute("selectedStatus", status);
        model.addAttribute("search", search);
        return "admin/enrollments/list";
    }

    @GetMapping("/enrollments/{id}")
    public String viewEnrollment(@PathVariable("id") Long id, Model model) {
        Enrollment enrollment = enrollmentService.getEnrollmentById(id);
        model.addAttribute("enrollment", enrollment);
        return "admin/enrollments/detail";
    }

    @PostMapping("/enrollments/{id}/cancel")
    public String cancelEnrollment(@PathVariable("id") Long id, RedirectAttributes redirectAttributes) {
        try {
            enrollmentService.cancelEnrollment(id);
            redirectAttributes.addFlashAttribute("successMessage", "Enrollment #" + id + " has been cancelled.");
        } catch (ResourceNotFoundException ex) {
            redirectAttributes.addFlashAttribute("errorMessage", ex.getMessage());
        }
        return "redirect:/admin/enrollments";
    }
}
