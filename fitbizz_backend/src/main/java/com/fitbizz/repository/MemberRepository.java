package com.fitbizz.repository;

import com.fitbizz.domain.Member;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface MemberRepository extends JpaRepository<Member, String> {
    List<Member> findByTenantId(String tenantId);
    List<Member> findByTenantIdAndBranchId(String tenantId, String branchId);
    Optional<Member> findByTenantIdAndMemberNumber(String tenantId, String memberNumber);
}
