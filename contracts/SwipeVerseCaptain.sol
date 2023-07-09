// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Uncomment this line to use console.log
// import "hardhat/console.sol";

import  "./SwipeVX.sol";

interface ISwipeVerseProfile {
    function match() external returns(bool);
}

contract SwipeVerseCaptain is SwipeVX {

    uint SWIPE_RIGHT_FEE;

    constructor(uint swipeFee) {
        SWIPE_RIGHT_FEE=swipeFee;
    }

    mapping(address=>address=>uint) public matchPool;

    // swipe right
    function swipeRight(address receiver) public {
        // if receiver already sent a like; consider this a match
        if(matchPool[receiver][msg.sender] > SWIPE_RIGHT_FEE) {
            match();
        }
        // set match pool
        matchPool[msg.sender][recevier] = SWIPE_RIGHT_FEE
        // deduct sender's balance
        transfer(receiver, SWIPE_RIGHT_FEE);
    }

    // swipe right pool txn

    // match
    function match(address contractAddr) public {
        result = ISwipeVerseProfile(contractAddr).match();
        return result;
    }

    // 
}
