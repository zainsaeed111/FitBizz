package com.fitbizz.domain;

import jakarta.persistence.*;
import java.time.ZonedDateTime;

@Entity
@Table(name = "members")
public class Member {

    @Id
    private String id;

    @Column(name = "tenant_id", nullable = false)
    private String tenantId;

    @Column(name = "branch_id", nullable = false)
    private String branchId;

    @Column(name = "member_number", nullable = false)
    private String memberNumber;

    @Column(name = "full_name", nullable = false)
    private String fullName;

    private String email;
    private String phone;

    @Column(name = "plan_id")
    private String planId;

    private String cnic;

    @Column(name = "photo_url")
    private String photoUrl;

    private String dob;

    @Column(name = "roll_number")
    private String rollNumber;

    @Column(name = "membership_type")
    private String membershipType = "MONTHLY_STANDARD";

    @Column(name = "fee_amount")
    private Double feeAmount = 5000.0;

    @Column(name = "payment_mode")
    private String paymentMode = "CASH";

    @Column(name = "payment_reference")
    private String paymentReference;

    @Column(name = "qr_code_data")
    private String qrCodeData;

    @Column(nullable = false)
    private String status = "ACTIVE";

    @Column(name = "joined_at")
    private ZonedDateTime joinedAt = ZonedDateTime.now();

    @Column(name = "expires_at")
    private ZonedDateTime expiresAt;

    @Column(name = "updated_at")
    private ZonedDateTime updatedAt = ZonedDateTime.now();

    public Member() {}

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getTenantId() { return tenantId; }
    public void setTenantId(String tenantId) { this.tenantId = tenantId; }

    public String getBranchId() { return branchId; }
    public void setBranchId(String branchId) { this.branchId = branchId; }

    public String getMemberNumber() { return memberNumber; }
    public void setMemberNumber(String memberNumber) { this.memberNumber = memberNumber; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getPlanId() { return planId; }
    public void setPlanId(String planId) { this.planId = planId; }

    public String getCnic() { return cnic; }
    public void setCnic(String cnic) { this.cnic = cnic; }

    public String getPhotoUrl() { return photoUrl; }
    public void setPhotoUrl(String photoUrl) { this.photoUrl = photoUrl; }

    public String getDob() { return dob; }
    public void setDob(String dob) { this.dob = dob; }

    public String getRollNumber() { return rollNumber; }
    public void setRollNumber(String rollNumber) { this.rollNumber = rollNumber; }

    public String getMembershipType() { return membershipType; }
    public void setMembershipType(String membershipType) { this.membershipType = membershipType; }

    public Double getFeeAmount() { return feeAmount; }
    public void setFeeAmount(Double feeAmount) { this.feeAmount = feeAmount; }

    public String getPaymentMode() { return paymentMode; }
    public void setPaymentMode(String paymentMode) { this.paymentMode = paymentMode; }

    public String getPaymentReference() { return paymentReference; }
    public void setPaymentReference(String paymentReference) { this.paymentReference = paymentReference; }

    public String getQrCodeData() { return qrCodeData; }
    public void setQrCodeData(String qrCodeData) { this.qrCodeData = qrCodeData; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public ZonedDateTime getJoinedAt() { return joinedAt; }
    public void setJoinedAt(ZonedDateTime joinedAt) { this.joinedAt = joinedAt; }

    public ZonedDateTime getExpiresAt() { return expiresAt; }
    public void setExpiresAt(ZonedDateTime expiresAt) { this.expiresAt = expiresAt; }

    public ZonedDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(ZonedDateTime updatedAt) { this.updatedAt = updatedAt; }
}
