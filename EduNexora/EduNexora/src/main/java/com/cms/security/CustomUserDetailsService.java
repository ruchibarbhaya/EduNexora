package com.cms.security;

import com.cms.entity.Admin;
import com.cms.entity.Student;
import com.cms.entity.Teacher;
import com.cms.repository.AdminRepository;
import com.cms.repository.StudentRepository;
import com.cms.repository.TeacherRepository;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class CustomUserDetailsService implements UserDetailsService {

    private final AdminRepository adminRepository;
    private final TeacherRepository teacherRepository;
    private final StudentRepository studentRepository;

    public CustomUserDetailsService(AdminRepository adminRepository,
                                    TeacherRepository teacherRepository,
                                    StudentRepository studentRepository) {
        this.adminRepository = adminRepository;
        this.teacherRepository = teacherRepository;
        this.studentRepository = studentRepository;
    }

    @Override
    @Transactional(readOnly = true)
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        if (username == null || username.trim().isEmpty()) {
            throw new UsernameNotFoundException("Username cannot be empty");
        }

        String role = null;
        String identifier = username.trim();

        int colonIndex = identifier.indexOf(':');
        if (colonIndex > 0) {
            role = identifier.substring(0, colonIndex).toUpperCase();
            identifier = identifier.substring(colonIndex + 1).trim();
        }

        if (role != null) {
            return loadUserByRoleAndIdentifier(role, identifier);
        }

        // Sequential fallback if no role prefix
        try {
            return loadUserByRoleAndIdentifier("ADMIN", identifier);
        } catch (UsernameNotFoundException ignored) {}

        try {
            return loadUserByRoleAndIdentifier("TEACHER", identifier);
        } catch (UsernameNotFoundException ignored) {}

        try {
            return loadUserByRoleAndIdentifier("STUDENT", identifier);
        } catch (UsernameNotFoundException ignored) {}

        throw new UsernameNotFoundException("User not found: " + username);
    }

    @Transactional(readOnly = true)
    public CustomUserPrincipal loadUserByRoleAndIdentifier(String role, String identifier) {
        switch (role.toUpperCase()) {
            case "ADMIN":
                Admin admin = adminRepository.findByUsernameOrEmail(identifier, identifier)
                        .orElseThrow(() -> new UsernameNotFoundException("Admin not found with: " + identifier));
                return new CustomUserPrincipal(admin.getId(), admin.getUsername(), admin.getPassword(), "ADMIN", admin.getUsername());

            case "TEACHER":
                Teacher teacher = teacherRepository.findByEmail(identifier)
                        .orElseThrow(() -> new UsernameNotFoundException("Teacher not found with email: " + identifier));
                return new CustomUserPrincipal(teacher.getId(), teacher.getEmail(), teacher.getPassword(), "TEACHER", teacher.getName());

            case "STUDENT":
                Student student = studentRepository.findByEmail(identifier)
                        .orElseThrow(() -> new UsernameNotFoundException("Student not found with email: " + identifier));
                return new CustomUserPrincipal(student.getId(), student.getEmail(), student.getPassword(), "STUDENT", student.getName());

            default:
                throw new UsernameNotFoundException("Unsupported role: " + role);
        }
    }
}

