import { ethers } from "hardhat";

async function main() {
  const Factory = await ethers.getContractFactory("Factory");

  const factory = await Factory.deploy();

  await factory.deployed();

  console.log("Factory contract deployed to:", factory.address);
  
}


main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

