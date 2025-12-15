// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

// Import Chainlink price feed interface
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

/*
 * FundMe contract
 * - Users send ETH
 * - Contract checks ETH value in USD
 * - Uses Chainlink to get ETH/USD price
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

    // Minimum funding amount in USD
    // Scaled to 18 decimals so it matches ETH math
    uint256 public minimumUSD = 5 * 1e18;

    // An array to keep the addresses
    address[] public funders;

    // A mapping to check amount by addresess
    mapping(address => uint256) public addressToFundedAmount;

    // Mapping to monitor how many times a user calls the fund() function.
    mapping(address => uint256) contributionCount;

    /*
     * Allows users to send ETH to the contract
     * - msg.value is the ETH amount sent (wei, 18 decimals)
     * - We convert ETH to USD and check if it meets minimumUSD
     */
    function fund() public payable {
        require(
            getConversionRate(msg.value) >= minimumUSD,
            "Didn't send enough ETH."
        );

        // add addresses to the array who sends money to the contract.
        // The msg.sender global variable refers to the address that initiates the transaction.
        funders.push(msg.sender);

        /*
         * Mapping associates each funder's address with the total amount they have contributed.
         * When a new amount is sent, we can add it to the user's total contribution
         */
        addressToFundedAmount[msg.sender] += msg.value;

        // Count everytime a user funds
        contributionCount[msg.sender] += 1;
    }

    // Withdraw ETH (to be implemented later)
    function withdraw() public {}

    /*
     * Reads ETH/USD price from Chainlink
     * - Chainlink returns price with 8 decimals
     * - We convert it to 18 decimals so it matches ETH math
     */
    function getPrice() public view returns (uint256) {
        // Call Chainlink price feed
        (, int256 answer, , , ) = dataFeed.latestRoundData();

        // Ensure the price is positive before converting to uint
        require(answer > 0, "Invalid Price");

        // Convert price from 8 decimals to 18 decimals
        return uint(answer) * 1e10;
    }

    /*
     * Converts ETH amount to USD value
     * - ethAmount is usually msg.value
     * - Returns USD value with 18 decimals
     */
    function getConversionRate(
        uint256 ethAmount
    ) internal view returns (uint256) {
        // ETH price in USD (18 decimals)
        uint256 ethPrice = getPrice();

        // ETH --> USD conversion
        uint256 ethAmountinUsd = (ethPrice * ethAmount) / 1e18;

        return ethAmountinUsd;
    }

    /*
     * Converts a USD amount into ETH
     * - USDAmount: USD value with 18 decimals
     * - Returns ETH amount with 18 decimals
     */
    function convertUSDtoETH(uint256 USDAmount) public view returns (uint256) {
        // Get price of 1 ETH in USD (18 decimals)
        uint256 ETHPrice = getPrice();

        // USD -> ETH conversion
        // Multiply first to keep precision
        return (USDAmount * 1e18) / ETHPrice;
    }

    // Returns the version of the Chainlink price feed
    // Used only to confirm correct connection
    function getVersion() public view returns (uint256) {
        return dataFeed.version();
    }

    // function to check decimal value
    function getDecimalValue() public view returns (uint256) {
        return dataFeed.decimals();
    }
}
