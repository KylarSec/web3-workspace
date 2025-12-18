// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract WithdrawTest {
    // Variable to store ToatalBalanceinWei
    uint256 internal ToatalBalanceinWei;

    struct Account {
        string name;
        uint256 balance; // in Wei
        bool exists;
    }

    // Optional: track funders for iteration
    address[] public Funders;

    // Maps user address --> Account struct
    mapping(address => Account) private accounts;

    // Function to Fund the Contract
    function fund(string calldata _name) external payable {
        require(msg.value > 0, "Enter Amount");

        /*
         * Solidity can’t directly check if a string is empty.
         * So we:
         * convert string → bytes
         * check length
         */
        require(bytes(_name).length > 0, "Name Required");

        Account storage acc = accounts[msg.sender];

        // If this is the first time this user funds
        if (!acc.exists) {
            acc.name = _name;
            acc.exists = true;
            Funders.push(msg.sender);
        }

        // Update balance of funder Account
        acc.balance += msg.value;

        // Update TotalBalance on each fund.
        ToatalBalanceinWei += msg.value;

        //Put funders to list
        Funders.push(msg.sender);
    }

    // Withdraw user’s own balance
    function Withdraw(uint256 amountinWei) external {
        Account storage acc = accounts[msg.sender];
        require(acc.exists, "No account");
        require(acc.balance >= amountinWei, "Insufficient balance");

        acc.balance -= amountinWei;
        ToatalBalanceinWei -= amountinWei;
        payable(msg.sender).transfer(amountinWei);
    }

    function withdrawAll() external {
        ToatalBalanceinWei = 0;
        payable(msg.sender).transfer(address(this).balance);
    }

    function balance() public view returns (uint256) {
        return ToatalBalanceinWei / 1e18;
    }
}
