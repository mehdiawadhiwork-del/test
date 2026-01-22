package com.example.banking_app;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class BankController {

    @GetMapping("/health")
    public String health() {
        return "UP";
    }
}
