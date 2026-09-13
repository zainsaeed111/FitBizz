package com.fitbizz.config;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;

/**
 * 24/7 Cloud Heartbeat Service
 * Automatically pings the application's external URL every 10 minutes to keep
 * Render / Koyeb / Free Cloud hosting instances awake and alive 24/7 without sleep.
 */
@Component
public class HeartbeatKeeperService {

    private static final Logger log = LoggerFactory.getLogger(HeartbeatKeeperService.class);
    private final HttpClient httpClient;

    @Value("${RENDER_EXTERNAL_URL:${APP_URL:}}")
    private String externalAppUrl;

    public HeartbeatKeeperService() {
        this.httpClient = HttpClient.newBuilder()
                .connectTimeout(Duration.ofSeconds(10))
                .build();
    }

    // Runs every 10 minutes (600,000 ms) with a 1-minute initial delay after startup
    @Scheduled(fixedRate = 600000, initialDelay = 60000)
    public void executeHeartbeatPing() {
        if (externalAppUrl == null || externalAppUrl.trim().isEmpty()) {
            log.info("❤️ [24/7 Heartbeat] Local or standalone mode active. External URL not specified (set RENDER_EXTERNAL_URL or APP_URL).");
            return;
        }

        String targetUrl = externalAppUrl.trim();
        if (!targetUrl.startsWith("http://") && !targetUrl.startsWith("https://")) {
            targetUrl = "https://" + targetUrl;
        }
        if (!targetUrl.endsWith("/api/v1/health")) {
            targetUrl = targetUrl + "/api/v1/health";
        }

        try {
            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(targetUrl))
                    .timeout(Duration.ofSeconds(15))
                    .header("User-Agent", "FitBizz-24x7-Heartbeat-Keeper/2.0")
                    .GET()
                    .build();

            HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());
            if (response.statusCode() == 200) {
                log.info("🚀 [24/7 Heartbeat] Ping successful to {} (Status: 200 OK). Server instance is 100% active.", targetUrl);
            } else {
                log.warn("⚠️ [24/7 Heartbeat] Ping returned status code: {}", response.statusCode());
            }
        } catch (Exception e) {
            log.warn("⚠️ [24/7 Heartbeat] Error sending keep-alive ping: {}", e.getMessage());
        }
    }
}
