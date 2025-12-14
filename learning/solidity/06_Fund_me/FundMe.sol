// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

// Import Chainlink price feed interface
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

/*
 * FundMe contract
 * Users will be able to fund this contract with ETH.
 * A minimum contribution in USD will be enforced later
 * using Chainlink price feeds.
 */
contract FundMe {
    // declares a variable that will hold the address of a Chainlink price feed contract.
    AggregatorV3Interface internal dataFeed;

    /**
     * Network: Sepolia
     * Aggregator: ETH/USD
     * Address: 0x694AA1769357215DE4FAC081bf1f309aDC325306
     */
    // Connect to Chainlink price feed when contract is deployed
    constructor() {
        dataFeed = AggregatorV3Interface(
            0x694AA1769357215DE4FAC081bf1f309aDC325306
        );
    }

    // Minimum funding amount expressed in USD (not enforced yet)
    uint256 public minimumUsd = 5;

    /*
     * Allows users to send ETH to the contract.
     * NOTE: Currently this check compares wei to a plain number.
     * USD conversion logic will be added in a later step.
     */
    function fund() public payable {
        require(msg.value >= minimumUsd, "Didn't send enough ETH.");
    }

    // Withdraw ETH (to be implemented later)
    function withdraw() public {}

    // Get latest ETH/USD price from Chainlink
    function getPrice() public view returns (int256) {
        (, int256 answer, , , ) = dataFeed.latestRoundData();
        return answer;
    }

    // Check price feed version
    function getVersion() public view returns (uint256) {
        return dataFeed.version();
    }
}
