// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface InterfaceERC721 {
    function mintNFT(address recipient, string memory tokenURI) external returns(uint);

    function setApproval(address operator, bool approved) external;

    // function NFTsafeTransfer(address to, uint256 tokenId) external;
    function getTokenId() external returns(uint);
    function transferNFT(address from,address to,uint id)  external;
    function getownerOfNFT(uint id) external returns(address);
}
