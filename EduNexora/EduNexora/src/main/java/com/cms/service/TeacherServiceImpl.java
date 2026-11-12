package com.cms.service;

import com.cms.dto.TeacherFormDto;
import com.cms.entity.Teacher;
import com.cms.exception.DuplicateResourceException;
import com.cms.exception.ResourceNotFoundException;
import com.cms.repository.CourseRepository;
import com.cms.repository.TeacherRepository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class TeacherServiceImpl implements TeacherService {

    private final TeacherRepository teacherRepository;
    private final CourseRepository courseRepository;
    private final PasswordEncoder passwordEncoder;

    public TeacherServiceImpl(TeacherRepository teacherRepository,
                              CourseRepository courseRepository,
                              PasswordEncoder passwordEncoder) {
        this.teacherRepository = teacherRepository;
        this.courseRepository = courseRepository;
        this.passwordEncoder = passwordEncoder;
    }

    @Override
    @Transactional(readOnly = true)
    public Page<Teacher> getTeachers(String search, Pageable pageable) {
        String query = (search != null && !search.trim().isEmpty()) ? search.trim() : null;
        return teacherRepository.searchTeachers(query, pageable);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Teacher> getAllTeachers() {
        return teacherRepository.findAllByOrderByNameAsc();
    }

    @Override
    @Transactional(readOnly = true)
    public Teacher getTeacherById(Long id) {
        return teacherRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Teacher not found with ID: " + id));
    }

    @Override
    @Transactional
    public Teacher createTeacher(TeacherFormDto dto) {
        if (teacherRepository.existsByEmail(dto.getEmail().trim())) {
            throw new DuplicateResourceException("A teacher with email '" + dto.getEmail() + "' already exists.");
        }

        String rawPassword = (dto.getPassword() != null && !dto.getPassword().trim().isEmpty())
                ? dto.getPassword().trim()
                : "Password@123";

        Teacher teacher = new Teacher(
                dto.getName().trim(),
                dto.getEmail().trim().toLowerCase(),
                dto.getPhone().trim(),
                dto.getDepartment().trim(),
                passwordEncoder.encode(rawPassword)
        );

        return teacherRepository.save(teacher);
    }

    @Override
    @Transactional
    public Teacher updateTeacher(Long id, TeacherFormDto dto) {
        Teacher teacher = getTeacherById(id);

        if (teacherRepository.existsByEmailAndIdNot(dto.getEmail().trim(), id)) {
            throw new DuplicateResourceException("A teacher with email '" + dto.getEmail() + "' already exists.");
        }

        teacher.setName(dto.getName().trim());
        teacher.setEmail(dto.getEmail().trim().toLowerCase());
        teacher.setPhone(dto.getPhone().trim());
        teacher.setDepartment(dto.getDepartment().trim());

        // Blank password keeps the old one
        if (dto.getPassword() != null && !dto.getPassword().trim().isEmpty()) {
            teacher.setPassword(passwordEncoder.encode(dto.getPassword().trim()));
        }

        return teacherRepository.save(teacher);
    }

    @Override
    @Transactional
    public void deleteTeacher(Long id) {
        Teacher teacher = getTeacherById(id);
        long courseCount = courseRepository.countByTeacherId(id);
        if (courseCount > 0) {
            throw new IllegalStateException("Cannot delete teacher '" + teacher.getName() + "' because they have " +
                    courseCount + " assigned course(s). Please reassign or remove the courses first.");
        }
        teacherRepository.delete(teacher);
    }
}

