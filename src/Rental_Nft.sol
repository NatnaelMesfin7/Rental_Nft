// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
// import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";


interface IRentalNFT is IERC721 {
    struct UserInfo {
        address user;
        uint64 expires;
    }
    event UpdateUser(
        uint256 indexed tokenId,
        address indexed user,
        uint64 expires
    );

    function setUser(uint256 tokenId, address user, uint64 expires) external;

    function userOf(uint256 tokenId) external view returns (address);

    function userExpires(uint256 tokenId) external view returns (uint256);
}

contract RentalNft is ERC721URIStorage, Ownable, IRentalNFT{
    mapping(uint256 => UserInfo) private users;

    constructor(
        string memory name,
        string memory symbol
    ) ERC721(name, symbol) Ownable(msg.sender) {}

    function mintNFT(
        address recipient,
        uint256 tokenId,
        string memory tokenURI
    ) public {
        require(msg.sender == owner(), "Only owner can mint");
        _mint(recipient, tokenId);
        _setTokenURI(tokenId, tokenURI);
    }

    function burnNFT(uint256 tokenId) public {
        require(msg.sender == ownerOf(tokenId), "Only owner can burn");
        _burn(tokenId);
    }

    function transferNFT(address to, uint256 tokenId) public {
        require(msg.sender == ownerOf(tokenId), "Only owner can transfer");
        _transfer(msg.sender, to, tokenId);
    }

    function isApprovedOrOwner(
        address requester,
        uint256 tokenId
    ) internal view returns (bool) {
        address owner = ownerOf(tokenId);
        return (requester == owner ||
            getApproved(tokenId) == requester ||
            isApprovedForAll(owner, requester));
    }

    function setUser(uint256 tokenId, address user, uint64 expires) external {
        // require(msg.sender == ownerOf(tokenId), "Only owner can set Users");
        require(
            isApprovedOrOwner(msg.sender, tokenId),
            "Caller is not owner nor approved"
        );
        if (expires < block.timestamp){
            users[tokenId] = UserInfo(address(0), 0);
        } else{
            users[tokenId] = UserInfo(user, expires);
        } 
        emit UpdateUser(tokenId, user, expires);
    }

    function userOf(uint256 tokenId) external view returns (address) {
        return users[tokenId].user;
    }

    function userExpires(uint256 tokenId) external view returns (uint256) {
        return users[tokenId].expires;
    }
}
