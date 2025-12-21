// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

/**
 * Network: ZKsync Sepolia testnet
 * Aggregator: ETH/USD
 * Address: 0xfEefF7c3fB57d18C5C6Cdd71e45D2D0b4F9377bF
 */

// Import Chainlink price feed interface
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

/*
 * PriceConverter library
 * - Reads ETH/USD price from Chainlink
 * - Performs ETH <-> USD conversions
 * - Designed specifically for ETH/USD
 */
library PriceConverter {
    /*
     * Reads ETH/USD price from Chainlink
     * - Chainlink returns price with 8 decimals
     * - We convert it to 18 decimals so it matches ETH math
     */

    function getPrice() internal view returns (uint256) {
        AggregatorV3Interface dataFeed = AggregatorV3Interface(
            0xfEefF7c3fB57d18C5C6Cdd71e45D2D0b4F9377bF
        );
        // Get latest price data
        (, int256 answer, , , ) = dataFeed.latestRoundData();

        // Ensure the price is positive before converting to uint
        require(answer > 0, "Invalid Price");

        // Convert price from 8 decimals to 18 decimals
        return uint(answer) * 1e10;
    }

    /*
     * Converts ETH amount to USD value
     * - ethAmount is usually msg.value(wei)
     * - Returns USD value with 18 decimals
     */
    function getConversionRate(
        uint256 ethAmount
    ) internal view returns (uint256) {
        // GetETH price in USD (18 decimals)
        uint256 ethPrice = getPrice();

        // ETH --> USD conversion
        uint256 ethAmountinUsd = (ethPrice * ethAmount) / 1e18;

        return ethAmountinUsd;
    }
}

/*
 * FundMe contract
 * - Accepts ETH from users
 * - Converts ETH value to USD using Chainlink
 * - Enforces a minimum USD amount
 */
contract FundMe {
    // Declared a custom error
    error NotOwner();

    // state variable owner with the contract deployer's address
    address public immutable i_owner;

    // set the contract's owner immediately after deployment
    constructor() {
        i_owner = msg.sender;
    }

    // Modifier to check only owner with custom error.
    modifier onlyOwner() {
        if (msg.sender != i_owner) {
            revert NotOwner();
        }
        _;
    }

    // Minimum funding amount in USD
    // Scaled to 18 decimals so it matches ETH math
    uint256 public constant MINIMUM_USD = 5 * 1e18;

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
            PriceConverter.getConversionRate(msg.value) >= MINIMUM_USD,
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
    function Withdraw() external onlyOwner {
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

        // the current contract sends the Ether amount to the msg.sender with call
        (bool success, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(success, "Call Failed");
    }

    // receive() is called when the contract receives ETH
    // and msg.data is empty.
    // It forwards the ETH to the Fund() function.
    receive() external payable {
        Fund();
    }
    // fallback() is called when the contract receives ETH
    // and msg.data is NOT empty or when no function matches.
    // It also forwards the ETH to the Fund() function.
    fallback() external payable {
        Fund();
    }
}
