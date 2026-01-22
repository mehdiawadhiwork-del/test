package com.example.banking_app;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

class BankAccountTest {

    @Test
    void testCreateAccount() {
        BankAccount account = new BankAccount("123456", 1000.0);

        assertEquals("123456", account.getAccountNumber());
        assertEquals(1000.0, account.getBalance(), 0.01);
    }

    @Test
    void testDeposit() {
        BankAccount account = new BankAccount("123456", 1000.0);
        account.deposit(500.0);

        assertEquals(1500.0, account.getBalance(), 0.01);
    }

    @Test
    void testWithdraw() {
        BankAccount account = new BankAccount("123456", 1000.0);
        account.withdraw(300.0);

        assertEquals(700.0, account.getBalance(), 0.01);
    }

    @Test
    void testDepositNegativeAmount() {
        BankAccount account = new BankAccount("123456", 1000.0);

        assertThrows(IllegalArgumentException.class, () -> {
            account.deposit(-100.0);
        });
    }

    @Test
    void testWithdrawInsufficientFunds() {
        BankAccount account = new BankAccount("123456", 1000.0);

        assertThrows(IllegalArgumentException.class, () -> {
            account.withdraw(1500.0);
        });
    }
}