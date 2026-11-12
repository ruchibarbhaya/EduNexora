package com.cms.controller;

import com.cms.dto.StudentRegistrationDto;
import com.cms.exception.DuplicateResourceException;
import com.cms.service.StudentService;
import jakarta.validation.Valid;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
public class AuthController {

    private final StudentService studentService;

    public AuthController(StudentService studentService) {
        this.studentService = studentService;
    }

    @GetMapping("/")
    public String index(Authentication authentication) {
        if (authentication != null && authentication.isAuthenticated() && !authentication.getName().equals("anonymousUser")) {
            for (GrantedAuthority authority : authentication.getAuthorities()) {
                String role = authority.getAuthority();
                if ("ROLE_ADMIN".equals(role)) return "redirect:/admin/dashboard";
                if ("ROLE_TEACHER".equals(role)) return "redirect:/teacher/dashboard";
                if ("ROLE_STUDENT".equals(role)) return "redirect:/student/dashboard";
            }
        }
        return "redirect:/auth/login.jsp";
    }

    @GetMapping("/login")
    public String loginPage(Authentication authentication,
                            @RequestParam(value = "error", required = false) String error,
                            @RequestParam(value = "logout", required = false) String logout,
                            @RequestParam(value = "registered", required = false) String registered,
                            Model model) {
        if (authentication != null && authentication.isAuthenticated() && !authentication.getName().equals("anonymousUser")) {
            return index(authentication);
        }

        if (error != null) {
            model.addAttribute("errorMessage", "Invalid credentials or incorrect role selected. Please check and try again.");
        }
        if (logout != null) {
            model.addAttribute("successMessage", "You have been logged out successfully.");
        }
        if (registered != null) {
            model.addAttribute("successMessage", "Registration successful! You can now log in with your credentials.");
        }

        return "forward:/auth/login.jsp";
    }

    @GetMapping("/register")
    public String registerPage(Authentication authentication, Model model) {
        if (authentication != null && authentication.isAuthenticated() && !authentication.getName().equals("anonymousUser")) {
            return index(authentication);
        }

        if (!model.containsAttribute("registrationDto")) {
            model.addAttribute("registrationDto", new StudentRegistrationDto());
        }
        return "forward:/auth/register.jsp";
    }

    @PostMapping("/register")
    public String handleRegistration(@Valid @ModelAttribute("registrationDto") StudentRegistrationDto dto,
                                     BindingResult bindingResult,
                                     RedirectAttributes redirectAttributes,
                                     Model model) {
        if (dto.getPassword() != null && !dto.getPassword().equals(dto.getConfirmPassword())) {
            bindingResult.rejectValue("confirmPassword", "error.registrationDto", "Passwords do not match.");
        }

        if (dto.getEmail() != null && studentService.emailExists(dto.getEmail())) {
            bindingResult.rejectValue("email", "error.registrationDto", "An account with this email already exists.");
        }

        if (bindingResult.hasErrors()) {
            return "forward:/auth/register.jsp";
        }

        try {
            studentService.registerStudent(dto);
            redirectAttributes.addFlashAttribute("successMessage", "Registration successful! Please log in.");
            return "redirect:/auth/login.jsp?registered=true";
        } catch (DuplicateResourceException e) {
            bindingResult.rejectValue("email", "error.registrationDto", e.getMessage());
            return "forward:/auth/register.jsp";
        }
    }

    @GetMapping("/access-denied")
    public String accessDenied() {
        return "error/403";
    }
}

