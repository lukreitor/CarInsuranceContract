pragma solidity ^0.8.7;

contract Notary  {
    struct MyNotaryEntry {
        string fileName;
        uint timestamp;
        bytes32 checksSum;
        string comments;
        bool isSet;
        address setBy;
    }

    mapping (string => MyNotaryEntry) public myMapping;

    function addEntry (bytes32 _checkSum, string memory _fileName, string memory _comments) public {
        require(!myMapping[_fileName].isSet, "File already exists");
        myMapping[_checkSum].isSet = true;
        myMapping[_checkSum].fileName = _fileName;
        myMapping[_checkSum].timestamp = block.timestamp;
        myMapping[_checkSum].comments = _comments;
    }

    function entrySet(bytes32 _checkSum) public view returns (string, uint, string, address) {
        require(myMapping[_checkSum].isSet, "File does not exist");
        return (myMapping[_checkSum].fileName, myMapping[_checkSum].timestamp, myMapping[_checkSum].comments, myMapping[_checkSum].setBy);
    }

    function getEntry(bytes32 _checkSum) public view returns (string, uint, string, address) {
        require(myMapping[_checkSum].isSet, "File does not exist");
        return (myMapping[_checkSum].fileName, myMapping[_checkSum].timestamp, myMapping[_checkSum].comments, myMapping[_checkSum].setBy);
    }

}