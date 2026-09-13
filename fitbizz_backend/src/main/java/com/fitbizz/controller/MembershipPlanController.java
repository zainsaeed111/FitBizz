package com.fitbizz.controller;

import com.fitbizz.domain.MembershipPlan;
import com.fitbizz.repository.MembershipPlanRepository;
import com.fitbizz.security.TenantContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@RestController
@RequestMapping("/api/v1/plans")
public class MembershipPlanController {

    private final MembershipPlanRepository planRepository;
    private final List<MembershipPlan> inMemoryPlans = new ArrayList<>();

    @Autowired
    public MembershipPlanController(@Autowired(required = false) MembershipPlanRepository planRepository) {
        this.planRepository = planRepository;
        initDefaultPlans();
    }

    private void initDefaultPlans() {
        if (inMemoryPlans.isEmpty()) {
            // 1. Basic Plan
            MembershipPlan basic = new MembershipPlan();
            basic.setId("plan_basic");
            basic.setTenantId("tenant-001");
            basic.setName("Basic Plan");
            basic.setDurationMonths(1);
            basic.setDurationDays(30);
            basic.setAdmissionFee(BigDecimal.valueOf(1000.0));
            basic.setMonthlyFee(BigDecimal.valueOf(3500.0));
            basic.setAdditionalCharges(BigDecimal.ZERO);
            basic.setPrice(BigDecimal.valueOf(4500.0));
            basic.setCurrency("PKR");
            basic.setHasTrainerSupport(false);
            basic.setHasMealPlan(false);
            basic.setHasMobileApp(true);
            basic.setHasLockerAccess(true);
            basic.setIsMultiBranch(false);
            basic.setIsDefault(true);
            basic.setBadge("Default");
            basic.setStatus("ACTIVE");
            inMemoryPlans.add(basic);

            // 2. Silver Plan
            MembershipPlan silver = new MembershipPlan();
            silver.setId("plan_silver");
            silver.setTenantId("tenant-001");
            silver.setName("Silver Plan");
            silver.setDurationMonths(1);
            silver.setDurationDays(30);
            silver.setAdmissionFee(BigDecimal.valueOf(1500.0));
            silver.setMonthlyFee(BigDecimal.valueOf(5500.0));
            silver.setAdditionalCharges(BigDecimal.ZERO);
            silver.setPrice(BigDecimal.valueOf(7000.0));
            silver.setCurrency("PKR");
            silver.setHasTrainerSupport(true);
            silver.setTrainerSupportNote("Beginner Workout Coaching (First 2 Weeks)");
            silver.setHasMealPlan(true);
            silver.setHasMobileApp(true);
            silver.setHasLockerAccess(true);
            silver.setIsMultiBranch(false);
            silver.setIsDefault(false);
            silver.setBadge("Popular");
            silver.setStatus("ACTIVE");
            inMemoryPlans.add(silver);

            // 3. Gold VIP Plan
            MembershipPlan gold = new MembershipPlan();
            gold.setId("plan_gold");
            gold.setTenantId("tenant-001");
            gold.setName("Gold VIP Plan");
            gold.setDurationMonths(1);
            gold.setDurationDays(30);
            gold.setAdmissionFee(BigDecimal.valueOf(2000.0));
            gold.setMonthlyFee(BigDecimal.valueOf(9500.0));
            gold.setAdditionalCharges(BigDecimal.ZERO);
            gold.setPrice(BigDecimal.valueOf(11500.0));
            gold.setCurrency("PKR");
            gold.setHasTrainerSupport(true);
            gold.setTrainerSupportNote("1-on-1 Dedicated Trainer Assistance");
            gold.setHasMealPlan(true);
            gold.setHasMobileApp(true);
            gold.setHasLockerAccess(true);
            gold.setIsMultiBranch(true);
            gold.setIsDefault(false);
            gold.setBadge("VIP All-Access");
            gold.setStatus("ACTIVE");
            inMemoryPlans.add(gold);
        }
    }

    @GetMapping
    public ResponseEntity<List<MembershipPlan>> getPlans() {
        String tenantId = TenantContext.getTenantId();
        if (planRepository != null && tenantId != null) {
            List<MembershipPlan> dbPlans = planRepository.findByTenantId(tenantId);
            if (!dbPlans.isEmpty()) {
                return ResponseEntity.ok(dbPlans);
            }
        }
        return ResponseEntity.ok(inMemoryPlans);
    }

    @PostMapping
    public ResponseEntity<MembershipPlan> createPlan(@RequestBody MembershipPlan plan) {
        String tenantId = TenantContext.getTenantId();
        if (plan.getId() == null || plan.getId().isBlank()) {
            plan.setId("plan_" + UUID.randomUUID().toString().substring(0, 8));
        }
        plan.setTenantId(tenantId != null ? tenantId : "tenant-001");
        if (plan.getStatus() == null) {
            plan.setStatus("ACTIVE");
        }

        // Auto calculate total initial price
        BigDecimal adm = plan.getAdmissionFee() != null ? plan.getAdmissionFee() : BigDecimal.ZERO;
        BigDecimal mth = plan.getMonthlyFee() != null ? plan.getMonthlyFee() : BigDecimal.ZERO;
        int dur = plan.getDurationMonths() != null ? plan.getDurationMonths() : 1;
        BigDecimal add = plan.getAdditionalCharges() != null ? plan.getAdditionalCharges() : BigDecimal.ZERO;
        plan.setPrice(adm.add(mth.multiply(BigDecimal.valueOf(dur))).add(add));

        if (Boolean.TRUE.equals(plan.getIsDefault())) {
            for (MembershipPlan p : inMemoryPlans) {
                p.setIsDefault(false);
            }
        }

        if (planRepository != null) {
            return ResponseEntity.ok(planRepository.save(plan));
        }
        inMemoryPlans.add(plan);
        return ResponseEntity.ok(plan);
    }

    @PutMapping("/{id}")
    public ResponseEntity<MembershipPlan> updatePlan(@PathVariable("id") String id, @RequestBody MembershipPlan updated) {
        MembershipPlan target = null;
        for (MembershipPlan p : inMemoryPlans) {
            if (p.getId().equals(id)) {
                target = p;
                break;
            }
        }

        if (target != null) {
            target.setName(updated.getName());
            target.setDurationMonths(updated.getDurationMonths());
            target.setDurationDays(updated.getDurationDays());
            target.setAdmissionFee(updated.getAdmissionFee());
            target.setMonthlyFee(updated.getMonthlyFee());
            target.setAdditionalCharges(updated.getAdditionalCharges());
            target.setPrice(updated.getPrice());
            target.setHasTrainerSupport(updated.getHasTrainerSupport());
            target.setTrainerSupportNote(updated.getTrainerSupportNote());
            target.setHasMealPlan(updated.getHasMealPlan());
            target.setHasMobileApp(updated.getHasMobileApp());
            target.setHasLockerAccess(updated.getHasLockerAccess());
            target.setIsMultiBranch(updated.getIsMultiBranch());
            target.setBadge(updated.getBadge());
            if (Boolean.TRUE.equals(updated.getIsDefault())) {
                for (MembershipPlan p : inMemoryPlans) {
                    p.setIsDefault(false);
                }
                target.setIsDefault(true);
            }
            return ResponseEntity.ok(target);
        }

        if (planRepository != null) {
            Optional<MembershipPlan> existing = planRepository.findById(id);
            if (existing.isPresent()) {
                MembershipPlan p = existing.get();
                p.setName(updated.getName());
                p.setDurationMonths(updated.getDurationMonths());
                p.setAdmissionFee(updated.getAdmissionFee());
                p.setMonthlyFee(updated.getMonthlyFee());
                p.setPrice(updated.getPrice());
                return ResponseEntity.ok(planRepository.save(p));
            }
        }

        return ResponseEntity.notFound().build();
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deletePlan(@PathVariable("id") String id) {
        inMemoryPlans.removeIf(p -> p.getId().equals(id));
        if (planRepository != null) {
            planRepository.deleteById(id);
        }
        return ResponseEntity.ok().build();
    }

    @PutMapping("/{id}/set-default")
    public ResponseEntity<MembershipPlan> setDefaultPlan(@PathVariable("id") String id) {
        MembershipPlan matched = null;
        for (MembershipPlan p : inMemoryPlans) {
            if (p.getId().equals(id)) {
                p.setIsDefault(true);
                matched = p;
            } else {
                p.setIsDefault(false);
            }
        }
        if (matched != null) {
            return ResponseEntity.ok(matched);
        }
        return ResponseEntity.notFound().build();
    }
}
