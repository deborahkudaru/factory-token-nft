const { ethers } = require("hardhat");

async function main() {
  const Factory = await ethers.getContractFactory("Factory");

  // Deploy the Factory contract
  const factory = await Factory.deploy();
  await factory.deployed();

  console.log("Factory deployed to:", factory.address);

  // Deploy a new ERC20 token using the Factory
  const tokenName = "MyToken";
  const tokenSymbol = "MTK";
  const tokenSupply = ethers.utils.parseEther("1000000"); 

  const tokenAddress = await factory.deployToken(tokenName, tokenSymbol, tokenSupply);
  console.log("ERC20 Token deployed to:", tokenAddress);

  const nftName = "MyNFT";
  const nftSymbol = "MNFT";

  const nftAddress = await factory.deployNFT(nftName, nftSymbol);
  console.log("NFT deployed to:", nftAddress);

  const tokenCount = await factory.tokenCount();
  const nftCount = await factory.nftCount();

  console.log("Total Tokens deployed:", tokenCount.toString());
  console.log("Total NFTs deployed:", nftCount.toString());
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });