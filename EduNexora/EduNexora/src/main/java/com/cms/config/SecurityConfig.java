package com.cms.config;

import com.cms.security.CustomAuthenticationSuccessHandler;
import com.cms.security.CustomUserDetailsService;
import com.cms.security.RoleBasedAuthenticationFilter;
import com.cms.security.RoleBasedAuthenticationProvider;
import jakarta.servlet.DispatcherType;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.ProviderManager;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.LoginUrlAuthenticationEntryPoint;
import org.springframework.security.web.authentication.SimpleUrlAuthenticationFailureHandler;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.security.web.authentication.rememberme.TokenBasedRememberMeServices;

import java.util.Collections;

@Configuration
@EnableWebSecurity
@EnableMethodSecurity
public class SecurityConfig {

    private static final String REMEMBER_ME_KEY = "edunexora-remember-me-secret-key-2026";
    private static final int REMEMBER_ME_VALIDITY_SECONDS = 14 * 24 * 60 * 60; // 14 days

    private final CustomUserDetailsService customUserDetailsService;
    private final CustomAuthenticationSuccessHandler customAuthenticationSuccessHandler;

    public SecurityConfig(CustomUserDetailsService customUserDetailsService,
                          CustomAuthenticationSuccessHandler customAuthenticationSuccessHandler) {
        this.customUserDetailsService = customUserDetailsService;
        this.customAuthenticationSuccessHandler = customAuthenticationSuccessHandler;
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public AuthenticationManager authenticationManager(RoleBasedAuthenticationProvider provider) {
        return new ProviderManager(Collections.singletonList(provider));
    }

    @Bean
    public TokenBasedRememberMeServices rememberMeServices() {
        TokenBasedRememberMeServices services =
                new TokenBasedRememberMeServices(REMEMBER_ME_KEY, customUserDetailsService);
        services.setParameter("remember-me");
        services.setCookieName("remember-me");
        services.setTokenValiditySeconds(REMEMBER_ME_VALIDITY_SECONDS);
        return services;
    }

    @Bean
    public RoleBasedAuthenticationFilter roleBasedAuthenticationFilter(AuthenticationManager authenticationManager,
                                                                       TokenBasedRememberMeServices rememberMeServices) {
        RoleBasedAuthenticationFilter filter = new RoleBasedAuthenticationFilter(authenticationManager);
        filter.setAuthenticationSuccessHandler(customAuthenticationSuccessHandler);
        filter.setAuthenticationFailureHandler(new SimpleUrlAuthenticationFailureHandler("/auth/login.jsp?error=true"));
        filter.setRememberMeServices(rememberMeServices);
        return filter;
    }

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http,
                                                   RoleBasedAuthenticationFilter roleBasedAuthenticationFilter,
                                                   TokenBasedRememberMeServices rememberMeServices) throws Exception {
        http
            .authorizeHttpRequests(auth -> auth
                .dispatcherTypeMatchers(DispatcherType.FORWARD, DispatcherType.INCLUDE, DispatcherType.ERROR).permitAll()
                .requestMatchers("/login", "/register", "/auth/**", "/access-denied", "/css/**", "/js/**", "/images/**", "/favicon.ico").permitAll()
                .requestMatchers("/admin/**").hasRole("ADMIN")
                .requestMatchers("/teacher/**").hasRole("TEACHER")
                .requestMatchers("/student/**").hasRole("STUDENT")
                .anyRequest().authenticated()
            )
            .addFilterBefore(roleBasedAuthenticationFilter, UsernamePasswordAuthenticationFilter.class)
            .rememberMe(rm -> rm
                .rememberMeServices(rememberMeServices)
                .key(REMEMBER_ME_KEY)
            )
            .sessionManagement(session -> session
                .sessionFixation().migrateSession()
            )
            .logout(logout -> logout
                .logoutUrl("/logout")
                .logoutSuccessUrl("/auth/login.jsp?logout=true")
                .invalidateHttpSession(true)
                .clearAuthentication(true)
                .deleteCookies("JSESSIONID", "remember-me")
                .permitAll()
            )
            .exceptionHandling(ex -> ex
                .authenticationEntryPoint(new LoginUrlAuthenticationEntryPoint("/auth/login.jsp"))
                .accessDeniedPage("/access-denied")
            );

        return http.build();
    }
}
