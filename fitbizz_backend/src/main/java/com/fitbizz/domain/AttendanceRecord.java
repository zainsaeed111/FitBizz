package com.fitbizz.domain;

import jakarta.persistence.*;
import java.time.ZonedDateTime;

@Entity
@Table(name = "attendance_records")
public class AttendanceRecord {

    @Id
    private String id;

    @Column(name = "tenant_id", nullable = false)
    private String tenantId;

    @Column(name = "branch_id", nullable = false)
    private String branchId;

    @Column(name = "member_id", nullable = false)
    private String memberId;

    @Column(name = "check_in_at", nullable = false)
    private ZonedDateTime checkInAt = ZonedDateTime.now();

    @Column(nullable = false)
    private String method = "MANUAL";

    @Column(nullable = false)
    private Boolean synced = true;

    @Column(name = "created_at")
    private ZonedDateTime createdAt = ZonedDateTime.now();

    public AttendanceRecord() {}

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getTenantId() { return tenantId; }
    public void setTenantId(String tenantId) { this.tenantId = tenantId; }

    public String getBranchId() { return branchId; }
    public void setBranchId(String branchId) { this.branchId = branchId; }

    public String getMemberId() { return memberId; }
    public void setMemberId(String memberId) { this.memberId = memberId; }

    public ZonedDateTime getCheckInAt() { return checkInAt; }
    public void setCheckInAt(ZonedDateTime checkInAt) { this.checkInAt = checkInAt; }

    public String getMethod() { return method; }
    public void setMethod(String method) { this.method = method; }

    public Boolean getSynced() { return synced; }
    public void setSynced(Boolean synced) { this.synced = synced; }

    public ZonedDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(ZonedDateTime createdAt) { this.createdAt = createdAt; }
}
