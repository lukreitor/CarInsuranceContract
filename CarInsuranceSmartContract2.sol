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



*/
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
// import "https://github.com/ethereum/dapp-bin/blob/master/library/stringUtils.sol";

contract CarInsuranceSmartContract {
    // State variables
    address public owner;                      // the address of the owner of the contract
    uint public premium;                       // the monthly premium
    uint public deductible;                   // the amount the user has to pay before the insurance company pays
    uint public balance;                      // the balance of the contract, the amount of money the insurance company has to pay out when a claim is made
    uint public carInsuranceId;               // the id of the car insurance
    uint public carInsuranceClaimId;         // the id of the car insurance claim
    uint public carInsuranceClaimStatusId;   // the id of the car insurance claim status
    mapping(uint => CarInsurance) public carInsurances; // the list of car insurances
    mapping(uint => CarInsuranceClaim) public carInsuranceClaims; // the list of car insurance claims
    mapping(uint => CarInsuranceClaimStatus) public carInsuranceClaimStatuses; // the list of car insurance claim statuses

    // Structs
    struct CarInsurance {
        uint id;
        string make;                     // make of the car, e.g. Toyota
        string model;                    // model of the car, e.g. Corolla
        uint year;                       // year of the car, e.g. 2021
        string vin;                      // vehicle identification number, e.g. 1G1YY22G565101010
        uint balance;                    // the balance of the car insurance, the amount of money the insurance company has to pay out
        uint premium; 
        uint deductible;                 // the amount the user has to pay before the insurance company pays, e.g. $500
        address userId;                     // the id of the user who owns the car insurance
    }

    struct CarInsuranceClaim {
        uint id;                         // the id of the car insurance claim
        uint carInsuranceId;             // the id of the car insurance, count the number of instances orcar insurances
        uint amount;                     // the amount of the claim
        uint carInsuranceClaimStatusId;  // the id of the car insurance claim status
        address userId;                     // the id of the user who made the claim, this should be the address of the user?
        string vin;                      // vehicle identification number, e.g. 1G1YY22G565101010
    }

    struct CarInsuranceClaimStatus {
        uint id; 
        string name;                   // the name of the car insurance claim status, e.g. pending, approved, denied
    }

    // Constructor
    constructor() {
        owner = msg.sender;
        premium = 100;
        deductible = 500;
        balance = 0;
        carInsuranceId = 1;
        carInsuranceClaimId = 1;
        carInsuranceClaimStatusId = 1;
        addCarInsuranceClaimStatus("pending");
        //addCarInsuranceClaimStatus("approved");
        //addCarInsuranceClaimStatus("denied");
        //addCarInsuranceClaimStatus("paid");
        //addCarInsuranceClaimStatus("closed");
    }

    // Functions
    function payPremium() public payable {
        // verify if the value is equal to the premium of the car insurance contract
        require(msg.value == premium, "You must pay the premium");  // if condition not working
        // verify if the user is the owner of the car insurance with the user id


        // add the premium to the balance
        balance += msg.value;
    }

    /*
    function getBalance() public view returns(uint) {
        return balance;
    }
    */

    function makeClaim(uint _carInsuranceId, uint _amount, string memory _vin) public {
        CarInsurance[] memory _carInsurance = new CarInsurance[](carInsuranceId - 1);
        uint counter = 0;
        for(uint i = 1; i < carInsuranceId; i++) {
            if(keccak256(bytes(carInsurances[counter].vin)) == keccak256(bytes(_vin))){
                _carInsurance[counter] = carInsurances[counter];
            }
                counter++;
        }

        // if counter is 0, then the vin does not exist
        require(counter != 0, "The vin does not exist");
        require(carInsurances[_carInsuranceId].id != 0, "Car insurance does not exist");
        require(carInsurances[_carInsuranceId].userId == msg.sender, "You are not the owner of the car insurance");
        require(_amount > carInsurances[_carInsuranceId].balance, "You cannot claim more than the balance");
        carInsuranceClaims[carInsuranceClaimId] = CarInsuranceClaim(carInsuranceClaimId, _carInsuranceId, _amount, 1, msg.sender, _vin);
        carInsuranceClaimId++;
        carInsurances[_carInsuranceId].balance -= _amount;
        balance -= _amount;
    }

    // make a claim, amount is in wei   
    function approveClaim(uint _carInsuranceClaimId) public {
        require(carInsuranceClaims[_carInsuranceClaimId].id != 0, "Car insurance claim does not exist");
        require(carInsuranceClaims[_carInsuranceClaimId].userId == owner, "Only the company can approve the claim");
        require(carInsuranceClaims[_carInsuranceClaimId].carInsuranceClaimStatusId == 1, "The claim is not pending");
        carInsuranceClaims[_carInsuranceClaimId].carInsuranceClaimStatusId = 2;
    }

    function payClaim(uint _carInsuranceClaimId) public {
        require(carInsuranceClaims[_carInsuranceClaimId].id != 0, "Car insurance claim does not exist");
        require(carInsuranceClaims[_carInsuranceClaimId].userId == owner, "Only the company can pay the claim");
        require(carInsuranceClaims[_carInsuranceClaimId].carInsuranceClaimStatusId == 1, "The claim is not pending");
        carInsuranceClaims[_carInsuranceClaimId].carInsuranceClaimStatusId = 4;
        carInsurances[carInsuranceClaims[_carInsuranceClaimId].carInsuranceId].balance += carInsuranceClaims[_carInsuranceClaimId].amount;
        balance += carInsuranceClaims[_carInsuranceClaimId].amount;
    }

    function getCarInsurance(string memory _vin) public view returns(CarInsurance[] memory) {
        // for(uint i=0; i < carInsurance.length; i++) {
        //     if(carInsurances[i].vin == _vin){
        //         return carInsurances[i];
        //     }
        // }
        // return "Car insurance does not exist";

        CarInsurance[] memory _carInsurance = new CarInsurance[](carInsuranceId - 1);
        uint counter = 0;
        for(uint i = 1; i < carInsuranceId; i++) {
            if(keccak256(bytes(carInsurances[counter].vin)) == keccak256(bytes(_vin))){
                _carInsurance[counter] = carInsurances[counter];
            }
                counter++;
        }
        // if(counter == 0){
        //     return "Car insurance does not exist";
        // }
        return _carInsurance;
    }

    // get carInsuranceClaimId by vin
    function getCarInsuranceId(string memory _vin) public view returns(uint) {
        // go through the car insurance claim and find the car insurance vin that matches the vin from car insurance and return the car insurance  id
        uint aux = 0;
        for(uint i = 1; i < carInsuranceClaimId; i++) {
            if(keccak256(bytes(carInsuranceClaims[i].vin)) == keccak256(bytes(_vin))){
                return carInsuranceClaims[i].carInsuranceId;
            }
        }
        return aux;
    }

     // create the function payPremium2 that takes the _vin as a parameter, and if the vin exists, pay the premium
        

    function getCarInsurances() public view returns(CarInsurance[] memory) {
        CarInsurance[] memory _carInsurances = new CarInsurance[](carInsuranceId - 1); // create a new array of car insurances, the size of the array is the car insurance id minus 1, because the car insurance id starts at 1
        uint counter = 0;
        for(uint i = 1; i < carInsuranceId; i++) {
            _carInsurances[counter] = carInsurances[i];
            counter++;
        }
        return _carInsurances;
    }

    function addCarInsurance(string memory _make, string memory _model, uint _year, string memory _vin, address _userId, uint _premium) public {
        //only the owner of the contract can add a car insurance, verify this later?
        require(msg.sender == owner, "Only the CIA can add new contracts");
        // the user id should be the address of the user
        carInsurances[carInsuranceId] = CarInsurance(carInsuranceId, _make, _model, _year, _vin, 0, _premium, deductible, _userId);
        carInsuranceId++;
    }

    function deleteCarInsurance(uint _id) public {
        require(carInsurances[_id].id != 0, "Car insurance does not exist");
        require(carInsurances[_id].userId == msg.sender, "You are not the owner of the car insurance");
        delete carInsurances[_id];
    }

    function getCarInsuranceClaim(uint _id) public view returns(CarInsuranceClaim memory) {
        require(carInsuranceClaims[_id].id != 0, "Car insurance claim does not exist");
        return carInsuranceClaims[_id];
    }

    function getCarInsuranceClaims() public view returns(CarInsuranceClaim[] memory) {
        CarInsuranceClaim[] memory _carInsuranceClaims = new CarInsuranceClaim[](carInsuranceClaimId - 1);
        uint counter = 0;
        for(uint i = 1; i < carInsuranceClaimId; i++) {
            _carInsuranceClaims[counter] = carInsuranceClaims[i];
            counter++;
        }
        return _carInsuranceClaims;
    }

    function addCarInsuranceClaim(uint _carInsuranceId, uint _amount, uint _carInsuranceClaimStatusId, address _userId, string memory _vin) public {
        carInsuranceClaims[carInsuranceClaimId] = CarInsuranceClaim(carInsuranceClaimId, _carInsuranceId, _amount, _carInsuranceClaimStatusId, _userId, _vin);
        carInsuranceClaimId++;
    }

    function deleteCarInsuranceClaim(uint _id) public {
        require(carInsuranceClaims[_id].id != 0, "Car insurance claim does not exist");
        require(carInsuranceClaims[_id].userId == msg.sender, "You are not the owner of the car insurance claim");
        delete carInsuranceClaims[_id];
    }

    function getCarInsuranceClaimStatus(uint _id) public view returns(CarInsuranceClaimStatus memory) {
        require(carInsuranceClaimStatuses[_id].id != 0, "Car insurance claim status does not exist");
        return carInsuranceClaimStatuses[_id];
    }

    function getCarInsuranceClaimStatuses() public view returns(CarInsuranceClaimStatus[] memory) {
        CarInsuranceClaimStatus[] memory _carInsuranceClaimStatuses = new CarInsuranceClaimStatus[](carInsuranceClaimStatusId - 1);
        uint counter = 0;
        for(uint i = 1; i < carInsuranceClaimStatusId; i++) {
            _carInsuranceClaimStatuses[counter] = carInsuranceClaimStatuses[i];
            counter++;
        }
        return _carInsuranceClaimStatuses;
    }

    function addCarInsuranceClaimStatus(string memory _name) public {
        require(msg.sender == owner, "You are not the owner");
        carInsuranceClaimStatuses[carInsuranceClaimStatusId] = CarInsuranceClaimStatus(carInsuranceClaimStatusId, _name);
        carInsuranceClaimStatusId++;
    }

    function deleteCarInsuranceClaimStatus(uint _id) public {
        require(msg.sender == owner, "You are not the owner");
        require(carInsuranceClaimStatuses[_id].id != 0, "Car insurance claim status does not exist");
        delete carInsuranceClaimStatuses[_id];
    }

    // function getPremium() public view returns(uint) {
    //     return premium;
    // }

    // function setPremium(uint _premium) public {
    //     require(msg.sender == owner, "You are not the owner");
    //     premium = _premium;
    // }

    function getDeductible() public view returns(uint) {
        return deductible;
    }

    function setDeductible(uint _deductible) public {
        require(msg.sender == owner, "You are not the owner");
        deductible = _deductible;
    }

    /* 
        Funcionando 
        addCarInsurance
        getCarInsurance
        gerCarInsurances
        deleteCarInsurance
        Premium
        Owner
        deductible
        carInsuranceId
        

        getCarInsuranceClaimStatuses
        getCarInsuranceClaimStatus
        addCarInsuranceClaimStatus
        deleteCarInsuranceClaimStatus

        setDeductible
        getDeductible  - receber o endereço da carteira ou o vim 

        Obs: 
        getDeductibel para cada cliente?
        balance
    */
}