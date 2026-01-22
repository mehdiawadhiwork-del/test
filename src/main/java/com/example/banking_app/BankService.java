package com.example.banking_app;

public interface BankService {
    BankAccount createAccount(String accountNumber, double initialBalance);
    void deposit(BankAccount account, double amount);
    void withdraw(BankAccount account, double amount);
    double getBalance(BankAccount account);

}