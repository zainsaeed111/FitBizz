package com.fitbizz;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication
@EnableScheduling
public class FitBizzBackendApplication {

    public static void main(String[] args) {
        SpringApplication.run(FitBizzBackendApplication.class, args);
    }
}
