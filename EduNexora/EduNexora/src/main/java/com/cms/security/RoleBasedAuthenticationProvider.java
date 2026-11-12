package com.cms.security;

import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

@Component
public class RoleBasedAuthenticationProvider implements AuthenticationProvider {

    private final CustomUserDetailsService userDetailsService;
    private final PasswordEncoder passwordEncoder;

    public RoleBasedAuthenticationProvider(CustomUserDetailsService userDetailsService,
                                           PasswordEncoder passwordEncoder) {
        this.userDetailsService = userDetailsService;
        this.passwordEncoder = passwordEncoder;
    }

    @Override
    public Authentication authenticate(Authentication authentication) throws AuthenticationException {
        if (!(authentication instanceof RoleBasedAuthenticationToken token)) {
            return null;
        }

        String role = token.getRole();
        String identifier = (authentication.getPrincipal() == null) ? "" : authentication.getPrincipal().toString();
        String password = (authentication.getCredentials() == null) ? "" : authentication.getCredentials().toString();

        if (role == null || role.trim().isEmpty() || identifier.trim().isEmpty() || password.trim().isEmpty()) {
            throw new BadCredentialsException("Invalid credentials or role selection.");
        }

        try {
            CustomUserPrincipal principal = userDetailsService.loadUserByRoleAndIdentifier(role, identifier);
            if (!passwordEncoder.matches(password, principal.getPassword())) {
                throw new BadCredentialsException("Invalid credentials or role selection.");
            }
            return new RoleBasedAuthenticationToken(principal, null, role, principal.getAuthorities());
        } catch (Exception e) {
            throw new BadCredentialsException("Invalid credentials or role selection.");
        }
    }

    @Override
    public boolean supports(Class<?> authentication) {
        return RoleBasedAuthenticationToken.class.isAssignableFrom(authentication);
    }
}

