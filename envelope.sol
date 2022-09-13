//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
    * @title Envelope
    This is a simple contract that allows you to store a testimoney/description in the smart contract in the form of hash
    and then you can confirm the description again by providing the same description
    if the hash matches than the description is confirmed
    @dev caution , the message provided must be 100% same , if not then it will not match
 */


contract MessageStoreCommitReveal {
    /**
        @dev envelopesByAddress is a mapping of addresses to envelopes(hash of the description stored).
        @dev testimoney is a mapping of description to the unit256, if description exists it will be 1 or more(if same description saved twice), else 0.
        it will identify if the description which is the testimoney of the user was same or not .
     */
    mapping(address => mapping (uint256 => bytes32)) public envelopesByAddress;
    mapping(string => uint256) public testimoney;

    uint256 public Id;

     /**
        @dev reveal the message by using the _description as a key and outputing unit256 as a value , 
        it can increase if the hash of the function is same when the message is same 
        @param _description The message to be stored/revealed 
        @param _Id The Id of the message to be revealed
    */
    function revealDescrip(string memory _description, uint256 _Id) external {
        require(keccak256(abi.encode(_description)) == envelopesByAddress[msg.sender][_Id],
            "description or Id do not match stored hash");
        testimoney[_description] += 1;
    }

    /**
        @dev store the hash of the description/message in the contract mapping 
        @param _description the description/message to be stored
        @dev Id is the number of the message, and it will be incremented upon the next message
        @dev the sender's address is used as the key to the mapping
        @return the Id of the message
     */
    function saveDescrip(string memory _description) external returns (uint256){
        Id++;
        bytes32 hash = keccak256(abi.encode(_description));
        envelopesByAddress[msg.sender][Id] = hash;
        return Id;
    }
}