package com.cms.security;

import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.GrantedAuthority;

import java.util.Collection;

public class RoleBasedAuthenticationToken extends UsernamePasswordAuthenticationToken {

    private final String role;

    public RoleBasedAuthenticationToken(Object principal, Object credentials, String role) {
        super(principal, credentials);
        this.role = role;
    }

    public RoleBasedAuthenticationToken(Object principal, Object credentials, String role,
                                        Collection<? extends GrantedAuthority> authorities) {
        super(principal, credentials, authorities);
        this.role = role;
    }

    public String getRole() {
        return role;
    }
}

