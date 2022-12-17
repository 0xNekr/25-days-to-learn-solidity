
async function main() {
    const contract = await ethers.getContractFactory("NekrTokenIsERC20");
    const Contract = await contract.deploy();
    console.log("Deploying contract...");
    await Contract.deployed();
    console.log("Contract deployed to:", Contract.address);
    console.log("yarn hardhat verify --network polygonMumbai", Contract.address); // verify the contract
}

main().then();
