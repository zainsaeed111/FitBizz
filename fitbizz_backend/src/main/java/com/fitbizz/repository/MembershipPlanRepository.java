package com.fitbizz.repository;

import com.fitbizz.domain.MembershipPlan;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface MembershipPlanRepository extends JpaRepository<MembershipPlan, String> {
    List<MembershipPlan> findByTenantId(String tenantId);
    List<MembershipPlan> findByTenantIdAndStatus(String tenantId, String status);
}
