package com.fitbizz.controller;

import com.fitbizz.security.JwtTokenProvider;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.ZonedDateTime;
import java.util.*;

@RestController
@RequestMapping("/api/v1/super-admin")
@CrossOrigin(origins = "*")
public class SuperAdminController {

    private final JwtTokenProvider tokenProvider;
    private final List<Map<String, Object>> onboardedGyms = new ArrayList<>();

    public SuperAdminController(JwtTokenProvider tokenProvider) {
        this.tokenProvider = tokenProvider;

        // Initial seed data
        Map<String, Object> demoGym = new HashMap<>();
        demoGym.put("id", "gym-101");
        demoGym.put("name", "Pulse Fitness Club");
        demoGym.put("code", "PULSE-PK");
        demoGym.put("gymLogoUrl", "https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=150&auto=format&fit=crop&q=80");
        demoGym.put("ownerName", "Zain Malik");
        demoGym.put("ownerEmail", "zain@pulsefitness.com");
        demoGym.put("ownerPhone", "+92 304 9057852");
        demoGym.put("ownerPhotoUrl", "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150&auto=format&fit=crop&q=80");
        demoGym.put("country", "Pakistan");
        demoGym.put("city", "Lahore");
        demoGym.put("branchesCount", 3);
        demoGym.put("membersCount", 840);
        demoGym.put("planName", "PRO (Enterprise)");
        demoGym.put("status", "ACTIVE");
        demoGym.put("createdAt", ZonedDateTime.now().minusDays(3).toString());
        onboardedGyms.add(demoGym);

        Map<String, Object> demoGym2 = new HashMap<>();
        demoGym2.put("id", "gym-102");
        demoGym2.put("name", "Iron Athletics Gym");
        demoGym2.put("code", "IRON-ATH");
        demoGym2.put("gymLogoUrl", "https://images.unsplash.com/photo-1571902943202-507ec2618e8f?w=150&auto=format&fit=crop&q=80");
        demoGym2.put("ownerName", "Hamza Tariq");
        demoGym2.put("ownerEmail", "hamza@ironathletics.com");
        demoGym2.put("ownerPhone", "+92 300 9876543");
        demoGym2.put("ownerPhotoUrl", "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&auto=format&fit=crop&q=80");
        demoGym2.put("country", "Pakistan");
        demoGym2.put("city", "Lahore");
        demoGym2.put("branchesCount", 1);
        demoGym2.put("membersCount", 220);
        demoGym2.put("planName", "BASIC");
        demoGym2.put("status", "ACTIVE");
        demoGym2.put("createdAt", ZonedDateTime.now().minusDays(5).toString());
        onboardedGyms.add(demoGym2);
    }

    @PostMapping("/login")
    public ResponseEntity<Map<String, Object>> login(@RequestBody Map<String, String> body) {
        String email = body.get("email");

        Map<String, Object> response = new HashMap<>();
        if (email != null && !email.isBlank()) {
            String token = tokenProvider.generateToken(
                    "superadmin-zain", "platform-master", "headquarters", "SUPER_ADMIN", email
            );
            response.put("status", "SUCCESS");
            response.put("token", token);
            response.put("email", email);
            response.put("role", "SUPER_ADMIN");
            return ResponseEntity.ok(response);
        }

        response.put("status", "ERROR");
        response.put("message", "Invalid authentication credentials.");
        return ResponseEntity.status(401).body(response);
    }

    @GetMapping("/gyms")
    public ResponseEntity<List<Map<String, Object>>> getGyms() {
        return ResponseEntity.ok(onboardedGyms);
    }

    @GetMapping("/gyms/{id}")
    public ResponseEntity<Map<String, Object>> getGymById(@PathVariable("id") String id) {
        Optional<Map<String, Object>> gym = onboardedGyms.stream()
                .filter(g -> id.equals(g.get("id")))
                .findFirst();

        if (gym.isPresent()) {
            return ResponseEntity.ok(gym.get());
        }

        Map<String, Object> fallback = new HashMap<>();
        fallback.put("id", id);
        fallback.put("name", "Gym " + id);
        fallback.put("status", "ACTIVE");
        fallback.put("planName", "PRO");
        fallback.put("gymLogoUrl", "https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=150&auto=format&fit=crop&q=80");
        fallback.put("ownerPhotoUrl", "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150&auto=format&fit=crop&q=80");
        return ResponseEntity.ok(fallback);
    }

    @PostMapping("/gyms")
    public ResponseEntity<Map<String, Object>> createGym(@RequestBody Map<String, Object> body) {
        String gymId = "gym-" + (100 + onboardedGyms.size() + 1);

        Map<String, Object> record = new HashMap<>();
        record.put("id", gymId);
        record.put("name", body.getOrDefault("name", "New Fitness Business"));
        record.put("code", "GYM-" + gymId.substring(4));
        record.put("gymLogoUrl", body.getOrDefault("gymLogoUrl", body.getOrDefault("logoUrl", "")));
        record.put("status", "ACTIVE");
        record.put("country", body.getOrDefault("country", "Pakistan"));
        record.put("city", body.getOrDefault("city", "Lahore"));
        record.put("branchesCount", 1);
        record.put("membersCount", 0);
        record.put("planName", "PRO");
        record.put("createdAt", ZonedDateTime.now().toString());

        if (body.get("owner") instanceof Map<?, ?> owner) {
            Object ownerName = owner.get("name");
            Object ownerEmail = owner.get("email");
            Object ownerPhone = owner.get("phone");
            Object ownerPhoto = owner.get("ownerPhotoUrl");
            if (ownerPhoto == null) ownerPhoto = owner.get("photoUrl");
            record.put("ownerName", ownerName != null ? ownerName : "Owner Account");
            record.put("ownerEmail", ownerEmail != null ? ownerEmail : "owner@gym.com");
            record.put("ownerPhone", ownerPhone != null ? ownerPhone : "N/A");
            record.put("ownerPhotoUrl", ownerPhoto != null ? ownerPhoto : "");
        } else {
            record.put("ownerName", "Owner Account");
            record.put("ownerEmail", "owner@gym.com");
            record.put("ownerPhotoUrl", body.getOrDefault("ownerPhotoUrl", ""));
        }

        onboardedGyms.add(0, record);

        Map<String, Object> response = new HashMap<>();
        response.put("status", "SUCCESS");
        response.put("message", "Gym Tenant successfully provisioned.");
        response.put("gymId", gymId);
        response.put("data", record);

        return ResponseEntity.ok(response);
    }
}
