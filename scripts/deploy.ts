import { ethers } from "hardhat";

async function main() {
  const contractFactory = await ethers.getContractFactory("PledgePost");
  const contract = await contractFactory.deploy();
  console.log(`Contract deployed at: ${contract.target}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
