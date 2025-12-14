// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

// A contract that gets latest BTC Price in ETH

// 0x5fb1616F78dA7aFC9FF79e0371741a747D2a7F22

// Import Chainlink price feed interface
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract LatestPrice {
    // declares a variable that will hold the address of a Chainlink price feed contract.
    AggregatorV3Interface internal PriceFeed;

    // Connect to Chainlink price feed when contract is deployed
    constructor() {
        PriceFeed = AggregatorV3Interface(
            0x5fb1616F78dA7aFC9FF79e0371741a747D2a7F22
        );
    }

    // function that retrieves the latest BTC price in ETH.
    function getLatestBTCPriceInETH() public view returns (uint256) {
        (, int answer, , ,) = PriceFeed.latestRoundData();
        // Ensure the price is positive before converting to uint
        require(answer > 0, "Invalid Price");
        return uint(answer);
    }

    // A function to check decimal value
    function getDecimalValue() public view returns (uint256) {
        return PriceFeed.decimals();
    }
}
