// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

// Import SimpleStorage contract from solidity file.
import {SimpleStorage} from "./SimpleStorage.sol";

contract StorageFactory {
    
    // A list to Store deployed SimpleStorage Contracts
    SimpleStorage[] public ListOfSimpleStorageConracts;

    // Function To deploy a new simplestorage contract
    function createSimpleStorage() public {
        // Deploy a new SimpleStorage contract and save its address temporarily in 'newSimpleStorageContract'
        SimpleStorage newSimpleStorageContract = new SimpleStorage();
        // Push the new contract into the list to store it permanently
        ListOfSimpleStorageConracts.push(newSimpleStorageContract);
    }
    // Stores a value in one specific deployed SimpleStorage contracts
    function sfStore(uint256 _index, uint256 _value) public {
        // Call the store() function on the contract at that index 
        ListOfSimpleStorageConracts[_index].store(_value);
    }

    // Get the stored value from one specific SimpleStorage contract
    function sfGet(uint256 _index) public view returns(uint256) {
        // Call the retrieve() function on the contract at that index
        return ListOfSimpleStorageConracts[_index].retrieve();
    }
}
