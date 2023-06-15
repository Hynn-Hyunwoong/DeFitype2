import { time, loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect } from "chai";
import { ethers } from "hardhat";


const toEther = (amount: any, unit = 'ether') => ethers.utils.parseUnits(amount.toString(), unit)
const fromEther = (amount: any, unit = 'ether') => ethers.utils.formatUnits(amount.toString(), unit)

describe("Test MyToken", function () {
  async function initTest() {
    // TODO
  }

  describe("Deployment", async () => {
    it("Check token meta data", async () => {
      // TODO
    });
  });

  describe("Mint", async () => {
    it("Only Minter can mint", async () => {
      // TODO
    })
    it("Mint exact amount", async () => {
      // TODO
    })
  })
});
