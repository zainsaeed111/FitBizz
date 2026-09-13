package com.fitbizz.controller;

import com.fitbizz.domain.Invoice;
import com.fitbizz.security.TenantContext;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.time.ZonedDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/v1/invoices")
public class InvoiceController {

    private final List<Invoice> inMemoryInvoices = new ArrayList<>();

    public InvoiceController() {
        // Seed initial sample invoice for tenant billing demonstration
        Invoice seed = new Invoice();
        seed.setId("inv_001");
        seed.setTenantId("tenant-001");
        seed.setBranchId("branch-001");
        seed.setInvoiceNumber("INV-2026-001");
        seed.setMemberId("mem_001");
        seed.setAmount(new BigDecimal("99.00"));
        seed.setTax(new BigDecimal("9.90"));
        seed.setStatus("PAID");
        seed.setPaymentMethod("CREDIT_CARD");
        seed.setDueDate(ZonedDateTime.now().plusDays(30));
        inMemoryInvoices.add(seed);
    }

    @GetMapping
    public ResponseEntity<List<Invoice>> getInvoices() {
        return ResponseEntity.ok(inMemoryInvoices);
    }

    @PostMapping
    public ResponseEntity<Invoice> createInvoice(@RequestBody Invoice invoice) {
        String tenantId = TenantContext.getTenantId();
        String branchId = TenantContext.getBranchId();

        if (invoice.getId() == null) {
            invoice.setId(UUID.randomUUID().toString());
        }
        invoice.setTenantId(tenantId != null ? tenantId : "tenant-001");
        if (invoice.getBranchId() == null) {
            invoice.setBranchId(branchId != null ? branchId : "branch-001");
        }
        if (invoice.getInvoiceNumber() == null) {
            invoice.setInvoiceNumber("INV-2026-" + (inMemoryInvoices.size() + 101));
        }

        inMemoryInvoices.add(0, invoice);
        return ResponseEntity.ok(invoice);
    }
}
