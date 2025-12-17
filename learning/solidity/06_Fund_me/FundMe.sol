// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

// Import the PriceConverter Library
import {PriceConverter} from "./PriceConverter.sol";

/*
 * FundMe contract
 * - Accepts ETH from users
 * - Converts ETH value to USD using Chainlink
 * - Enforces a minimum USD amount
 */
contract FundMe {
    // Minimum funding amount in USD
    // Scaled to 18 decimals so it matches ETH math
    uint256 public minimumUSD = 5 * 1e18;

    // List of addresses that have funded the contract
    address[] public funders;

    // Tracks total ETH contributed by each address
    mapping(address => uint256) public addressToFundedAccount;

    // Tracks how many times each address has funded
    mapping(address => uint256) public ContributionCount;

    /*
     * Allows users to send ETH to the contract
     * - msg.value is the ETH sent (in wei)
     * - Converted to USD using the PriceConverter library
     * - Reverts if the USD value is below minimumUSD
     */
    function Fund() public payable {
        require(
            PriceConverter.getConversionRate(msg.value) >= minimumUSD,
            "Didn't Send enough ETH"
        );

        // add addresses to the array who sends money to the contract.
        // The msg.sender global variable refers to the address that initiates the transaction.
        funders.push(msg.sender);

        /*
         * Mapping associates each funder's address with the total amount they have contributed.
         * When a new amount is sent, we can add it to the user's total contribution
         */
        addressToFundedAccount[msg.sender] += msg.value;

        // Count everytime a user funds
        ContributionCount[msg.sender] += 1;
    }

    // Withdraw ETH While clearing records.
    function Withdraw() public {
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

            // Reset the total amount funded by this address to zero.
            addressToFundedAccount[funder] = 0;

            // Reset the number of contributions made by this address
            ContributionCount[funder] = 0;
        }

        // Reset the funders array by Creating a new array with length 0.
        funders = new address[](0);
    }
}
