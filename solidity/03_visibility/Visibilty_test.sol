// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

contract ParentContract {
    // STATE VARIABLES WITH DIFFERENT VISIBILITIES
    uint256 private privateVar = 1;
    uint256 internal internalVar = 2; 
    uint256 public publicVar = 3;
    
    // PRIVATE - Only this contract
    function privateFunction() private pure returns(string memory) {
        return "Private - only Parent can call me";
    }
    
    // INTERNAL - This contract + Children
    function internalFunction() internal pure returns(string memory) {
        return "Internal - Parent and Children can call me";
    }
    
    // PUBLIC - Everyone
    function publicFunction() public pure returns(string memory) {
        return "Public - anyone can call me";
    }
    
    // EXTERNAL - Only outsiders
    function externalFunction() external pure returns(string memory) {
        return "External - only outsiders can call me";
    }
    
    // VIEW function - can read state
    function viewFunction() public view returns(uint256) {
        return publicVar; //  Can read blockchain state
    }
    
    // PURE function - no state access
    function pureFunction(uint256 a, uint256 b) public pure returns(uint256) {
        return a + b; //  Only math, no state access
    }
    
    // Test INTERNAL access
    function testInternal() public pure returns(string memory) {
        return internalFunction(); //  Works - same contract
    }
    
    // Test PRIVATE access  
    function testPrivate() public pure returns(string memory) {
        return privateFunction(); //  Works - same contract
    }
    
    // This would ERROR - can't call external internally:
    // function testExternal() public view returns(string memory) {
    //     return externalFunction(); //  Would fail!
    // }
}

// CHILD CONTRACT - Tests inheritance
contract ChildContract is ParentContract {
    // Test what child can access from parent
    
    function childCallsInternal() public pure returns(string memory) {
        return internalFunction(); //  Works - child can call internal
    }
    
    function childCallsPublic() public pure returns(string memory) {
        return publicFunction(); //  Works - child can call public  
    }
    
    // These would show ERROR - child CANNOT access:
    // function childCallsPrivate() public pure returns(string memory) {
    //     return privateFunction(); //  Would fail!
    // }
    //
    // function childCallsExternal() public pure returns(string memory) {
    //     return externalFunction(); //  Would fail!
    // }
    
    // Child can access internal variables
    function getInternalVar() public view returns(uint256) {
        return internalVar; //  Works - child can read internal
    }
}