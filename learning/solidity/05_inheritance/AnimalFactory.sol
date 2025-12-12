// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Birds} from "./Bird.sol";
import {Cows} from "./Cow.sol";

contract AnimalFactory {

    // Array to store Deployed cows contract
    Cows[] public cowslist;


    // This function is to deploy two other contracts.
    function createAnimals() public {
         new Cows();
         new Birds();
    }
}