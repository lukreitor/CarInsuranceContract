// put money into the machine and get a something in return

/* 

* 1. The user puts money into the machine
* 2. The machine checks if the user has put enough money in
* 3. If the user has put enough money in, the machine gives the user something in return
* 4. If the user has not put enough money in, the machine gives the user their money back

State variables 
owner - address of the owner of the vending machine
balances - 

Functions
Purchase
Restock
getBalance

Constructor
Set the owner
Set initial balance of vending machine
*/
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

contract VendingMachineSmartContract {
    //State variables
    address public owner; // address is a type in solidity, it is a 20 byte value that is the size of an Ethereum address
    mapping(address => uint) public donutBalances; // mapping is a key value pair, in this case the key is the address and the value is the uint

    // Constructor
    constructor() { // its 
        owner = msg.sender; // msg.sender is the address of the person who called the function
        donutBalances[address(this)] = 100; // the owner of the contract will have 100 donuts, address(this) is the address of the current contract
    }

    // Functions
    function getVedingMachineBalance() public view returns (uint) {
        return donutBalances[address(this)];
    }

    function restock(uint amount) public {
        // only the owner of the contract can restock
        require(msg.sender == owner, "Only the owner can restock the vending machine"); // require is a function that will throw an error if the condition is not met
        donutBalances[address(this)] += amount;
    }

    function purchase(uint amount) public payable {
        // payble means that the function can accept ether, if payable is not specified, the function will automatically reject all Ether sent to it

        // the user has to send enough money to purchase the donuts
        require(msg.value >= amount * 1 ether, "Not enough Ether sent to purchase donuts"); // 1 ether is 1 * 10^18 wei
        // the vending machine has to have enough donuts to sell
        require(donutBalances[address(this)] >= amount, "Not enough donuts in the vending machine");
        
        // send the donuts to the user
        donutBalances[msg.sender] += amount;
        // take the donuts out of the vending machine
        donutBalances[address(this)] -= amount;
        // send the change back to the user
        payable(msg.sender).transfer(msg.value - amount * 1 ether);
    }
}