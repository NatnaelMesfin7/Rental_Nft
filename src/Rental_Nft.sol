// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "openzeppelin-contracts/contracts/token/ERC721/IERC721.sol";

// import "openzeppelin-contracts/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

interface IRentalNFT is IERC721 {
struct UserInfo {
address user;
uint64 expires;
}
event UpdateUser(uint256 indexed tokenId, address indexed user, uint64 expires);
function setUser(uint256 tokenId, address user, uint64 expires) external;
function userOf(uint256 tokenId) external view returns (address);
function userExpires(uint256 tokenId) external view returns (uint256);
}


contract RentalNft is ERC721, Ownable{
    constructor() ERC721("RentalNft","RentalNft") Ownable(msg.sender){}

    function mintNFT(address recipient, uint256 tokenId/*, string memory tokenURI*/) public onlyOwner{
        _mint(recipient,tokenId);
        // _setTokenURI(tokenId, tokenURI);
    }

    function burnNFT(uint256 tokenId) public  {
        // require(_isApprovedOrOwner(msg.sender, tokenId));
        // int16 t = _isApprovedOrOwner(msg.sender, tokenId);
        //  require(tokenId,"Caller is not the owner");
        _burn(tokenId);
    }
    
    function transferNFT(address to,uint256 tokenId)public {
        _transfer(msg.sender,to,tokenId);
    }


}


