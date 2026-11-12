package com.cms.security;

import com.cms.entity.Course;
import com.cms.entity.Teacher;
import com.cms.repository.CourseRepository;
import com.cms.repository.TeacherRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.security.test.context.support.WithMockUser;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;

import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.csrf;
import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.user;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.redirectedUrl;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest
@AutoConfigureMockMvc
@Transactional
public class SecurityAndRoleIsolationTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private TeacherRepository teacherRepository;

    @Autowired
    private CourseRepository courseRepository;

    private Teacher teacherA;
    private Teacher teacherB;
    private Course courseA;
    private Course courseB;

    @BeforeEach
    void setup() {
        teacherA = teacherRepository.save(new Teacher("Teacher A", "teachera@test.com", "9811111111", "CS", "$2a$10$CG02VXxG7oyIdIYkJdBItuWhKR31i3nMcqfwlJSXhtzOgDKxDMGFa"));
        teacherB = teacherRepository.save(new Teacher("Teacher B", "teacherb@test.com", "9822222222", "EE", "$2a$10$CG02VXxG7oyIdIYkJdBItuWhKR31i3nMcqfwlJSXhtzOgDKxDMGFa"));

        courseA = courseRepository.save(new Course("Course A", "CS901", "Desc A", "6 Weeks", new BigDecimal("150.00"), teacherA));
        courseB = courseRepository.save(new Course("Course B", "EE902", "Desc B", "8 Weeks", new BigDecimal("200.00"), teacherB));
    }

    // 1. URL Protection & Role Isolation
    @Test
    @WithMockUser(username = "admin", roles = {"ADMIN"})
    void adminCanAccessAdminUrlsButNotTeacherOrStudent() throws Exception {
        mockMvc.perform(get("/admin/dashboard")).andExpect(status().isOk());
        mockMvc.perform(get("/admin/teachers")).andExpect(status().isOk());
        mockMvc.perform(get("/admin/courses")).andExpect(status().isOk());

        mockMvc.perform(get("/teacher/dashboard")).andExpect(status().isForbidden());
        mockMvc.perform(get("/student/dashboard")).andExpect(status().isForbidden());
    }

    @Test
    void teacherCanAccessTeacherUrlsButNotAdminOrStudent() throws Exception {
        CustomUserPrincipal teacherPrincipal = new CustomUserPrincipal(
                teacherA.getId(), teacherA.getEmail(), teacherA.getPassword(), "TEACHER", teacherA.getName());

        mockMvc.perform(get("/teacher/dashboard").with(user(teacherPrincipal)))
                .andExpect(status().isOk());
        mockMvc.perform(get("/teacher/courses").with(user(teacherPrincipal)))
                .andExpect(status().isOk());

        mockMvc.perform(get("/admin/dashboard").with(user(teacherPrincipal)))
                .andExpect(status().isForbidden());
        mockMvc.perform(get("/student/dashboard").with(user(teacherPrincipal)))
                .andExpect(status().isForbidden());
    }

    @Test
    void studentCanAccessStudentUrlsButNotAdminOrTeacher() throws Exception {
        CustomUserPrincipal studentPrincipal = new CustomUserPrincipal(
                1L, "alice.smith@student.com", "dummy", "STUDENT", "Alice Smith");

        mockMvc.perform(get("/student/dashboard").with(user(studentPrincipal)))
                .andExpect(status().isOk());
        mockMvc.perform(get("/student/courses").with(user(studentPrincipal)))
                .andExpect(status().isOk());

        mockMvc.perform(get("/admin/dashboard").with(user(studentPrincipal)))
                .andExpect(status().isForbidden());
        mockMvc.perform(get("/teacher/dashboard").with(user(studentPrincipal)))
                .andExpect(status().isForbidden());
    }

    // 2. CSRF Token Enforcement
    @Test
    @WithMockUser(username = "admin", roles = {"ADMIN"})
    void postWithoutCsrfTokenIsRejected() throws Exception {
        // Missing CSRF token
        mockMvc.perform(post("/admin/teachers/new")
                .param("name", "Illegal Teacher")
                .param("email", "illegal@test.com")
                .param("department", "Test")
                .param("phone", "9876543210"))
                .andExpect(status().isForbidden());
    }

    // 3. Teacher Isolation Test
    @Test
    void teacherCannotAccessAnotherTeachersCourse() throws Exception {
        // Teacher A principal attempting to access Teacher B's course
        CustomUserPrincipal teacherAPrincipal = new CustomUserPrincipal(
                teacherA.getId(), teacherA.getEmail(), teacherA.getPassword(), "TEACHER", teacherA.getName());

        mockMvc.perform(get("/teacher/courses/" + courseB.getId()).with(user(teacherAPrincipal)))
                .andExpect(status().isForbidden());

        // Teacher A accessing their own course
        mockMvc.perform(get("/teacher/courses/" + courseA.getId()).with(user(teacherAPrincipal)))
                .andExpect(status().isOk());
    }
}

