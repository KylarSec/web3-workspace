// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

library SafeMath {
    function add(uint a, uint b) public pure returns (uint) {
        require(a + b >= a, "SafeMath: Addition Overflow");
        return a + b;
    }
}