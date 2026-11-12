package com.cms.security;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.web.authentication.SimpleUrlAuthenticationSuccessHandler;
import org.springframework.stereotype.Component;

import java.io.IOException;

@Component
public class CustomAuthenticationSuccessHandler extends SimpleUrlAuthenticationSuccessHandler {

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
                                        Authentication authentication) throws IOException {
        clearAuthenticationAttributes(request);

        for (GrantedAuthority authority : authentication.getAuthorities()) {
            String role = authority.getAuthority();
            if ("ROLE_ADMIN".equals(role)) {
                getRedirectStrategy().sendRedirect(request, response, "/admin/dashboard");
                return;
            } else if ("ROLE_TEACHER".equals(role)) {
                getRedirectStrategy().sendRedirect(request, response, "/teacher/dashboard");
                return;
            } else if ("ROLE_STUDENT".equals(role)) {
                getRedirectStrategy().sendRedirect(request, response, "/student/dashboard");
                return;
            }
        }

        getRedirectStrategy().sendRedirect(request, response, "/auth/login.jsp");
    }
}

