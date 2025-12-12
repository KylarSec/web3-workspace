// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {SimpleStorage} from "./SimpleStorage.sol";

// Type-casted version of StorageFactory where we use manual type casting
contract Typecast_storageFactory {
    // Array storing addresses of deployed SimpleStorage contracts
    address[] public listofDeployedContracts;

    // Deploy a new SimpleStorage contract and store its address
    function DeployContract() public {
        SimpleStorage newStorageContract = new SimpleStorage();
        // Here we have to mention address because type mismatch we have a address list so we have to mention address
        listofDeployedContracts.push(address(newStorageContract));
    }

    // Store a value in one of the deployed SimpleStorage contracts
    function sfStore(uint256 _index, uint256 _value) public {
        // Get the raw address from the array
        address contractAddress = listofDeployedContracts[_index];

        // Convert (cast) the address back into a SimpleStorage contract
        SimpleStorage ss = SimpleStorage(contractAddress);

        // call store() on that contract.
        ss.store(_value);
    }

    // Read a value from one of the deployed SimpleStorage contracts
    function sfGet(uint256 _index) public view returns (uint256) {
        // Get raw Address of the deployed contract from list by index
        address contractAddress = listofDeployedContracts[_index];

        // Convert address to Simplestorage contract (cast)
        SimpleStorage ss = SimpleStorage(contractAddress);

        // Read value from retrieve()
        return ss.retrieve();
    }
}
