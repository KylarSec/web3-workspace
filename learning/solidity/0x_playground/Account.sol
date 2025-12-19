// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract WithdrawTest {

    address public owner;

    constructor() {
        owner = msg.sender;
    }
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

    // Withdraw user all balance
    function withdrawAll() external {
        Account storage acc = accounts[msg.sender];

        require(acc.exists, "No account");
        require(acc.balance > 0, "Account Drained.");

        uint256 amount = acc.balance;
        
        ToatalBalanceinWei = ToatalBalanceinWei - amount;

        (bool success, )= payable(msg.sender).call{value: amount}("");
        require(success, "Call Failed");
    }

    function balance() public view returns (uint256) {
        return ToatalBalanceinWei / 1e18;
    }



    // Withdraw all funds in contract while resetting the Account data.
    function WithdrawAllFund() external {
        
        require(msg.sender == owner, "Only Owner");

        uint256 amount = address(this).balance;

        for (uint256 funderIndex = 0; funderIndex < Funders.length; funderIndex++) 
        {
            address funder = Funders[funderIndex];
            delete accounts[funder];
        }


        (bool success, )= payable(msg.sender).call{value: amount}("");
        require(success, "Transfer Failed.");


        ToatalBalanceinWei = 0;
        Funders = new address[](0);




    }
}
