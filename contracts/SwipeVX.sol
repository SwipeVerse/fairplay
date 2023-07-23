// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Uncomment this line to use console.log
// import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
// import "@openzeppelin/contracts/token/ERC20/ERC20Detailed.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract SwipeVX is ERC20, Ownable {
        // ERC20Detailed("Example Fixed Supply Token", "FIXED", 18)
    // address owner;

    constructor()
        public
        Ownable()
        ERC20("SwipeVX", "SWVX")
    {
        address owner = msg.sender;
        _mint(super.owner(), 1000000 * 10 ** uint(super.decimals())); // total supply minted
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }
}
