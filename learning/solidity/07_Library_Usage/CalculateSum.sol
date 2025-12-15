// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

/*
 * This Contract will call library Directly without using X for y
*/

// Import the "MathLibrary" Library
import {MathLibrary} from "./MathLibrary.sol";

contract Calculate {

    // Function to add two numbers by calling sum function from libray.
    function calculateSum(uint256 _a , uint256 _b) public pure returns (uint256) {
        return MathLibrary.sum(_a, _b);
    }
}