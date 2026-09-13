package com.fitbizz.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.lang.management.ManagementFactory;
import java.time.Instant;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/v1/health")
public class HealthController {

    private final long startTime = System.currentTimeMillis();

    @GetMapping
    public ResponseEntity<Map<String, Object>> checkHealth() {
        Map<String, Object> response = new HashMap<>();
        long uptimeSeconds = (System.currentTimeMillis() - startTime) / 1000;

        response.put("status", "UP");
        response.put("service", "FitBizz Cloud Core Multi-Tenant Backend");
        response.put("version", "2.0.0-PROD");
        response.put("timestamp", Instant.now().toString());
        response.put("uptimeSeconds", uptimeSeconds);
        response.put("jvmUptimeMs", ManagementFactory.getRuntimeMXBean().getUptime());
        response.put("message", "24/7 Cluster Heartbeat Operational");

        return ResponseEntity.ok(response);
    }
}
