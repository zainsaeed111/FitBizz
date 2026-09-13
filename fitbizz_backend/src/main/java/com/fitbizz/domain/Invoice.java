package com.fitbizz.domain;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.ZonedDateTime;

@Entity
@Table(name = "invoices")
public class Invoice {

    @Id
    private String id;

    @Column(name = "tenant_id", nullable = false)
    private String tenantId;

    @Column(name = "branch_id", nullable = false)
    private String branchId;

    @Column(name = "invoice_number", nullable = false)
    private String invoiceNumber;

    @Column(name = "member_id", nullable = false)
    private String memberId;

    @Column(name = "subscription_id")
    private String subscriptionId;

    @Column(nullable = false)
    private BigDecimal amount;

    @Column(nullable = false)
    private BigDecimal tax = BigDecimal.ZERO;

    @Column(nullable = false)
    private String status = "UNPAID";

    @Column(name = "due_date", nullable = false)
    private ZonedDateTime dueDate;

    @Column(name = "payment_method")
    private String paymentMethod;

    @Column(name = "created_at")
    private ZonedDateTime createdAt = ZonedDateTime.now();

    public Invoice() {}

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getTenantId() { return tenantId; }
    public void setTenantId(String tenantId) { this.tenantId = tenantId; }

    public String getBranchId() { return branchId; }
    public void setBranchId(String branchId) { this.branchId = branchId; }

    public String getInvoiceNumber() { return invoiceNumber; }
    public void setInvoiceNumber(String invoiceNumber) { this.invoiceNumber = invoiceNumber; }

    public String getMemberId() { return memberId; }
    public void setMemberId(String memberId) { this.memberId = memberId; }

    public String getSubscriptionId() { return subscriptionId; }
    public void setSubscriptionId(String subscriptionId) { this.subscriptionId = subscriptionId; }

    public BigDecimal getAmount() { return amount; }
    public void setAmount(BigDecimal amount) { this.amount = amount; }

    public BigDecimal getTax() { return tax; }
    public void setTax(BigDecimal tax) { this.tax = tax; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public ZonedDateTime getDueDate() { return dueDate; }
    public void setDueDate(ZonedDateTime dueDate) { this.dueDate = dueDate; }

    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }

    public ZonedDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(ZonedDateTime createdAt) { this.createdAt = createdAt; }
}
