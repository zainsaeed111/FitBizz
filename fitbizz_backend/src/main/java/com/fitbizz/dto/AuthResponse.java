package com.fitbizz.dto;

public class AuthResponse {

    private String token;
    private String userId;
    private String tenantId;
    private String branchId;
    private String role;
    private String fullName;
    private String email;

    public AuthResponse() {}

    public AuthResponse(String token, String userId, String tenantId, String branchId, String role, String fullName, String email) {
        this.token = token;
        this.userId = userId;
        this.tenantId = tenantId;
        this.branchId = branchId;
        this.role = role;
        this.fullName = fullName;
        this.email = email;
    }

    public String getToken() { return token; }
    public void setToken(String token) { this.token = token; }

    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }

    public String getTenantId() { return tenantId; }
    public void setTenantId(String tenantId) { this.tenantId = tenantId; }

    public String getBranchId() { return branchId; }
    public void setBranchId(String branchId) { this.branchId = branchId; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
}
