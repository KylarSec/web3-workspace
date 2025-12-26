// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract SimpleStorage {
    address[] private uinqueAddress;

    struct Person {
        string name;
        uint256 favoriteNumber;
    }

    mapping(address => Person) public addressToPerson;

    function store(string calldata _name, uint256 _favNumber) external {
        addressToPerson[msg.sender] = Person({name: _name, favoriteNumber: _favNumber});
    }

    function retrieve(address _uinqueAddress) external view returns (Person memory) {
        return addressToPerson[_uinqueAddress];
    }
}
