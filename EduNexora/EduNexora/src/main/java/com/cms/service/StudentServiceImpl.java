package com.cms.service;

import com.cms.dto.StudentRegistrationDto;
import com.cms.entity.Student;
import com.cms.exception.DuplicateResourceException;
import com.cms.exception.ResourceNotFoundException;
import com.cms.repository.StudentRepository;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class StudentServiceImpl implements StudentService {

    private final StudentRepository studentRepository;
    private final PasswordEncoder passwordEncoder;

    public StudentServiceImpl(StudentRepository studentRepository, PasswordEncoder passwordEncoder) {
        this.studentRepository = studentRepository;
        this.passwordEncoder = passwordEncoder;
    }

    @Override
    @Transactional
    public Student registerStudent(StudentRegistrationDto dto) {
        if (studentRepository.existsByEmail(dto.getEmail())) {
            throw new DuplicateResourceException("An account with email '" + dto.getEmail() + "' already exists.");
        }

        Student student = new Student(
            dto.getFullName().trim(),
            dto.getEmail().trim().toLowerCase(),
            dto.getPhone().trim(),
            passwordEncoder.encode(dto.getPassword())
        );

        return studentRepository.save(student);
    }

    @Override
    @Transactional(readOnly = true)
    public boolean emailExists(String email) {
        return studentRepository.existsByEmail(email);
    }

    @Override
    @Transactional(readOnly = true)
    public Student findById(Long id) {
        return studentRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Student not found with ID: " + id));
    }

    @Override
    @Transactional(readOnly = true)
    public Student findByEmail(String email) {
        return studentRepository.findByEmail(email)
                .orElseThrow(() -> new ResourceNotFoundException("Student not found with email: " + email));
    }

    @Override
    @Transactional
    public void updateProfile(Long id, String name, String phone, String newPassword) {
        Student student = findById(id);
        student.setName(name.trim());
        student.setPhone(phone != null ? phone.trim() : null);
        if (newPassword != null && !newPassword.trim().isEmpty()) {
            student.setPassword(passwordEncoder.encode(newPassword.trim()));
        }
        studentRepository.save(student);
    }
}

