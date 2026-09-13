package com.fitbizz.controller;

import com.fitbizz.dto.AuthResponse;
import com.fitbizz.dto.LoginRequest;
import com.fitbizz.security.JwtTokenProvider;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

@RestController
@RequestMapping("/api/v1/auth")
public class AuthController {

    private final JwtTokenProvider tokenProvider;

    public AuthController(JwtTokenProvider tokenProvider) {
        this.tokenProvider = tokenProvider;
    }

    @PostMapping("/login")
    public ResponseEntity<AuthResponse> login(@Valid @RequestBody LoginRequest request) {
        // Multi-tenant demonstration authentication endpoint
        String dummyUserId = UUID.randomUUID().toString();
        String dummyTenantId = "tenant-001";
        String dummyBranchId = "branch-001";
        String role = "RECEPTIONIST";

        String token = tokenProvider.generateToken(
                dummyUserId, dummyTenantId, dummyBranchId, role, request.getEmail()
        );

        AuthResponse response = new AuthResponse(
                token, dummyUserId, dummyTenantId, dummyBranchId, role, "Demo Admin", request.getEmail()
        );

        return ResponseEntity.ok(response);
    }
}
