// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract CustomErrors {

    address immutable i_owner;

    constructor() {
        i_owner = msg.sender;
    }

    //custom error to check if msg.sender is address(0)
    error NoAddress();

    modifier ValidAddress {
        if (msg.sender == address(0)){
            revert NoAddress();
        }
        _;
    }
}