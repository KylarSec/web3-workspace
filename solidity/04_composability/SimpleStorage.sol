// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract SimpleStorage {

    // State variable to store favourite Number
    uint256 public favoriteNumber;

    // Function to take a number and store it.
    function store(uint256 _num) public virtual {
        favoriteNumber = _num;
    }
    // Function to retrieve fav number from storage.
    function retrieve() public view returns(uint256) {
        return favoriteNumber;
    }
}

// Few more contracts to explain that Storage Factory is only working with one contract.
contract SimpleStorage2{}
contract SimpleStorage3{}
contract SimpleStorage4{}