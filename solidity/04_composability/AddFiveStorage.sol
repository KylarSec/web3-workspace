// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {SimpleStorage} from "./SimpleStorage.sol";

// This contract INHERITS from SimpleStorage.
contract AddFiveStorage is SimpleStorage {

    // Override the parent store() function
    function store(uint256 _num) public override {
        // Save the number but add 5 before storing
        favoriteNumber = _num + 5;
    }
}
