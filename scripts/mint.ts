import { ethers } from "hardhat";

const toEther = (amount:number, unit = 'ether') => ethers.utils.parseUnits(amount.toString(), unit)

const main = async()=> {
  const [owner] = await ethers.getSigners()
  const token = await ethers.getContractAt("MyToken", '0x1Db6f0B4E780c7eccD9736090627e824E4abe83D' )
  await token.mint(owner.address, toEther(100))
  console.log(`completed add to mint`)
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
