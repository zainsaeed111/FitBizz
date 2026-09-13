package com.fitbizz.controller;

import com.fitbizz.security.TenantContext;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/v1/sync")
public class SyncController {

    @PostMapping("/push")
    public ResponseEntity<Map<String, Object>> pushOfflineMutations(@RequestBody List<Map<String, Object>> mutations) {
        String tenantId = TenantContext.getTenantId();
        Map<String, Object> response = new HashMap<>();
        response.put("tenantId", tenantId);
        response.put("processedCount", mutations != null ? mutations.size() : 0);
        response.put("status", "SUCCESS");
        return ResponseEntity.ok(response);
    }

    @GetMapping("/pull")
    public ResponseEntity<Map<String, Object>> pullUpdates(@RequestParam(required = false) Long sinceTimestamp) {
        String tenantId = TenantContext.getTenantId();
        Map<String, Object> response = new HashMap<>();
        response.put("tenantId", tenantId);
        response.put("serverTimestamp", System.currentTimeMillis());
        response.put("members", List.of());
        response.put("attendance", List.of());
        return ResponseEntity.ok(response);
    }
}
