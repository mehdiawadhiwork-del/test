package com.example.banking_app;

import org.springframework.stereotype.Service;

@Service
public class BankServiceImpl implements BankService {

    @Override
    public BankAccount createAccount(String accountNumber, double initialBalance) {
        if (initialBalance < 0) {
            throw new IllegalArgumentException("Le solde initial ne peut pas être négatif");
        }
        return new BankAccount(accountNumber, initialBalance);
    }

    @Override
    public void deposit(BankAccount account, double amount) {
        account.deposit(amount);
    }

    @Override
    public void withdraw(BankAccount account, double amount) {
        account.withdraw(amount);
    }

    @Override
    public double getBalance(BankAccount account) {
        return account.getBalance();
    }
}