import { time, loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect } from "chai";
import { ethers } from "hardhat";


const toEther = (amount: number, unit = 'ether') => ethers.utils.parseUnits(amount.toString(), unit)
const fromEther = (amount: number, unit = 'ether') => ethers.utils.formatUnits(amount.toString(), unit)

describe("Test MyToken",  ()=> {
  const initTest = async () => {
    const [owner, user] = await ethers.getSigners();
    const tokenFactory = await ethers.getContractFactory("MyToken");
    const myToken = await tokenFactory.deploy();

    return {myToken, owner, user}
  }

  describe("Deployment", async () => {
    it("Check token meta data", async () => {
      const {myToken, owner } = await loadFixture(initTest);
      expect(await myToken.minter()).to.equal(owner.address);
      expect(await myToken.name()).to.equal("ASD Token");
      expect(await myToken.symbol()).to.equal("ASD");
    });
  });

  describe("Mint", async () => {
    it("Only Minter can mint", async () => {
      const {myToken, user, owner} = await loadFixture(initTest);
      expect(myToken.connect(user).mint(user.address, toEther(1))).to.be.reverted
    })
    it("Mint exact amount", async () => {
      const {myToken, user, owner} = await loadFixture(initTest);
      const mintAmount = toEther(100)
      const beforeBalance = await myToken.balanceOf(user.address)
      await myToken.connect(owner).mint(user.address, mintAmount)
      const afterBalance = await myToken.balanceOf(user.address)
      expect(afterBalance.sub(beforeBalance)).to.equal(mintAmount)
      expect(afterBalance.sub(beforeBalance).eq(mintAmount))
    })
  })
});
