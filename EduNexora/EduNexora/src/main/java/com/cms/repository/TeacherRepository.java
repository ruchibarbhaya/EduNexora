package com.cms.repository;

import com.cms.entity.Teacher;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface TeacherRepository extends JpaRepository<Teacher, Long> {
    Optional<Teacher> findByEmail(String email);
    boolean existsByEmail(String email);
    boolean existsByEmailAndIdNot(String email, Long id);

    @Query("SELECT t FROM Teacher t WHERE (:search IS NULL OR LOWER(t.name) LIKE LOWER(CONCAT('%', :search, '%')) OR LOWER(t.email) LIKE LOWER(CONCAT('%', :search, '%')) OR LOWER(t.department) LIKE LOWER(CONCAT('%', :search, '%')))")
    Page<Teacher> searchTeachers(@Param("search") String search, Pageable pageable);

    List<Teacher> findAllByOrderByNameAsc();
}

