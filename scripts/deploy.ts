import { ethers } from "hardhat";

async function main() {
  const [owner] = await ethers.getSigners()
  
  const tokenFactory = await ethers.getContractFactory("MyToken");
  const myToken = await tokenFactory.deploy();
  
  await myToken.deployed();
  console.log(`The Token is :${await myToken.name()} & ${await myToken.symbol()}Token deployed to: ${myToken.address}`);
  console.log(`The Token Minter ${await myToken.minter()}`);

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
