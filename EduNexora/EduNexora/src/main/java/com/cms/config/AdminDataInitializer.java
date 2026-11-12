package com.cms.config;

import com.cms.entity.Admin;
import com.cms.repository.AdminRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

@Component
public class AdminDataInitializer implements CommandLineRunner {

    private static final Logger log = LoggerFactory.getLogger(AdminDataInitializer.class);

    private final AdminRepository adminRepository;
    private final PasswordEncoder passwordEncoder;

    @Value("${cms.admin.username:admin}")
    private String adminUsername;

    @Value("${cms.admin.email:admin@edunexora.com}")
    private String adminEmail;

    @Value("${cms.admin.password:Admin@123}")
    private String adminPassword;

    public AdminDataInitializer(AdminRepository adminRepository, PasswordEncoder passwordEncoder) {
        this.adminRepository = adminRepository;
        this.passwordEncoder = passwordEncoder;
    }

    @Override
    @Transactional
    public void run(String... args) {
        if (adminRepository.count() == 0) {
            log.info("No admin user found. Creating initial admin from configuration...");
            Admin admin = new Admin(
                adminUsername,
                adminEmail,
                passwordEncoder.encode(adminPassword)
            );
            adminRepository.save(admin);
            log.info("Initial admin user '{}' created successfully.", adminUsername);
        } else {
            log.info("Admin account already exists. Skipping initial admin creation.");
        }
    }
}

