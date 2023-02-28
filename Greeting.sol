// SPDX-License-Identifier: MIT
//https://solidity-by-example.org/data-locations/
pragma solidity ^0.8.11; // declares the version of solidity that the contract will be using

contract Greeting {
    //state  variables -> will be storad in the blockchain and persist between multiple invocations
    string public name;
    string public greetingPrefix = "Hello ";

    constructor(string memory initialName) {
        name = initialName;
    }

    function setName(string memory newName) public {
        name = newName;
    }

    function getGreeting() public view returns (string memory) {
        // view means this function is not going to change any function across the blockchain
        // there is also pure, it also doesn't change any data in the blockchain but in addtion it doesn't read any data too
        return string(abi.encodePacked(greetingPrefix, name));
    }

    receive() external payable {
        emit Deposit(msg.sender, msg.value);
    } // this is a fallback function, it will be called if the contract receives Ether without any data
    // to compile just click the button

    // to deploy just click the button

    // to test just add the parametters
}