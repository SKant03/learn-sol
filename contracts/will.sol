// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract will {
    address owner;
    uint fortune;
    bool deceased;

    constructor() payable {
        owner = msg.sender; //store address of caller
        fortune = msg.value; //amount to ether being send
        deceased = false;  
    }

    modifier  onlyOwner {
        require(msg.sender == owner);
        _;
    }

    modifier mustbeDeceased {
        require(deceased == true);
        _;
    }
    
    address payable [] familyWallets;

    mapping(address => uint) inheritance;

    function setInheritance(address payable  wallet, uint amount) public onlyOwner {
       familyWallets.push(wallet);
       inheritance[wallet] = amount; 
    } 

    function payout() mustbeDeceased private {
        for(uint i=0; i<familyWallets.length; i++){
            familyWallets[i].transfer(inheritance[familyWallets[i]]);
        }
    }

    function deceasedSet() public onlyOwner {
        deceased = true;
        payout();
    }

}
