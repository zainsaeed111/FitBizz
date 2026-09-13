package com.fitbizz.domain;

import jakarta.persistence.*;
import java.time.ZonedDateTime;

@Entity
@Table(name = "subscriptions")
public class Subscription {

    @Id
    private String id;

    @Column(name = "tenant_id", nullable = false)
    private String tenantId;

    @Column(name = "branch_id", nullable = false)
    private String branchId;

    @Column(name = "member_id", nullable = false)
    private String memberId;

    @Column(name = "plan_id")
    private String planId;

    @Column(name = "start_date", nullable = false)
    private ZonedDateTime startDate;

    @Column(name = "end_date", nullable = false)
    private ZonedDateTime endDate;

    @Column(name = "auto_renew", nullable = false)
    private Boolean autoRenew = true;

    @Column(nullable = false)
    private String status = "ACTIVE";

    @Column(name = "created_at")
    private ZonedDateTime createdAt = ZonedDateTime.now();

    public Subscription() {}

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getTenantId() { return tenantId; }
    public void setTenantId(String tenantId) { this.tenantId = tenantId; }

    public String getBranchId() { return branchId; }
    public void setBranchId(String branchId) { this.branchId = branchId; }

    public String getMemberId() { return memberId; }
    public void setMemberId(String memberId) { this.memberId = memberId; }

    public String getPlanId() { return planId; }
    public void setPlanId(String planId) { this.planId = planId; }

    public ZonedDateTime getStartDate() { return startDate; }
    public void setStartDate(ZonedDateTime startDate) { this.startDate = startDate; }

    public ZonedDateTime getEndDate() { return endDate; }
    public void setEndDate(ZonedDateTime endDate) { this.endDate = endDate; }

    public Boolean getAutoRenew() { return autoRenew; }
    public void setAutoRenew(Boolean autoRenew) { this.autoRenew = autoRenew; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public ZonedDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(ZonedDateTime createdAt) { this.createdAt = createdAt; }
}
