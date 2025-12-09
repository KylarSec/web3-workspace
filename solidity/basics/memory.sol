// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

contract MemoryKeywords {

    // This is storage variable (Lives on BlockChain)
    string public PersonName;

    // Storage Example
    function WritetoStorage(string memory name) public {
        PersonName = name;
    }

    // Memory Example
    function getPersonName() public view returns(string memory) {
        string memory temp = PersonName;
        return temp;
    }

    // Calldata example
    function setNameFromUser(string calldata userInput) external { 
        PersonName = userInput; // calldata → storage 
    }

}