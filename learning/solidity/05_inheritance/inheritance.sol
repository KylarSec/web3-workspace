// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract A {
    function value() public pure virtual returns (uint) {
        return 5;
    }

    function getDouble() public pure returns (uint) {
        return value() * 2;
    }
}

contract B is A {
    function value() public pure override returns (uint) {
        return 10;
    }
}
