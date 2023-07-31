import { ethers } from "hardhat";
import { expect } from "chai";
import { SignerWithAddress } from "@nomicfoundation/hardhat-ethers/signers";

describe("MyNFT Contract", function () {
  let NFTplay: any;
  let hardhatNFTplay: any;
  let ERC20Functions: any;
  let hardhatERC20Functions: any;
  let ERC721Functions: any;
  let hardhatERC721Functions: any;
  let user: SignerWithAddress[];
  let owner: SignerWithAddress;
  let user1: SignerWithAddress;
  let user2: SignerWithAddress;

  beforeEach(async () => {
    ERC20Functions = await ethers.getContractFactory("ERC20Functions");
    hardhatERC20Functions = await ERC20Functions.deploy();
    ERC721Functions = await ethers.getContractFactory("ERC721Functions");
    hardhatERC721Functions = await ERC721Functions.deploy();
    NFTplay = await ethers.getContractFactory("NFTplay");
    user = await ethers.getSigners();
    owner = user[0];
    user1 = user[1];
    user2 = user[2];
    hardhatNFTplay = await NFTplay.deploy(
      hardhatERC20Functions,
      hardhatERC721Functions
    );
  });
  describe("owner address,tokenid,tokenuri checked", function () {
    it("should check owner and tokenid", async function () {
      expect(await hardhatERC721Functions.getownerOfNFT(1n)).to.equal(
        owner.address
      );
      expect(await hardhatNFTplay.getNFTholder(1n)).to.equal(owner.address);
      await hardhatNFTplay.setPrice(500, 1n);
      expect(await hardhatNFTplay.getSellingPrice(1n)).to.equal(500);
      await hardhatERC20Functions.connect(user1).mint(user1.address);
      await hardhatNFTplay.connect(user1).buyNFT(1n);
      expect(await hardhatERC20Functions.findBalance(owner.address)).to.equal(
        500
      ); //Balance transferred to owner of NFT
      expect(await hardhatERC721Functions.getownerOfNFT(1n)).to.equal(
        user1.address
      ); //NFT Transferred successfully
      expect(await hardhatNFTplay.getNFTholder(1n)).to.equal(user1.address); //Details of id
      await hardhatNFTplay.connect(user1).anyoneMintHere(); //New Id minted
      expect(await hardhatNFTplay.getNFTholder(2n)).to.equal(user1.address);
      await hardhatNFTplay.connect(user1).setPrice(450, 2n);
      expect(await hardhatNFTplay.connect(user1).getSellingPrice(2n)).to.equal(
        450
      );
      await hardhatNFTplay.connect(owner).buyNFT(2n);
      expect(await hardhatERC721Functions.getownerOfNFT(2n)).to.equal(
        owner.address
      ); //NFT Transferred successfully
      expect(await hardhatERC20Functions.findBalance(owner.address)).to.equal(
        50
      ); //Balance transferred to owner of NFT
    });
  });
});
