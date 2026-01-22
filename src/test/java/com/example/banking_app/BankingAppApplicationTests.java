package com.example.banking_app;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

class BankServiceTest {

    private final BankService bankService = new BankServiceImpl();

    @Test
    void testCreateAccount() {
        BankAccount account = bankService.createAccount("123456", 1000.0);

        assertNotNull(account);
        assertEquals("123456", account.getAccountNumber());
        assertEquals(1000.0, bankService.getBalance(account), 0.01);
    }

    @Test
    void testDepositThroughService() {
        BankAccount account = bankService.createAccount("123456", 1000.0);
        bankService.deposit(account, 500.0);

        assertEquals(1500.0, bankService.getBalance(account), 0.01);
    }

    @Test
    void testCreateAccountWithNegativeBalance() {
        assertThrows(IllegalArgumentException.class, () -> {
            bankService.createAccount("123456", -100.0);
        });
    }
}
