// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./multiown.sol";

contract FairplayUser is ERC721, ERC721URIStorage, Ownable {
    // constants
    address MultiOwnAddr;
    enum Gender {
        Male, // 0
        Female, // 1
        Other // 2
    }

    // variables
    uint256 swTokenId;
    string swName; // short name (up to 32 bytes)
    uint swDOB; //  uint date = 1638352800; // 2012-12-01 10:00:00
    string swImagesURI; 
    Gender swGender; // Male/Female/Other; 0/1/2
    uint swLastLocation; // https://stackoverflow.com/questions/8285599/

    mapping (address => bool) swipeList; // confirms if swiped on before
    mapping (address => bool) matchList; // confirms if the profile is in match list

    function isModerator() private view returns (bool) {
        // check if the address is a member of the moderator team
        MultiOwnable m = MultiOwnable(MultiOwnAddr);
        return m.isModerator();
    }

    modifier onlyModerator () {
        require(isModerator(),"Only Moderator can do this.");
        _;
    }

    constructor(address initialOwner, address multiownProxy)
       ERC721("SwipeVerse", "SWX")
        Ownable(initialOwner)
        // call captain contract
        // make a delegate call to adduser
        // ERC721("TEst");
    {
        MultiOwnAddr = multiownProxy;
    }

    // swipe controls
    function swipeRight(address _address) public {
        swipeList[_address] = true; // add address to the list to be swiped on
        // swipeList[_swipeId] = true; // add address to the list to be swiped on
    }

    // this needs checks; 
    // adding the address without verifying for right swipe first
    // can lead to users adding matches without other person's 
    // consent or original swipe
    function addToMatches(address _address) public {
        matchList[_address] = true; // add address to the match list
    }

    function checkRightSwipe(address _address) public view returns(bool) {
        return swipeList[_address]; // return true if swiped on
    }

    function requestSafeMint() public onlyOwner {}
    function requestProfileUpdate() public onlyOwner {}
    function requestImagesUpdate() public onlyOwner {}

    function getSwTokenId() public view returns(uint256) {
        return swTokenId;
    }

    function getImagesURI() public view returns(string memory) {
        return swImagesURI;
    }

    // The following functions are overrides required by Solidity.
    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    // ---------- Moderator Area ----------
    // profile creation
    function safeMint(address to, uint256 tokenId, string memory uri)
        public
        onlyModerator
    {
        swTokenId = tokenId;
        _safeMint(to, tokenId);

        // contains basic details like name, description/bio of profile;
        // details that should be allowed to update once in 30 days
        _setTokenURI(tokenId, uri);
    }

    function updateImageURI(string memory uri) public onlyModerator {
        swImagesURI = uri;
    }

    // should be allowed to update once in 30 days
    function updateTokenURI(uint256 tokenId, string memory uri) public onlyModerator {
        _setTokenURI(tokenId, uri);
    }
}