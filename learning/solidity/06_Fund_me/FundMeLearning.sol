// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

/**
 * @notice Learning / experimental contract.
 */

// Import Chainlink interface (used only for version / decimals checks)
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

// Import the PriceConverter Library
import {PriceConverter} from "./PriceConverter.sol";

/*
 * FundMe contract
 * - Accepts ETH from users
 * - Converts ETH value to USD using Chainlink
 * - Enforces a minimum USD amount
 */
contract FundMeLearning {
    // Any uint256 can now call functions from PriceConverter
    using PriceConverter for uint256;

    // Minimum funding amount in USD
    // Scaled to 18 decimals so it matches ETH math
    uint256 public minimumUSD = 5 * 1e18;

    // List of addresses that have funded the contract
    address[] public funders;

    // Tracks total ETH contributed by each address
    mapping(address => uint256) public addressToFundedAmount;

    // Tracks how many times each address has funded
    mapping(address => uint256) contributionCount;

    /*
     * Allows users to send ETH to the contract
     * - msg.value is the ETH sent (in wei)
     * - Converted to USD using the PriceConverter library
     * - Reverts if the USD value is below minimumUSD
     */
    function fund() public payable {
        require(
            msg.value.getConversionRate() >= minimumUSD,
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

    // Withdraw ETH While clearing records.
    function withdraw() public {
        /*
         *starts at index 0
         *runs until it reaches the end of the funders array
         *increments fundersIndex by 1 each iteration
         */
        for (
            uint256 fundersIndex = 0;
            fundersIndex < funders.length;
            fundersIndex++
        ) {
            // Get the funder's address at the current index.
            address funder = funders[fundersIndex];

            // Reset the total amount funded by this address to zero
            addressToFundedAmount[funder] = 0;

            // Reset the number of contributions made by this address
            contributionCount[funder] = 0;
        }

        // Reset the funders array by Creating a new array with length 0.
        funders = new address[](0);
    }

    // Expensive Reset -- By while Loop
    function expensiveReset() public {
        while (funders.length > 0) {
            funders.pop();
        }
    }

    // Expensive Reset -- By for loop
    function ExpensiveReset() public {
        // length is fixed because every pop() decrease length of array
        uint256 length = funders.length;
        for (uint256 funderIndex = 0; funderIndex < length; funderIndex++) {
            funders.pop();
        }

    
    }



    /*
     * Converts a USD amount into ETH
     * - USDAmount: USD value with 18 decimals
     * - Returns ETH amount with 18 decimals
     */
    function convertUSDtoETH(uint256 USDAmount) public view returns (uint256) {
        // Get price of 1 ETH in USD (18 decimals)
        uint256 ETHPrice = PriceConverter.getPrice();

        // USD -> ETH conversion
        // Multiply first to keep precision
        return (USDAmount * 1e18) / ETHPrice;
    }

    // Returns the version of the Chainlink price feed
    // Used only to confirm correct connection
    function getVersion() public view returns (uint256) {
        AggregatorV3Interface dataFeed = AggregatorV3Interface(
            0x694AA1769357215DE4FAC081bf1f309aDC325306
        );
        return dataFeed.version();
    }

    // function to check decimal value
    function getDecimalValue() public view returns (uint256) {
        AggregatorV3Interface dataFeed = AggregatorV3Interface(
            0x694AA1769357215DE4FAC081bf1f309aDC325306
        );
        return dataFeed.decimals();
    }
}
