// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Uncomment this line to use console.log
// import "hardhat/console.sol";
import "@openzeppelin/token/ERC20/ERC20.sol";
import "@openzeppelin/token/ERC20/ERC20Detailed.sol";
import "@openzeppelin/ownership/Ownable.sol";

contract SwipeVX is ERC20, ERC20Detailed, Ownable {
    constructor()
        public
        Ownable()
        ERC20Detailed("Example Fixed Supply Token", "FIXED", 18)
        ERC20("SwipeVX", "SWVX")
    {
        owner address = msg.sender;
        _mint(super.owner(), 1000000 * 10 ** uint(super.decimals()));
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }
}
