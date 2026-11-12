package com.cms.security;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.util.Collection;
import java.util.Collections;

public class CustomUserPrincipal implements UserDetails {

    private final Long id;
    private final String usernameWithRole;
    private final String rawUsername;
    private final String password;
    private final String role;
    private final String displayName;
    private final Collection<? extends GrantedAuthority> authorities;

    public CustomUserPrincipal(Long id, String rawUsername, String password, String role, String displayName) {
        this.id = id;
        this.rawUsername = rawUsername;
        this.usernameWithRole = role + ":" + rawUsername;
        this.password = password;
        this.role = role;
        this.displayName = displayName;
        this.authorities = Collections.singletonList(new SimpleGrantedAuthority("ROLE_" + role));
    }

    public Long getId() {
        return id;
    }

    public String getRole() {
        return role;
    }

    public String getDisplayName() {
        return displayName;
    }

    public String getRawUsername() {
        return rawUsername;
    }

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return authorities;
    }

    @Override
    public String getPassword() {
        return password;
    }

    @Override
    public String getUsername() {
        return usernameWithRole;
    }

    @Override
    public boolean isAccountNonExpired() {
        return true;
    }

    @Override
    public boolean isAccountNonLocked() {
        return true;
    }

    @Override
    public boolean isCredentialsNonExpired() {
        return true;
    }

    @Override
    public boolean isEnabled() {
        return true;
    }
}

