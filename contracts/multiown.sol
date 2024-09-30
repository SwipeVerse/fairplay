// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
    
import "@openzeppelin/contracts/access/AccessControl.sol";


// add multiple owners
contract MultiOwnable is AccessControl {
    // mapping (address => bool) isOwner;
    // address owners = [];
    bytes32 public constant MODERATOR_ROLE = keccak256("SWIPEVERSE_MODERATOR");
    bytes32 public constant ADMIN_ROLE = keccak256("SWIPERVERSE_ADMIN");
    enum ActionType {
        AddModerator,
        RemoveModerator
    }
    uint actionId;
    struct Action {
        ActionType actType;
        address moderatorAddress;
        bool executionStatus;
        address[] votedIn;
        address[] ModeratorVotes;
        // date of action
        // date of execution
    }
    // struct ModeratorVotes {
    //     address[] votedIn;
    // }
    mapping(uint => Action) actions;
    //address[] ModeratorsList;
    address[] AdminsList;

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
        actionId=0;
    }

    function setModerator() public onlyAdmin {
        _grantRole(MODERATOR_ROLE, msg.sender);
        //ModeratorsList.push(msg.sender);
    }

    function setAdmin() public {
        _grantRole(ADMIN_ROLE, msg.sender);
        AdminsList.push(msg.sender);
    }

    function isModerator() public view returns (bool) {
        return hasRole(MODERATOR_ROLE, msg.sender);
    }

    function isAdmin() public view returns (bool) {
        return hasRole(ADMIN_ROLE, msg.sender);
    }


    function proposeRemoveModerator() public onlyModerator {
        uint id = actionId+1;
        Action memory action = Action({
            actType: ActionType.RemoveModerator,
            moderatorAddress: msg.sender,
            executionStatus: false,
            votedIn: new address[](0), // empty for admins address
            ModeratorVotes: new address[](0) // empty for moderators
        });
        actions[id] = action;
        actionId++;
    }
    function voteRemoveModerator(uint _actionId) public onlyModerator {}
    function voteRemoveModeratorAdmins(uint _actionId) public onlyAdmin {
        // if voted in, then do nothing and return
        for(uint i=0; i<actions[_actionId].votedIn.length; i++) {
            if (actions[_actionId].votedIn[i] == msg.sender) {
                return;
            }
        }
        // if not voted in, then vote in and update votedIn array
        actions[_actionId].votedIn.push(msg.sender);
        // execute if more than 50% votes are in
        if(actions[_actionId].votedIn.length >= (AdminsList.length/2 + 1 )) {
            removeModerator(actions[_actionId].moderatorAddress);
            actions[_actionId].executionStatus = true;
        }
    }

    function removeModerator(address moderatorAddress) private onlyAdmin {
        _revokeRole(MODERATOR_ROLE, moderatorAddress);
        // execute reward slashing logic
    }
}