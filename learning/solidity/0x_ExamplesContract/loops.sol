// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract Loop {
    uint256[] public numbers;

    function pushNumbers() public {
        for (uint256 i = 1; i <= 10; i++) {
            numbers.push(i);
        }
    }
}


// Lessons Learned :- A contract name can't be same as function name.


