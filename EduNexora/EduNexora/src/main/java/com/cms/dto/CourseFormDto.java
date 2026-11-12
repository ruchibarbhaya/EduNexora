package com.cms.dto;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

import java.math.BigDecimal;

public class CourseFormDto {

    private Long id;

    @NotBlank(message = "Course name is required")
    @Size(min = 2, max = 150, message = "Course name must be between 2 and 150 characters")
    private String courseName;

    @NotBlank(message = "Course code is required")
    @Size(min = 2, max = 50, message = "Course code must be between 2 and 50 characters")
    private String courseCode;

    private String description;

    @NotBlank(message = "Duration is required")
    @Size(max = 50, message = "Duration cannot exceed 50 characters")
    private String duration;

    @NotNull(message = "Course fee is required")
    @DecimalMin(value = "0.0", inclusive = true, message = "Fees cannot be negative")
    private BigDecimal fees;

    private Long teacherId;

    public CourseFormDto() {
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getCourseName() {
        return courseName;
    }

    public void setCourseName(String courseName) {
        this.courseName = courseName;
    }

    public String getCourseCode() {
        return courseCode;
    }

    public void setCourseCode(String courseCode) {
        this.courseCode = courseCode;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getDuration() {
        return duration;
    }

    public void setDuration(String duration) {
        this.duration = duration;
    }

    public BigDecimal getFees() {
        return fees;
    }

    public void setFees(BigDecimal fees) {
        this.fees = fees;
    }

    public Long getTeacherId() {
        return teacherId;
    }

    public void setTeacherId(Long teacherId) {
        this.teacherId = teacherId;
    }
}

