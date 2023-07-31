// SPDX-License-Identifier: MIT
pragma solidity >=0.4.16 <0.9.0;
import "./InterfaceERC20.sol";
import "./InterfaceERC721.sol";

contract NFTplay {
    address public admin;
    InterfaceERC20 public inter20;
    InterfaceERC721 public inter721;
    mapping(uint => portfolio) public details;
    address public ownerhere;
    struct portfolio {
        address NFTholder;
        uint256 sellingPrice;
        address buyerAddress;
    }

    constructor(address _ERC20address, address _ERC721address) {
        inter20 = InterfaceERC20(_ERC20address);
        inter721 = InterfaceERC721(_ERC721address);
        admin = msg.sender;
         uint256 id = inter721.mintNFT(msg.sender, "My NFT");
        details[id].NFTholder = msg.sender;
    }
    function checkownerhere(uint enterId) public returns(address){
         ownerhere=inter721.getownerOfNFT(enterId);
         return ownerhere;
    }
    function anyoneMintHere() public{
        uint256 id = inter721.mintNFT(msg.sender, "My NFT");
        details[id].NFTholder = msg.sender; 
    }

    function setPrice(uint256 price,uint id) public {
        require(inter721.getownerOfNFT(id)==msg.sender,"Not the owner of NFT");
        details[id].sellingPrice = price;     
    }

    function transferingNFTCheck(address to, uint256 tokenId) public {
        inter721.transferNFT(ownerhere, to, tokenId);
    }

    // Enter id of NFT which u want to buy
    function buyNFT(uint256 id) public {
        address ownertotransfer = checkownerhere(id);
        require(details[id].sellingPrice!=0,"Not available for sale");
        require(
            inter20.findBalance(msg.sender) > details[id].sellingPrice,
            "First have some balance then buy"
        );
        details[id].buyerAddress = msg.sender;
        inter20.transfer(msg.sender, ownertotransfer, details[id].sellingPrice);
        inter721.transferNFT(ownertotransfer, msg.sender, id);
        ownertotransfer = checkownerhere(id);
        details[id].NFTholder=msg.sender;  
        details[id].sellingPrice=0;   
    }
    function getNFTholder(uint id) external view returns(address){
        return details[id].NFTholder;
    }
    function getSellingPrice(uint id) external view returns(uint){
        return details[id].sellingPrice;
    }
    function getBuyerAddress(uint id) external view returns(address){
        return details[id].buyerAddress;
    }
}
