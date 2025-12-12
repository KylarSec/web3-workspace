// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

contract favNumber_list {
    //Declared a Empty list for storing favNumbers
    uint256[]  favNumbers;

    // Takes input and put it into the list starting from index 0
    function store(uint256 _favnumber) public {
        favNumbers.push(_favnumber); // This push the value of temp variable to the list
    }

    // This function is to get the fav_number from list by indexing.
    function get_favNumber(uint256 index) public view returns(uint256) {
        return favNumbers[index];
    }
}
