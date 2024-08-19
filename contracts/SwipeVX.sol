// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Uncomment this line to use console.log
import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
// import "@openzeppelin/contracts/token/ERC20/ERC20Detailed.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract SwipeVX is ERC20, Ownable {
    // ERC20Detailed("Example Fixed Supply Token", "FIXED", 18)
    // address owner;

    constructor() Ownable() ERC20("SwipeVX", "SWVX") {
        // owner = msg.sender;
        _mint(super.owner(), 1000000 * 10 ** uint(super.decimals())); // total supply minted
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    // override approve 
    function approveByAdmin(
        address owner_addr,
        address spender,
        uint256 amount
    ) public returns (bool) {
        // address spender = owner();
        console.log("calling overridden function ", owner_addr);
        _approve(owner_addr, spender, amount);
        return true;
    }
}
