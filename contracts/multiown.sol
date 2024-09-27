// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/access/AccessControl.sol";


// add multiple owners
contract MultiOwnable is AccessControl {
    // mapping (address => bool) isOwner;
    // address owners = [];
    bytes32 public constant MODERATOR_ROLE = keccak256("SWIPEVERSE_MODERATOR");
    bytes32 public constant ADMIN_ROLE = keccak256("SWIPERVERSE_ADMIN");

    modifier onlyModerator() {
        require(hasRole(MODERATOR_ROLE, _msgSender()), "Only moderator can perform this action");
        _;
    }

    modifier onlyAdmin() {
        require(hasRole(ADMIN_ROLE, _msgSender()), "Only admin can perform this action");
        _;
    }

    constructor(address defaultAdmin) {
        _grantRole(ADMIN_ROLE, defaultAdmin);
    }

    function setModerator() public onlyAdmin {
        _grantRole(MODERATOR_ROLE, msg.sender);
    }

    function setAdmin() public {
        _grantRole(ADMIN_ROLE, msg.sender);
    }

    function isModerator() public view returns (bool) {
        return hasRole(MODERATOR_ROLE, msg.sender);
    }

    function isAdmin() public view returns (bool) {
        return hasRole(ADMIN_ROLE, msg.sender);
    }
}