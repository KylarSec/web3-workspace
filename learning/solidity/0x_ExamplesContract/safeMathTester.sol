// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import {SafeMath} from "./Safemath.sol";

contract SafeMathTester {

    function sum(uint a, uint b) public pure returns(uint) {
        return SafeMath.add(a, b);
    }
}