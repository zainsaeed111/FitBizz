package com.fitbizz.domain;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.ZonedDateTime;

@Entity
@Table(name = "membership_plans")
public class MembershipPlan {

    @Id
    private String id;

    @Column(name = "tenant_id", nullable = false)
    private String tenantId;

    @Column(nullable = false)
    private String name;

    @Column(name = "duration_months")
    private Integer durationMonths = 1;

    @Column(name = "duration_days")
    private Integer durationDays = 30;

    @Column(name = "admission_fee")
    private BigDecimal admissionFee = BigDecimal.ZERO;

    @Column(name = "monthly_fee")
    private BigDecimal monthlyFee = BigDecimal.ZERO;

    @Column(name = "additional_charges")
    private BigDecimal additionalCharges = BigDecimal.ZERO;

    @Column(nullable = false)
    private BigDecimal price = BigDecimal.ZERO;

    @Column(nullable = false)
    private String currency = "PKR";

    @Column(name = "has_trainer_support")
    private Boolean hasTrainerSupport = false;

    @Column(name = "trainer_support_note")
    private String trainerSupportNote;

    @Column(name = "has_meal_plan")
    private Boolean hasMealPlan = false;

    @Column(name = "has_mobile_app")
    private Boolean hasMobileApp = true;

    @Column(name = "has_locker_access")
    private Boolean hasLockerAccess = true;

    @Column(name = "is_multi_branch")
    private Boolean isMultiBranch = false;

    @Column(name = "is_default")
    private Boolean isDefault = false;

    @Column(name = "badge")
    private String badge;

    @Column(name = "benefits_json")
    private String benefitsJson;

    @Column(nullable = false)
    private String status = "ACTIVE";

    @Column(name = "created_at")
    private ZonedDateTime createdAt = ZonedDateTime.now();

    @Column(name = "updated_at")
    private ZonedDateTime updatedAt = ZonedDateTime.now();

    public MembershipPlan() {}

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getTenantId() { return tenantId; }
    public void setTenantId(String tenantId) { this.tenantId = tenantId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public Integer getDurationMonths() { return durationMonths != null ? durationMonths : 1; }
    public void setDurationMonths(Integer durationMonths) { this.durationMonths = durationMonths; }

    public Integer getDurationDays() { return durationDays != null ? durationDays : 30; }
    public void setDurationDays(Integer durationDays) { this.durationDays = durationDays; }

    public BigDecimal getAdmissionFee() { return admissionFee != null ? admissionFee : BigDecimal.ZERO; }
    public void setAdmissionFee(BigDecimal admissionFee) { this.admissionFee = admissionFee; }

    public BigDecimal getMonthlyFee() { return monthlyFee != null ? monthlyFee : BigDecimal.ZERO; }
    public void setMonthlyFee(BigDecimal monthlyFee) { this.monthlyFee = monthlyFee; }

    public BigDecimal getAdditionalCharges() { return additionalCharges != null ? additionalCharges : BigDecimal.ZERO; }
    public void setAdditionalCharges(BigDecimal additionalCharges) { this.additionalCharges = additionalCharges; }

    public BigDecimal getPrice() { return price != null ? price : BigDecimal.ZERO; }
    public void setPrice(BigDecimal price) { this.price = price; }

    public String getCurrency() { return currency; }
    public void setCurrency(String currency) { this.currency = currency; }

    public Boolean getHasTrainerSupport() { return hasTrainerSupport != null && hasTrainerSupport; }
    public void setHasTrainerSupport(Boolean hasTrainerSupport) { this.hasTrainerSupport = hasTrainerSupport; }

    public String getTrainerSupportNote() { return trainerSupportNote; }
    public void setTrainerSupportNote(String trainerSupportNote) { this.trainerSupportNote = trainerSupportNote; }

    public Boolean getHasMealPlan() { return hasMealPlan != null && hasMealPlan; }
    public void setHasMealPlan(Boolean hasMealPlan) { this.hasMealPlan = hasMealPlan; }

    public Boolean getHasMobileApp() { return hasMobileApp != null && hasMobileApp; }
    public void setHasMobileApp(Boolean hasMobileApp) { this.hasMobileApp = hasMobileApp; }

    public Boolean getHasLockerAccess() { return hasLockerAccess != null && hasLockerAccess; }
    public void setHasLockerAccess(Boolean hasLockerAccess) { this.hasLockerAccess = hasLockerAccess; }

    public Boolean getIsMultiBranch() { return isMultiBranch != null && isMultiBranch; }
    public void setIsMultiBranch(Boolean isMultiBranch) { this.isMultiBranch = isMultiBranch; }

    public Boolean getIsDefault() { return isDefault != null && isDefault; }
    public void setIsDefault(Boolean isDefault) { this.isDefault = isDefault; }

    public String getBadge() { return badge; }
    public void setBadge(String badge) { this.badge = badge; }

    public String getBenefitsJson() { return benefitsJson; }
    public void setBenefitsJson(String benefitsJson) { this.benefitsJson = benefitsJson; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public ZonedDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(ZonedDateTime createdAt) { this.createdAt = createdAt; }

    public ZonedDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(ZonedDateTime updatedAt) { this.updatedAt = updatedAt; }
}
