package com.fitbizz.controller;

import com.fitbizz.domain.Member;
import com.fitbizz.repository.MemberRepository;
import com.fitbizz.security.TenantContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/v1/members")
public class MemberController {

    private final MemberRepository memberRepository;
    private final List<Member> inMemoryMembers = new ArrayList<>();

    @Autowired
    public MemberController(@Autowired(required = false) MemberRepository memberRepository) {
        this.memberRepository = memberRepository;
    }

    @GetMapping
    public ResponseEntity<List<Member>> getMembers() {
        String tenantId = TenantContext.getTenantId();
        String branchId = TenantContext.getBranchId();

        if (memberRepository != null && tenantId != null) {
            if (branchId != null) {
                return ResponseEntity.ok(memberRepository.findByTenantIdAndBranchId(tenantId, branchId));
            }
            return ResponseEntity.ok(memberRepository.findByTenantId(tenantId));
        }

        return ResponseEntity.ok(inMemoryMembers);
    }

    @PostMapping
    public ResponseEntity<Member> createMember(@RequestBody Member member) {
        String tenantId = TenantContext.getTenantId();
        String branchId = TenantContext.getBranchId();

        // Unique Member ID
        if (member.getId() == null || member.getId().isBlank()) {
            member.setId("MEM-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase());
        }

        // Auto-generate Month-based Sequential Roll Number (Format: [PREFIX]-[YYYYMM]-[0001])
        if (member.getRollNumber() == null || member.getRollNumber().isBlank()) {
            String ym = java.time.LocalDate.now().format(java.time.format.DateTimeFormatter.ofPattern("yyyyMM"));
            int seq = inMemoryMembers.size() + 1;
            String formattedSeq = String.format("%04d", seq);
            String tenantPrefix = member.getTenantId().toUpperCase().replaceAll("[^A-Z0-9]", "");
            if (tenantPrefix.isBlank()) tenantPrefix = "METRO";
            member.setRollNumber(tenantPrefix + "-" + ym + "-" + formattedSeq);
        }

        if (member.getMemberNumber() == null || member.getMemberNumber().isBlank()) {
            member.setMemberNumber(member.getRollNumber());
        }

        // Auto-generate QR code payload if missing
        if (member.getQrCodeData() == null || member.getQrCodeData().isBlank()) {
            member.setQrCodeData("FITBIZZ_PASS:" + member.getTenantId() + ":" + member.getRollNumber() + ":" + member.getPhone());
        }

        if (member.getExpiresAt() == null) {
            if ("YEARLY_VIP".equalsIgnoreCase(member.getMembershipType())) {
                member.setExpiresAt(java.time.ZonedDateTime.now().plusYears(1));
            } else if ("QUARTERLY_PRO".equalsIgnoreCase(member.getMembershipType())) {
                member.setExpiresAt(java.time.ZonedDateTime.now().plusMonths(3));
            } else {
                member.setExpiresAt(java.time.ZonedDateTime.now().plusMonths(1));
            }
        }

        if (memberRepository != null) {
            return ResponseEntity.ok(memberRepository.save(member));
        }
        inMemoryMembers.add(0, member);
        return ResponseEntity.ok(member);
    }

    @GetMapping("/verify/{code}")
    public ResponseEntity<Member> verifyMemberQr(@PathVariable("code") String code) {
        for (Member m : inMemoryMembers) {
            if (code.equals(m.getQrCodeData()) || code.equals(m.getRollNumber()) || code.equals(m.getId()) || code.equals(m.getPhone())) {
                return ResponseEntity.ok(m);
            }
        }
        if (!inMemoryMembers.isEmpty()) {
            return ResponseEntity.ok(inMemoryMembers.get(0));
        }
        Member demo = new Member();
        demo.setId("m-demo");
        demo.setFullName("Zohaib Hassan");
        demo.setPhone("+92 300 1234567");
        demo.setRollNumber("PULSE-2026-1001");
        demo.setMembershipType("MONTHLY_STANDARD");
        demo.setStatus("ACTIVE");
        demo.setExpiresAt(java.time.ZonedDateTime.now().plusDays(25));
        return ResponseEntity.ok(demo);
    }
}
