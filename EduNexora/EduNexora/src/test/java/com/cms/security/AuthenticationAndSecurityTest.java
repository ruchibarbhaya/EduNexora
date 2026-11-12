package com.cms.security;

import com.cms.entity.Student;
import com.cms.repository.AdminRepository;
import com.cms.repository.StudentRepository;
import com.cms.repository.TeacherRepository;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.security.test.context.support.WithMockUser;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.transaction.annotation.Transactional;

import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.csrf;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@SpringBootTest
@AutoConfigureMockMvc
@Transactional
public class AuthenticationAndSecurityTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private StudentRepository studentRepository;

    @Autowired
    private AdminRepository adminRepository;

    @Autowired
    private TeacherRepository teacherRepository;

    @Test
    void unauthenticatedAccessRedirectsToLogin() throws Exception {
        mockMvc.perform(get("/admin/dashboard"))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrlPattern("**/auth/login.jsp*"));

        mockMvc.perform(get("/student/dashboard"))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrlPattern("**/auth/login.jsp*"));
    }

    @Test
    void studentRegistrationSuccessAndBCryptPassword() throws Exception {
        mockMvc.perform(post("/register")
                .with(csrf())
                .param("fullName", "New Student")
                .param("email", "newstudent@test.com")
                .param("phone", "9876543210")
                .param("password", "Test@12345")
                .param("confirmPassword", "Test@12345"))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/auth/login.jsp?registered=true"));

        Student student = studentRepository.findByEmail("newstudent@test.com").orElse(null);
        org.junit.jupiter.api.Assertions.assertNotNull(student);
        assertTrue(student.getPassword().startsWith("$2a$") || student.getPassword().startsWith("$2b$"),
                "Password must be stored as BCrypt hash");
    }

    @Test
    void duplicateEmailRegistrationFails() throws Exception {
        mockMvc.perform(post("/register")
                .with(csrf())
                .param("fullName", "Duplicate Student")
                .param("email", "alice.smith@student.com") // Already in sample data
                .param("phone", "9876543210")
                .param("password", "Test@12345")
                .param("confirmPassword", "Test@12345"))
                .andExpect(status().isOk())
                .andExpect(view().name("forward:/auth/register.jsp"))
                .andExpect(model().hasErrors());
    }

    @Test
    void loginWithWrongRoleFails() throws Exception {
        // Alice Smith is a STUDENT, attempting to log in as ADMIN
        mockMvc.perform(post("/login")
                .with(csrf())
                .param("role", "ADMIN")
                .param("username", "alice.smith@student.com")
                .param("password", "Password@123"))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/auth/login.jsp?error=true"));
    }

    @Test
    void loginWithInvalidPasswordFails() throws Exception {
        mockMvc.perform(post("/login")
                .with(csrf())
                .param("role", "STUDENT")
                .param("username", "alice.smith@student.com")
                .param("password", "WrongPassword!"))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/auth/login.jsp?error=true"));
    }

    @Test
    void studentLoginSuccessRedirectsToStudentDashboard() throws Exception {
        mockMvc.perform(post("/login")
                .with(csrf())
                .param("role", "STUDENT")
                .param("username", "alice.smith@student.com")
                .param("password", "Password@123"))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/student/dashboard"));
    }

    @Test
    void adminLoginSuccessRedirectsToAdminDashboard() throws Exception {
        mockMvc.perform(post("/login")
                .with(csrf())
                .param("role", "ADMIN")
                .param("username", "admin")
                .param("password", "Admin@123"))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/admin/dashboard"));
    }

    @Test
    @WithMockUser(username = "STUDENT:alice.smith@student.com", roles = {"STUDENT"})
    void studentAccessingAdminDashboardReturns403() throws Exception {
        mockMvc.perform(get("/admin/dashboard"))
                .andExpect(status().isForbidden());
    }

    @Test
    void verifyAllDatabasePasswordsAreBCrypt() {
        adminRepository.findAll().forEach(admin -> {
            assertTrue(admin.getPassword().startsWith("$2a$") || admin.getPassword().startsWith("$2b$"),
                    "Admin password must be BCrypt hash");
        });

        teacherRepository.findAll().forEach(teacher -> {
            assertTrue(teacher.getPassword().startsWith("$2a$") || teacher.getPassword().startsWith("$2b$"),
                    "Teacher password must be BCrypt hash");
        });

        studentRepository.findAll().forEach(student -> {
            assertTrue(student.getPassword().startsWith("$2a$") || student.getPassword().startsWith("$2b$"),
                    "Student password must be BCrypt hash");
        });
    }
}

