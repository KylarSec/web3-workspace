// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract BankSystem {

    // Define a custom data type "Account"
    struct Account {
        uint256 accountNumber; // unique ID for the account
        string name; // Account holder's name
        uint256 balance; // Current balance of the account
    }

    // Mapping: accountNumber → Account struct
    // Public automatically creates a getter to read account from outside
    mapping(uint256 => Account) public accounts;

    // Create or update an account
    function createAccount(
        uint256 _accountNumber, // Account ID (KEY)
        string calldata _name,  // Account holder's name (read-only input)
        uint256 _initialBalance // Starting Balance
    ) 
        public 
    {
        // Store a new Account struct in the mapping using _accountNumber as key
        accounts[_accountNumber] = Account(_accountNumber, _name, _initialBalance);
        // If the key already exists, it will overwrite the old account
    }

    // Deposit to an account
    function deposit(uint256 _accountNumber, uint256 _amount) public {
        // Access the account by its key and increase the balance
        accounts[_accountNumber].balance += _amount;
    }

    // Withdraw from an account
    function withdraw(uint256 _accountNumber, uint256 _amount) public {
        // Check if the account has enough balance
        require(accounts[_accountNumber].balance >= _amount, "Insufficient funds");
        // Subtract the withdrawal amount from the account balance
        accounts[_accountNumber].balance -= _amount;
    }

    // Get account info
    function getAccount(uint256 _accountNumber) public view returns (Account memory) // Returns a copy of the struct 
    {
        // Return the full Account struct for the given accountNumber
        return accounts[_accountNumber];
    }
}
