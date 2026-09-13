package com.fitbizz.controller;

import com.fitbizz.domain.AttendanceRecord;
import com.fitbizz.repository.AttendanceRecordRepository;
import com.fitbizz.security.TenantContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.ZonedDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/v1/attendance")
public class AttendanceController {

    private final AttendanceRecordRepository attendanceRepository;
    private final List<AttendanceRecord> inMemoryRecords = new ArrayList<>();

    @Autowired
    public AttendanceController(@Autowired(required = false) AttendanceRecordRepository attendanceRepository) {
        this.attendanceRepository = attendanceRepository;
    }

    @GetMapping
    public ResponseEntity<List<AttendanceRecord>> getAttendanceRecords() {
        String tenantId = TenantContext.getTenantId();
        String branchId = TenantContext.getBranchId();

        if (attendanceRepository != null && tenantId != null && branchId != null) {
            return ResponseEntity.ok(attendanceRepository.findByTenantIdAndBranchId(tenantId, branchId));
        }
        return ResponseEntity.ok(inMemoryRecords);
    }

    @PostMapping("/checkin")
    public ResponseEntity<AttendanceRecord> recordCheckIn(@RequestBody AttendanceRecord record) {
        String tenantId = TenantContext.getTenantId();
        String branchId = TenantContext.getBranchId();

        if (record.getId() == null) {
            record.setId(UUID.randomUUID().toString());
        }
        record.setTenantId(tenantId != null ? tenantId : "tenant-001");
        if (record.getBranchId() == null) {
            record.setBranchId(branchId != null ? branchId : "branch-001");
        }
        if (record.getCheckInAt() == null) {
            record.setCheckInAt(ZonedDateTime.now());
        }

        if (attendanceRepository != null) {
            return ResponseEntity.ok(attendanceRepository.save(record));
        }
        inMemoryRecords.add(0, record);
        return ResponseEntity.ok(record);
    }
}
