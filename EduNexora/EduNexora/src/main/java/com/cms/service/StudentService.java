package com.cms.service;

import com.cms.dto.StudentRegistrationDto;
import com.cms.entity.Student;

public interface StudentService {
    Student registerStudent(StudentRegistrationDto registrationDto);
    boolean emailExists(String email);
    Student findById(Long id);
    Student findByEmail(String email);
    void updateProfile(Long id, String name, String phone, String newPassword);
}

