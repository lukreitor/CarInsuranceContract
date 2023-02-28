// Lottery Smart Contract

/* 

* 1. The user pays to enter the lottery
* 2. The lottery checks if the user has paid enough to enter
* 3. If the user has paid enough, the lottery adds the user to the list of players
* 4. If the user has not paid enough, the lottery gives the user their money back
* 5. The lottery checks if there are enough players to pick a winner
* 6. If there are enough players, the lottery picks a winner and sends them the pot
* 7. If there are not enough players, the lottery waits for more players to enter


State variables 
- Owner
- Players

Functions
- Enter lottery
- Pick winner
- Get balance
- Get random number

Optional functions
- Get players
- Get pot balance
- Other\

Constructor
- Set owner
- Set initial balance of pot

*/

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

contract LotterySmartContract {
    // State variables
    address public owner;
    address payable[] public players; // address payable is an address that can receive Ether. Payble is a modifier that allows the address to receive Ether, could be a function or a variable
    uint public lotteryId;
    mapping(uint => address payable) public lotteryHistory;

    // Constructor
    constructor() {
        owner = msg.sender; // msg.sender is the address of the person who called the function, the person who deployed the contract
        lotteryId = 1;
    }

    // Functions
    function getBalance() public view returns (uint) {
        return address(this).balance; // address(this) is the address of the current contract
    }

    function getPlayers() public view returns (address payable[] memory) {
        return players;
    }

    function enterLottery() public payable {
        // the user has to send enough money to enter the lottery
        require(msg.value >=.02 ether, "Not enough Ether sent to enter the Lottery"); // 1 ether is 1 * 10^18 wei

        // add the user to the list of players, addres of players entere                                                                                                                                                           ing the lottery
        players.push(payable(msg.sender)); 
    }

    function getRandomNumber() public view returns (uint) {
        // keccak256 is a hashing function that takes in a string and returns a hash
        // abi.encodePacked is a function that takes in a list of values and returns a string
        // block.difficulty is the difficulty of the current block
        // block.timestamp is the timestamp of the current block
        // players.length is the length of the players array
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players.length)));
    }

    function pickWinner() public {
        // only the owner of the contract can pick a winner
        require(msg.sender == owner, "Only the owner can pick a winner");

        // the lottery has to have enough players to pick a winner
        require(players.length >= 3, "Not enough players to pick a winner");

        // pick a random player from the list of players
        uint r = getRandomNumber();
        address payable winner;
        uint index = r % players.length;
        winner = players[index];
       

        // send the pot to the winner
        winner.transfer(getBalance());
        lotteryHistory[lotteryId] = players[index];
        lotteryId++;
        

        // reset the list of players
        players = new address payable[](0);
    }

    function getWinnerByLotteryId(uint _lotteryId) public view returns (address payable) {
        return lotteryHistory[_lotteryId];
    }

    //send all the money to the owner
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }
    
}



















// Car Insurance Smart Contract

/* 

steps:
    1. create a car insurance smart contract
    2. create a function to add a new car insurance
    3. create a function to get a car insurance
    4. create a function to get all car insurances
    5. create a function to update a car insurance, only the owner can update the car insurance
    6. create a function to delete a car insurance


    7. create a function to add a new car insurance claim
    8. create a function to get a car insurance claim
    9. create a function to get all car insurance claims
    10. create a function to update a car insurance claim
    11. create a function to delete a car insurance claim

    12. create a function to add a new car insurance claim status
    13. create a function to get a car insurance claim status
    14. create a function to get all car insurance claim statuse

    state variables
    1. car insurance id
    2. car insurance claim id
    3. car insurance claim status id

how does car insurance work?

1. you pay a monthly premium
2. if you have an accident, you pay a deductible
3. if you have an accident, the insurance company pays the rest

State variables
owner - address of the owner of the contract
premium - the monthly premium
deductible - the amount the user has to pay before the insurance company pays
balances - the balance of the contract, the amount of money the insurance company has to pay out
carInsurances - the list of car insurances
carInsuranceClaims - the list of car insurance claims
carInsuranceClaimStatuses - the list of car insurance claim statuses


Functions
payPremium - the user pays the monthly premium
getBalance - the user gets the balance of the contract
makeClaim - the user makes a claim, the insurance company pays the claim
getCarInsurance - the user gets a car insurance
getCarInsurances - the user gets all car insurances
addCarInsurance - the user adds a car insurance
deleteCarInsurance - the user deletes a car insurance

getCarInsuranceClaim - the user gets a car insurance claim
getCarInsuranceClaims - the user gets all car insurance claims
addCarInsuranceClaim - the user adds a car insurance claim
deleteCarInsuranceClaim - the user deletes a car insurance claim



