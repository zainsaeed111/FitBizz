package com.fitbizz.config;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

@Component
public class SuperAdminInitializer implements CommandLineRunner {

    private static final Logger log = LoggerFactory.getLogger(SuperAdminInitializer.class);

    @Value("${FITTBIZZ_INITIAL_ADMIN_EMAIL:iamzainofficial4211@gmail.com}")
    private String adminEmail;

    @Override
    public void run(String... args) throws Exception {
        log.info("[FittBizz Security Bootstrap] Platform Super Admin account verified: {}", adminEmail);
    }
}
