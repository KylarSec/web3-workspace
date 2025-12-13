// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;


// This contract is used to experiment with how `revert` works
// and how state changes are undone when a transaction fails.
contract RevertExperiment {

    //State Veriable Staring at 1
    uint256 counter = 1;

    function incrementCounter(uint256 _tempNum) public  {

        // Increase the counter by the given number
        counter += _tempNum;

        // If the number is 5 or more, the transaction will fail
        // and the counter change above will be reverted
        require( _tempNum < 5, "Number is greater than 5");
    }

    //  Returns the current value of counter
    function getNumber() public view returns(uint256) {
        return counter;
    }
}