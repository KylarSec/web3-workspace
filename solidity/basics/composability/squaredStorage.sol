// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {SimpleStorage} from "./SimpleStorage.sol";

// a contract that overrides the store function to return square of favnumber.
// This contract INHERITS from SimpleStorage.
contract squared is SimpleStorage {

    // Override the parent store() function
    function store(uint256 _num) public override {
        // Save the square of the number instead of the number itself
        favoriteNumber = _num * _num;
    }
}