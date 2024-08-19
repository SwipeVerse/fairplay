// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Uncomment this line to use console.log ..
// import "hardhat/console.sol";

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract FairplayUser is ERC721URIStorage, Ownable {
    enum Gender {
        Male, // 0
        Female, // 1
        Other // 2
    }

    uint256 swTokenId;
    string swName; // short name (up to 32 bytes)
    uint swDOB; //  uint date = 1638352800; // 2012-12-01 10:00:00
    string swImagesURI; 
    Gender swGender; // Male/Female/Other; 0/1/2
    uint swLastLocation; // https://stackoverflow.com/questions/8285599/

    constructor(address initialOwner)
       ERC721("SwipeVerse", "SWX")
        Ownable()
        // call captain contract
        // make a delegate call to adduser
        // ERC721("TEst");
    {}

    function safeMint(address to, uint256 tokenId, string memory uri)
        public
        onlyOwner
    {
        swTokenId = tokenId;
        _safeMint(to, tokenId);

        // contains basic details like name, description/bio of profile;
        // details that should be allowed to update once in 30 days
        _setTokenURI(tokenId, uri);
    }

    function updateImageURI(string memory uri) public onlyOwner{
        swImagesURI = uri;
    }

    // should be allowed to update once in 30 days
    function updateTokenURI(uint256 tokenId, string memory uri) public onlyOwner{
        _setTokenURI(tokenId, uri);
    }

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
        override(ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721URIStorage)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}