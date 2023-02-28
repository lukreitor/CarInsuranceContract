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
    address internal owner;                      // the address of the owner of the contract
    //uint public premium;                       // the monthly premium
    //uint public deductible;                   // the amount the user has to pay before the insurance company pays
    uint internal balance;                      // the balance of the contract, the amount of money the insurance company has to pay out when a claim is made
    uint internal carInsuranceId;               // the id of the car insurance
    uint internal carInsuranceClaimId;         // the id of the car insurance claim
    uint internal carInsuranceClaimStatusId;   // the id of the car insurance claim status
    mapping(uint => CarInsurance) public carInsurances; // the list of car insurances
    mapping(uint => CarInsuranceClaim) public carInsuranceClaims; // the list of car insurance claims
    mapping(uint => CarInsuranceClaimStatus) public carInsuranceClaimStatuses; // the list of car insurance claim statuses

    string private result;

    // Structs
    struct CarInsurance {
        uint id;
        string make;                     // make of the car, e.g. Toyota
        string model;                    // model of the car, e.g. Corolla
        uint year;                       // year of the car, e.g. 2021
        string vin;                      // vehicle identification number, e.g. 1G1YY22G565101010
        uint balance;                    // the balance of the car insurance, the amount of money the insurance company has to pay out
        uint premium;                    // the monthly premium, e.g. $100
       //uint deductible;                 // the amount the user has to pay before the insurance company pays, e.g. $500
        address userId;                   // the id of the user who owns the car insurance
        bool carInsuranceStatus;       // the status of the car insurance, true = active, false = inactive
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
        //premium = 100;
        //deductible = 500;
        balance = 0;
        carInsuranceId = 1;
        carInsuranceClaimId = 1;
        carInsuranceClaimStatusId = 1;
        addCarInsuranceClaimStatus("pending");
        addCarInsuranceClaimStatus("approved");
        addCarInsuranceClaimStatus("denied");
        addCarInsuranceClaimStatus("paid");
        addCarInsuranceClaimStatus("closed");
    }


    // get carInsuranceClaimId by vin
    function getIdFromCarInsurance(string memory _vin) internal view returns(uint) {
        // go through the carInsurances array and find the vin
        uint id = 0;
        for(uint i = 1; i < carInsuranceId; i++) {
            if(keccak256(bytes(carInsurances[i].vin)) == keccak256(bytes(_vin))){
                id = carInsurances[i].id;
            }
        }
        
        return id;
    }

    function getIdFromCarInsuranceClaim(string memory _vin) internal view returns(uint) {
        // go through the carInsurances array and find the vin
        uint id = 0;
        for(uint i = 1; i < carInsuranceClaimId; i++) {
            if(keccak256(bytes(carInsuranceClaims[i].vin)) == keccak256(bytes(_vin))){
                id = carInsuranceClaims[i].id;
            }
        }
        
        return id;
    }

    // get all data from carInsurance by vin
    function getCarInsurance(string memory _vin) public view returns(CarInsurance memory) {
        // get the id of the car insurance
        
        return carInsurances[getIdFromCarInsurance(_vin)];
    }
    
    function payPremium(string memory _vin) public payable {
        
        // get the id of the car insurance
        uint _carInsuranceId = getIdFromCarInsurance(_vin);
        
        // verify if the user address is the same as the user id in carInsurances
        require(carInsurances[_carInsuranceId].userId == msg.sender, "You are not the owner of this car insurance");
        
        // verify if the value is equal to the premium in carInsurances
        require(msg.value == carInsurances[_carInsuranceId].premium, "The value is not equal to the premium");
        
        // add the premium to the balance
        balance += msg.value;
    }

    // makeClaim2 -> make a claim, amount is in wei, vin is a parameter to get the carInsuranceId
    function makeClaim(uint _amount, string memory _vin) public payable{
        // get the id of the car insurance
        uint _carInsuranceId = getIdFromCarInsurance(_vin);
        
        // verify if the user address is the same as the user id in carInsurances
        require(carInsurances[_carInsuranceId].userId == msg.sender, "You are not the owner of this car insurance");
        
        // verify if the amount is less than the balance
        require(_amount < address(this).balance, "You cannot claim more than the balance");
        
        // add the claim to the carInsuranceClaims array
        carInsuranceClaims[carInsuranceClaimId] = CarInsuranceClaim(carInsuranceClaimId, _carInsuranceId, _amount, 1, msg.sender, _vin);
        
        // increment the carInsuranceClaimId
        carInsuranceClaimId++;
        
    }

    // showAllClaims with carInsuranceClaimStatusId = 1
    function showAllPeddingClaims() public view returns(CarInsuranceClaim[] memory) {
        // create an array of carInsuranceClaims
        CarInsuranceClaim[] memory _carInsuranceClaims = new CarInsuranceClaim[](carInsuranceClaimId);
        
        // go through the carInsuranceClaims array and add the claims with carInsuranceClaimStatusId = 1 to the _carInsuranceClaims array
        uint j = 0;
        for(uint i = 1; i < carInsuranceClaimId; i++) {
            if(carInsuranceClaims[i].carInsuranceClaimStatusId == 1){
                _carInsuranceClaims[j] = carInsuranceClaims[i];
                j++;
            }
        }
        
        return _carInsuranceClaims;
    }

    // showaAllPendingClaims, show only the vin and the amount. jump one line after each claim displayed
    function showAllPendingClaims2() public view returns(string memory) {
        // create an array of carInsuranceClaims
        CarInsuranceClaim[] memory _carInsuranceClaims = new CarInsuranceClaim[](carInsuranceClaimId);
        
        // go through the carInsuranceClaims array and add the claims with carInsuranceClaimStatusId = 1 to the _carInsuranceClaims array
        uint j = 0;
        for(uint i = 1; i < carInsuranceClaimId; i++) {
            if(carInsuranceClaims[i].carInsuranceClaimStatusId == 1){
                _carInsuranceClaims[j] = carInsuranceClaims[i];
                j++;
            }
        }
        
        // create a string to return
        string memory _claims = "";
        
        // go through the _carInsuranceClaims array and add the vin and the amount to the _claims string
        for(uint k = 0; k < j; k++) {
            _claims = string(abi.encodePacked(_claims, _carInsuranceClaims[k].vin, " ", uint2str(_carInsuranceClaims[k].amount), "\n"));
        }
        
        return _claims;
    }


    function approveClaim(string memory _vin) public {
        require(carInsuranceClaims[getIdFromCarInsuranceClaim(_vin)].id != 0, "Car insurance claim does not exist");
        // check if the user calling the function is the owner of the contract
        require(msg.sender == owner, "Only the company can approve the claim");
        //require(carInsuranceClaims[_carInsuranceClaimId].userId == owner, "Only the company can approve the claim");
        require(carInsuranceClaims[getIdFromCarInsuranceClaim(_vin)].carInsuranceClaimStatusId == 1, "The claim is not pending");
        carInsuranceClaims[getIdFromCarInsuranceClaim(_vin)].carInsuranceClaimStatusId = 2;
    }

    function denyClaim(string memory _vin) public {
        require(carInsuranceClaims[getIdFromCarInsuranceClaim(_vin)].id != 0, "Car insurance claim does not exist");
        require(msg.sender == owner, "Only the company can approve the claim");
        require(carInsuranceClaims[getIdFromCarInsuranceClaim(_vin)].carInsuranceClaimStatusId == 1, "The claim is not pending");
        carInsuranceClaims[getIdFromCarInsuranceClaim(_vin)].carInsuranceClaimStatusId = 3;
    } 

    // payClaim - send the amount to the user address from the balance of the contract
    function payClaim(string memory _vin) public {
        require(carInsuranceClaims[getIdFromCarInsuranceClaim(_vin)].id != 0, "Car insurance claim does not exist");
        require(msg.sender == owner, "Only the company can pay the claim");
        require(carInsuranceClaims[getIdFromCarInsuranceClaim(_vin)].carInsuranceClaimStatusId == 2, "The claim was not approved");
        carInsuranceClaims[getIdFromCarInsuranceClaim(_vin)].carInsuranceClaimStatusId = 4;
        
        

        // send the amount to the user address, thansfer the balance to the user address - the amount
        payable(carInsurances[carInsuranceClaims[getIdFromCarInsuranceClaim(_vin)].carInsuranceId].userId).transfer(carInsuranceClaims[getIdFromCarInsuranceClaim(_vin)].amount);
    }

    function getCarInsurances() public view returns(CarInsurance[] memory) {
        CarInsurance[] memory _carInsurances = new CarInsurance[](carInsuranceId - 1); // create a new array of car insurances, the size of the array is the car insurance id minus 1, because the car insurance id starts at 1
        uint counter = 0;
        for(uint i = 1; i < carInsuranceId; i++) {
            _carInsurances[counter] = carInsurances[i];
            counter++;
        }
        return _carInsurances;
    }

    function addCarInsurance(string memory _make, string memory _model, uint _year, string memory _vin, address _userId, uint _premium, bool carInsuranceStatus) public {
        //only the owner of the contract can add a car insurance, verify this later?
        require(msg.sender == owner, "Only the CIA can add new contracts");
        // the user id should be the address of the user
        //check if the carinsurancestatus is true or false
        require(carInsuranceStatus == true, "The car insurance status should be true");
        // check if the year is between 1900 and 2022
        require(_year >= 1900 && _year <= 2022, "The year should be between 1900 and 2022");
        carInsurances[carInsuranceId] = CarInsurance(carInsuranceId, _make, _model, _year, _vin, 0, _premium, _userId, carInsuranceStatus);
        carInsuranceId++;

    }

    // delete will be softdelete 
    function deleteCarInsurance(uint _id) public {
        require(carInsurances[_id].id != 0, "Car insurance does not exist");
        require(msg.sender == owner, "You don't have access to this funcionality");
        //delete carInsurances[_id];

        // softdelete - set carInsuranceStatusId to closed
        carInsurances[_id].carInsuranceStatus = false;
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

    function addCarInsuranceClaim(uint _carInsuranceId, uint _amount, uint _carInsuranceClaimStatusId, address _userId, string memory _vin) internal {
        carInsuranceClaims[carInsuranceClaimId] = CarInsuranceClaim(carInsuranceClaimId, _carInsuranceId, _amount, _carInsuranceClaimStatusId, _userId, _vin);
        carInsuranceClaimId++;
    }

    function deleteCarInsuranceClaim(uint _id) public {
        require(carInsuranceClaims[_id].id != 0, "Car insurance claim does not exist");
        require(carInsuranceClaims[_id].userId == msg.sender, "You are not the owner of the car insurance claim");
        delete carInsuranceClaims[_id];
    }

    /*function getCarInsuranceClaimStatus(uint _id) public view returns(CarInsuranceClaimStatus memory) {
        require(carInsuranceClaimStatuses[_id].id != 0, "Car insurance claim status does not exist");
        return carInsuranceClaimStatuses[_id];
    }*/

    /*
    function getCarInsuranceClaimStatuses() public view returns(CarInsuranceClaimStatus[] memory) {
        CarInsuranceClaimStatus[] memory _carInsuranceClaimStatuses = new CarInsuranceClaimStatus[](carInsuranceClaimStatusId - 1);
        uint counter = 0;
        for(uint i = 1; i < carInsuranceClaimStatusId; i++) {
            _carInsuranceClaimStatuses[counter] = carInsuranceClaimStatuses[i];
            counter++;
        }
        return _carInsuranceClaimStatuses;
    }*/

    function addCarInsuranceClaimStatus(string memory _name) internal {
        require(msg.sender == owner, "You don't have access to this funcionality");
        carInsuranceClaimStatuses[carInsuranceClaimStatusId] = CarInsuranceClaimStatus(carInsuranceClaimStatusId, _name);
        carInsuranceClaimStatusId++;
    }

    function deleteCarInsuranceClaimStatus(uint _id) internal {
        require(msg.sender == owner, "You don't have access to this funcionality");
        require(carInsuranceClaimStatuses[_id].id != 0, "Car insurance claim status does not exist");
        delete carInsuranceClaimStatuses[_id];
    }

    // get balance, only the owner can get the balance
    /*function getBalance() public view returns(uint) {
        require(msg.sender == owner, "You don't have access to the balance");
        return address(this).balance;
    }*/

    // function getPremium() public view returns(uint) {
    //     return premium;
    // }

    // function setPremium(uint _premium) public {
    //     require(msg.sender == owner, "You are not the owner");
    //     premium = _premium;
    // }

     function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
        if (_i == 0) {
            return "0";
        }
        uint j = _i;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len - 1;
        while (_i != 0) {
            bstr[k--] = bytes1 (uint8(48 + _i % 10));
            _i /= 10;
        }
        return string(bstr);
    }
}