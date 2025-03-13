// scripts/deploy.ts
import { ethers } from "hardhat";

async function main(): Promise<{ factory: string }> {
  console.log("Starting Factory contract deployment...");

  const FactoryContract = await ethers.getContractFactory("Factory");

  console.log("Deploying Factory contract...");
  const factory = await FactoryContract.deploy();
  
  await factory.waitForDeployment();
  
  const factoryAddress = await factory.getAddress();
  console.log(`Factory contract deployed to: ${factoryAddress}`);
  
  const tokenCount = await factory.tokenCount();
  const nftCount = await factory.nftCount();
  
  console.log(`Initial token count: ${tokenCount.toString()}`);
  console.log(`Initial NFT count: ${nftCount.toString()}`);
  
  if (process.env.DEPLOY_SAMPLES === "true") {
    console.log("\nDeploying sample token and NFT for testing...");
    
    const sampleTokenTx = await factory.deployToken(
      "Sample Token",
      "STKN",
      ethers.parseEther("1000000") 
    );
    
    const sampleTokenReceipt = await sampleTokenTx.wait();
    
    const tokenDeployedEvent = sampleTokenReceipt?.logs.find(
      (log) => {
        try {
          const parsedLog = factory.interface.parseLog(log);
          return parsedLog?.name === "TokenDeployed";
        } catch (e) {
          return false;
        }
      }
    );
    
    if (tokenDeployedEvent) {
      const parsedLog = factory.interface.parseLog(tokenDeployedEvent);
      const tokenAddress = parsedLog?.args[0];
      console.log(`Sample token deployed to: ${tokenAddress}`);
    }
    
    const sampleNftTx = await factory.deployNFT(
      "Sample NFT",
      "SNFT"
    );
    
    const sampleNftReceipt = await sampleNftTx.wait();
    
    const nftDeployedEvent = sampleNftReceipt?.logs.find(
      (log) => {
        try {
          const parsedLog = factory.interface.parseLog(log);
          return parsedLog?.name === "NFTDeployed";
        } catch (e) {
          return false;
        }
      }
    );
    
    if (nftDeployedEvent) {
      const parsedLog = factory.interface.parseLog(nftDeployedEvent);
      const nftAddress = parsedLog?.args[0];
      console.log(`Sample NFT deployed to: ${nftAddress}`);
    }
    
    // Verify the updated counts
    const updatedTokenCount = await factory.tokenCount();
    const updatedNftCount = await factory.nftCount();
    
    console.log(`Updated token count: ${updatedTokenCount.toString()}`);
    console.log(`Updated NFT count: ${updatedNftCount.toString()}`);
  }
  
  console.log("\nDeployment completed successfully!");
  
  return {
    factory: factoryAddress
  };
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error("Error during deployment:", error);
    process.exit(1);
  });