// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Uncomment this line to use console.log ..
// import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Fairplay is ERC721, ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    constructor(string memory name, uint dob, Gender gender, uint last_location ) ERC721("John Doe", "johnydoe") {
        // addUser(name, dob, gender, last_location);
        // delegate call to adduser
    }

    enum Gender {
        Male, // 0
        Female, // 1
        Other // 2
    }

    struct player {
        address addr;
        string name; // short name (up to 32 bytes)
        uint dob; //  uint date = 1638352800; // 2012-12-01 10:00:00
        Gender gender; // Male/Female/Other; 0/1/2
        uint last_location; // https://stackoverflow.com/questions/8285599/
        string uri;
    }

    struct matchHistory {
        uint time;
        string eventType;
        address from;
        address to;
    }

    mapping(address => player) public users;
    mapping(address => address[]) public match_pool_users;
    mapping(address => matchHistory) public matches;
    // mapping(address => bool) public is_added;

    event AddUser(
        address indexed player_addr,
        string name,
        uint dob,
        Gender gender,
        uint location,
        string uri
    );

    function getLastLocation(address addr) public view returns (uint) {
        return users[addr].last_location;
    }

    function setLastLocation(uint last_location) public {
        users[msg.sender].last_location = last_location;
    }

    function getUser() public view returns (player memory) {
        return users[msg.sender];
    }

    function addUser(
        string memory name,
        uint dob,
        Gender gender,
        uint last_location
    ) public {
        // require(is_added[msg.sender] != true);
        users[msg.sender] = player({
            addr: msg.sender,
            name: name,
            dob: dob,
            gender: gender,
            last_location: last_location,
            uri: ''
        });
        // is_added[msg.sender] = true;
        emit AddUser(msg.sender, name, dob, gender, last_location, '');
    }

    function _baseURI() internal pure override returns (string memory) {
        return "https://example.com/nft/"; // https://ipfs.io/ipfs/QmPataWfcgTemUsiZczuZUdpdhrs2ZxGvx5DAnwHuktayM
    }

    function safeMint(address to, string memory uri) public onlyOwner {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
    }

    // The following functions are overrides required by Solidity.
    function _burn(
        uint256 tokenId
    ) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(
        uint256 tokenId
    ) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, ERC721URIStorage) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function makeMatch(address contractAddr, address sender, address receiver) public {
        matches[contractAddr] = matchHistory({
            time: 0,
            eventType: 'Match',
            from: sender,
            to: receiver
        });
    }
}
