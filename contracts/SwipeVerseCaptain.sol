// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

// import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
// import "@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol";
// import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
// import "./erc.sol";
import "./FairplayUser.sol";

contract SwipeVerseCaptain {
    // add support for moderators
    // add RBAC for owner and moderator actions
    // add support for events
    // add proxy pattern (uups => daimond)
    

    // check for swipe right on both accounts
    function checkMatch(address swiper, address receiver) public {
        // checks
        require(swiper == receiver ,"Swipe receiver cannot be self.");

        bool swiped;
        bytes memory err;
        FairplayUser r = FairplayUser(swiper);

        // make delegate call to check if receiver has swiper in swipe list
        (swiped, err) = receiver.call("checkRightSwipe");

        if (swiped == true) {
            // if both accounts swiped right then makeMatch()
            makeMatch(swiper, receiver);
        } else {
            r.swipeRight(receiver);
        }
    }

    function makeMatch(address swiper, address receiver) public {
        // deduct 1 token from both
        FairplayUser r = FairplayUser(receiver);
        FairplayUser s = FairplayUser(swiper);

        // make delegate call to both profiles 
        // and save the profiles to match list in each contract
        s.addToMatches(receiver);
        r.addToMatches(swiper);
        
        // emit match events for indexers
    }
}