import { ethers } from "hardhat";

async function main(): Promise<{ factory: string }> {
  console.log("Starting Factory contract deployment...");

  const FactoryContract = await ethers.getContractFactory("Factory");
  console.log("Deploying Factory contract...");
  const factory = await FactoryContract.deploy();
  await factory.waitForDeployment();

  const factoryAddress = await factory.getAddress();
  console.log(`Factory contract deployed to: ${factoryAddress}`);

  // Fetch initial token and NFT counts
  const deployedTokens = await factory.getTokens();
  const deployedNFTs = await factory.getNFTs();

  console.log(`Initial token count: ${deployedTokens.length}`);
  console.log(`Initial NFT count: ${deployedNFTs.length}`);

  if (process.env.DEPLOY_SAMPLES === "true") {
    console.log("\nDeploying sample token and NFT for testing...");

    const sampleTokenTx = await factory.deployToken(
      "Sample Token",
      "STKN",
      ethers.parseEther("1000000")
    );
    await sampleTokenTx.wait();
    console.log("Sample token deployed");

    const sampleNftTx = await factory.deployNFT("Sample NFT", "SNFT");
    await sampleNftTx.wait();
    console.log("Sample NFT deployed");

    // Verify updated counts
    const updatedTokens = await factory.getTokens();
    const updatedNFTs = await factory.getNFTs();

    console.log(`Updated token count: ${updatedTokens.length}`);
    console.log(`Updated NFT count: ${updatedNFTs.length}`);
  }

  console.log("\nDeployment completed successfully!");

  return {
    factory: factoryAddress,
  };
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error("Error during deployment:", error);
    process.exit(1);
  });
