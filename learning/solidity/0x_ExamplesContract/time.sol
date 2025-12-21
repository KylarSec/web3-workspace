
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract TimestampExample {
    uint256 public deploymentTimestamp;

    constructor() {
        deploymentTimestamp = block.timestamp;
    }

    function hasTimePassed(uint256 secondsPassed) public view returns (bool) {
        uint256 currentTimestamp = block.timestamp;
        return currentTimestamp >= deploymentTimestamp + secondsPassed;
    }
}