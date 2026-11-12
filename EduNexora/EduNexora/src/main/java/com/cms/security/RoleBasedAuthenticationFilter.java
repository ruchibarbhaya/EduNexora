package com.cms.security;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.AuthenticationServiceException;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.authentication.AbstractAuthenticationProcessingFilter;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;

public class RoleBasedAuthenticationFilter extends AbstractAuthenticationProcessingFilter {

    private static final String DEFAULT_FILTER_PROCESSES_URL = "/login";
    private static final String ROLE_PARAMETER = "role";
    private static final String USERNAME_PARAMETER = "username";
    private static final String PASSWORD_PARAMETER = "password";

    public RoleBasedAuthenticationFilter(AuthenticationManager authenticationManager) {
        super(new AntPathRequestMatcher(DEFAULT_FILTER_PROCESSES_URL, "POST"));
        setAuthenticationManager(authenticationManager);
    }

    @Override
    public Authentication attemptAuthentication(HttpServletRequest request, HttpServletResponse response)
            throws AuthenticationException {
        if (!request.getMethod().equals("POST")) {
            throw new AuthenticationServiceException("Authentication method not supported: " + request.getMethod());
        }

        String username = obtainUsername(request);
        String password = obtainPassword(request);
        String role = obtainRole(request);

        if (username == null) {
            username = "";
        }
        if (password == null) {
            password = "";
        }
        if (role == null) {
            role = "";
        }

        username = username.trim();
        role = role.trim().toUpperCase();

        RoleBasedAuthenticationToken authRequest = new RoleBasedAuthenticationToken(username, password, role);
        setDetails(request, authRequest);
        return this.getAuthenticationManager().authenticate(authRequest);
    }

    protected String obtainUsername(HttpServletRequest request) {
        return request.getParameter(USERNAME_PARAMETER);
    }

    protected String obtainPassword(HttpServletRequest request) {
        return request.getParameter(PASSWORD_PARAMETER);
    }

    protected String obtainRole(HttpServletRequest request) {
        return request.getParameter(ROLE_PARAMETER);
    }

    protected void setDetails(HttpServletRequest request, RoleBasedAuthenticationToken authRequest) {
        authRequest.setDetails(this.authenticationDetailsSource.buildDetails(request));
    }
}

