// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.9;

import "./ERC20.sol";

contract MyToken is ERC20("ASD Token", "ASD"){
    
    address public minter;
    constructor(){
        minter = msg.sender;
    }

    function mint(address to, uint amount) external {
        require(msg.sender == minter, "Only minter can mint");
        _mint(to, amount);
    }

    function burn (address from, uint amount) external {
        require(msg.sender == minter, "Only minter can burn");
        _burn(from, amount);
    }
}