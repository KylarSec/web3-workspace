// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

/*
 * Interface for Chainlink Aggregator (Price Feed)
 * This defines how our contract can talk to an already-deployed
 * Chainlink price feed contract (ETH/USD).
 * No implementation is written here — only function signatures.
 */
interface AggregatorV3Interface {
    // Returns the number of decimals the price feed uses
    function decimals() external view returns (uint8);

    // Returns a short description of the feed (e.g. "ETH / USD")
    function description() external view returns (string memory);

    // Returns the version of the price feed contract
    function version() external view returns (uint256);

    // Returns data for a specific round (not used for now)
    function getRoundData(
        uint80 _roundId
    )
        external
        view
        returns (
            uint80 roundId,
            int256 answer,
            uint256 startedAt,
            uint256 updatedAt,
            uint80 answeredInRound
        );

    // Returns the latest price data (this will be used later)
    function latestRoundData()
        external
        view
        returns (
            uint80 roundId,
            int256 answer,
            uint256 startedAt,
            uint256 updatedAt,
            uint80 answeredInRound
        );
}

/*
 * FundMe contract
 * Users will be able to fund this contract with ETH.
 * A minimum contribution in USD will be enforced later
 * using Chainlink price feeds.
 */
contract FundMe {
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

    /*
     * Placeholder function for withdrawing funds.
     * Withdrawal logic and access control will be implemented later.
     */
    function withdraw() public {}

    /*
     * Placeholder function for fetching ETH price.
     * Will be implemented using latestRoundData() in the next step.
     */
    function getPrice() public {
        // ETH/USD price feed address on Sepolia will be used here
    }

    /*
     * Reads the version number from the Chainlink ETH/USD price feed.
     * This is a sanity check to confirm we can successfully
     * call an external Chainlink contract.
     */
    function getVersion() public view returns (uint256) {
        return
            AggregatorV3Interface(
                0x694AA1769357215DE4FAC081bf1f309aDC325306
            ).version();
    }
}
