package com.fitbizz.repository;

import com.fitbizz.domain.AttendanceRecord;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface AttendanceRecordRepository extends JpaRepository<AttendanceRecord, String> {
    List<AttendanceRecord> findByTenantIdAndBranchId(String tenantId, String branchId);
    List<AttendanceRecord> findByTenantIdAndMemberId(String tenantId, String memberId);
}
