package com.cms.service;

import com.cms.dto.TeacherFormDto;
import com.cms.entity.Teacher;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.util.List;

public interface TeacherService {
    Page<Teacher> getTeachers(String search, Pageable pageable);
    List<Teacher> getAllTeachers();
    Teacher getTeacherById(Long id);
    Teacher createTeacher(TeacherFormDto dto);
    Teacher updateTeacher(Long id, TeacherFormDto dto);
    void deleteTeacher(Long id);
}

