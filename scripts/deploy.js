async function main(){
    const AddressSoul = await ethers.getContractFactory("SoulBoundTokens");
    const gasPrice = await AddressSoul.signer.getGasPrice();
    console.log(`Current gas price: ${gasPrice}`);

    const estimatedGas = await AddressSoul.signer.estimateGas(
        AddressSoul.getDeployTransaction("AddressSoul",500000000)
    );
    
    console.log(`Estimated gas: ${estimatedGas}`);

    const deploymentPrice = gasPrice.mul(estimatedGas);
    const deployerBalance = await AddressSoul.signer.getBalance();
    console.log(`Deployer balance:  ${ethers.utils.formatEther(deployerBalance)}`);
    console.log( `Deployment price:  ${ethers.utils.formatEther(deploymentPrice)}`);
    if (Number(deployerBalance) < Number(deploymentPrice)) {
        throw new Error("Not enough balance to deploy.");
    }

    const myNFT = await AddressSoul.deploy("AddressSoul",500000000);
    await myNFT.deployed();
    console.log("Contract deployed to address:", myNFT.address);
}

main().then(() => process.exit(0)).catch((error) => {
    console.error("Error:", error);
    process.exit(1);
});