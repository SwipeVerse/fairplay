// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Uncomment this line to use console.log
import "hardhat/console.sol";

import  "./SwipeVX.sol";

interface ISwipeVerseProfile {
    function makeMatch(address, address, address) external;
}

contract SwipeVerseCaptain is SwipeVX {

    uint SWIPE_RIGHT_FEE;
    uint DAILY_DISBURSE_AMT;
    address SWIPEVX_WALLET;

    constructor(uint swipeFee, uint dailyDisburseAmt, address swipeVXWallet) {
        SWIPE_RIGHT_FEE = swipeFee;
        SWIPEVX_WALLET = swipeVXWallet;
        DAILY_DISBURSE_AMT = dailyDisburseAmt;
    }

    mapping(address=>mapping(address=>bool)) public matchPool;

    // swipe right
    function swipeRight(address contractAddr, address receiver) public {
        // check if its a self swipe;
        require(msg.sender != receiver);

        // if receiver already sent a like; consider this a match
        if(matchPool[receiver][msg.sender] == true) {
            makeMatch(contractAddr, msg.sender, receiver);
        }
        // set match pool
        matchPool[msg.sender][receiver] = true;
        // deduct sender's balance
        transfer(receiver, SWIPE_RIGHT_FEE);
    }

    // swipe right pool txn
    function swipeRightBulk() public {}

    // match
    function makeMatch(address contractAddr, address sender, address receiver) public {
        ISwipeVerseProfile(contractAddr).makeMatch(contractAddr, sender, receiver);
        // send the tokens back to SwipeVX wallet
        approveByAdmin(receiver, sender, SWIPE_RIGHT_FEE);
        uint allownce_amt = allowance(receiver, SWIPEVX_WALLET);
        console.log("Receiver Addr ", receiver, " Amt ", allownce_amt);
        console.log("Swipe right fee ", SWIPE_RIGHT_FEE);
        transferFrom(receiver, SWIPEVX_WALLET, SWIPE_RIGHT_FEE);
        transfer(SWIPEVX_WALLET, SWIPE_RIGHT_FEE);
        // transferFrom(receiver, SWIPEVX_WALLET, SWIPE_RIGHT_FEE);
    }

    // disburse
    function disburse(address receiver) public {
        mint(receiver, DAILY_DISBURSE_AMT);
        approveByAdmin(receiver, SWIPEVX_WALLET, DAILY_DISBURSE_AMT);
        // console.log("Receiver Addr ", receiver);
    }

    // get balance
    function getBalance() public view returns(uint) {
        return balanceOf(msg.sender);
    }
}
