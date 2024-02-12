// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract Coin {
    address public coinOwner;
    mapping (address => uint256) public balances;

    event Sent(address from, address to, uint amount);


    constructor(){
        coinOwner = msg.sender;

    }


    function coingenerator(address reciever, uint amount) public {
        require(msg.sender == coinOwner);
        balances[reciever] += amount;

    }

    error insufficientBalance(uint requested, uint available);

    function send(address reciever, uint amount) public{
        if(amount > balances[msg.sender])
        revert insufficientBalance({
            requested: amount,
            available: balances[msg.sender]
        });
        
        balances[msg.sender] -= amount;
        balances[reciever] +=amount;
        emit Sent(msg.sender, reciever, amount);
    }


}