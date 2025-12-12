// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

contract mappingLesson {

    struct Account {
        uint256 accountNumber;
        string name;
        uint256 balance;
    }

    mapping(uint256 => Account) public AccNumberToBalance;

    function addData(
        uint256 _accountNumber,
        string calldata _name,
        uint256 _balance
        ) 
        public 
        
        {
        AccNumberToBalance[_accountNumber] = Account(_accountNumber, _name, _balance);
    }

    function CheckBalance(uint256 _accountNumber)
        public view returns(uint256) {
            return AccNumberToBalance[_accountNumber].balance;
        }
}