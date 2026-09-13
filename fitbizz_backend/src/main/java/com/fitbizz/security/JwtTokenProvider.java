package com.fitbizz.security;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.JwtException;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import org.springframework.stereotype.Component;

import javax.crypto.SecretKey;
import java.nio.charset.StandardCharsets;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

@Component
public class JwtTokenProvider {

    private static final String SECRET_KEY_STR = "fitbizz_super_secret_jwt_key_that_is_at_least_32_bytes_long_enterprise";
    private static final long EXPIRATION_TIME_MS = 86400000; // 24 hours

    private final SecretKey key = Keys.hmacShaKeyFor(SECRET_KEY_STR.getBytes(StandardCharsets.UTF_8));

    public String generateToken(String userId, String tenantId, String branchId, String role, String email) {
        Map<String, Object> claims = new HashMap<>();
        claims.put("tenantId", tenantId);
        claims.put("branchId", branchId);
        claims.put("role", role);
        claims.put("email", email);

        Date now = new Date();
        Date expiryDate = new Date(now.getTime() + EXPIRATION_TIME_MS);

        return Jwts.builder()
                .claims(claims)
                .subject(userId)
                .issuedAt(now)
                .expiration(expiryDate)
                .signWith(key)
                .compact();
    }

    public boolean validateToken(String token) {
        try {
            Jwts.parser().verifyWith(key).build().parseSignedClaims(token);
            return true;
        } catch (JwtException | IllegalArgumentException e) {
            return false;
        }
    }

    public Claims getClaimsFromToken(String token) {
        return Jwts.parser()
                .verifyWith(key)
                .build()
                .parseSignedClaims(token)
                .getPayload();
    }
}
