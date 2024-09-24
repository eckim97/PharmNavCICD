package com.example.phamnav;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.data.jpa.repository.config.EnableJpaAuditing;

@EnableJpaAuditing
@SpringBootApplication
public class PhamNavApplication {

    public static void main(String[] args) {
        SpringApplication.run(PhamNavApplication.class, args);
    }

}
