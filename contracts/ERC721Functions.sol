// SPDX-License-Identifier: MIT
pragma solidity >=0.4.16 <0.9.0;
import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";


contract ERC721Functions is ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;
    uint public newItemId;
    Counters.Counter private _tokenIds;

    constructor() ERC721("Mona Lisa", "ML") {
    }
        function mintNFT(address recipient, string memory tokenURI) public returns(uint){
        _tokenIds.increment();
        newItemId = _tokenIds.current();
        _mint(recipient, newItemId);
        _setTokenURI(newItemId, tokenURI);
        console.log(newItemId, "tokenId");
        return newItemId;
    }
    function getTokenId() external  view returns(uint){
        return newItemId;
    }
    function setApproval(address operator, bool approved) external{
        _setApprovalForAll(msg.sender, operator, approved);

    }
    function transferNFT(address from,address to,uint tokenId) external{
        _transfer(from, to, tokenId);
    }
    function getownerOfNFT(uint id) external view returns(address){
        return ownerOf(id);
    }
}
