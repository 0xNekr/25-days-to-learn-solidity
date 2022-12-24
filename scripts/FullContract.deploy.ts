import {run} from "hardhat";
import {GetMerkleRoot} from "./GetMerkleRoot";

async function FullContract() {

    // Récupération de tous les contrats
    const token = await ethers.getContractFactory("NekrTokenIsERC20");
    const nft = await ethers.getContractFactory("NekrIsERC721");
    const staking = await ethers.getContractFactory("Staking");

    // Définition de l'URI IPFS :
    const uri = 'ipfs://QmeSjSinHpPnmXmspMjwiXyN6zS4E9zccariGR3jxcaWtq/';

    /*
     * Voici comment doit se dérouler le déploiement :
     * 1 - Déploiement du token ERC20 & ERC721
     * 2 - Déploiement du staking avec les adresses des contrats précédents
     * 3 - Ajout des droits de minter sur le token ERC20 pour le staking (addAdmin)
     */

    console.log("Deploying token...");
    const Token = await token.deploy();
    await Token.deployed();
    console.log("Token deployed to:", Token.address);
    console.log("Waiting 5 seconds before verifying the token... (to avoid errors)");
    await delay(5000);
    console.log("Verify token contract...")
    try {
        await run(`verify:verify`, {
            address: Token.address,
            constructorArguments: [],
        })
        console.log("Token verified !")
    } catch (error) {
        console.log("Already verified");
    }

    console.log("Get merkle root...");
    const merkleRoot = GetMerkleRoot();
    console.log("Whitelist root :", merkleRoot);

    console.log("Deploying NFT...");
    const NFT = await nft.deploy(
        uri,
        merkleRoot
    );
    await NFT.deployed();
    console.log("NFT deployed to:", NFT.address);
    console.log("Waiting 5 seconds before verifying the NFT... (to avoid errors)");
    await delay(5000);
    console.log("Verify NFT contract...")
    try {
        await run(`verify:verify`, {
            address: NFT.address,
            constructorArguments: [
                uri,
                merkleRoot
            ],
        })
        console.log("NFT verified !")
    } catch (error) {
        console.log("Already verified");
    }

    console.log("Deploying staking...");
    const Staking = await staking.deploy(Token.address, NFT.address);
    await Staking.deployed();
    console.log("Staking deployed to:", Staking.address);

    console.log("Waiting 5 seconds before verifying the staking... (to avoid errors)");
    await delay(5000);
    console.log("Verify staking contract...")
    try {
        await run(`verify:verify`, {
            address: Staking.address,
            constructorArguments: [
                Token.address,
                NFT.address
            ],
        })
        console.log("Staking verified !")
    } catch (error) {
        console.log("Already verified");
    }

    console.log("Adding admin rights to staking for token...");
    await Token.addAdmin(Staking.address);
    console.log("Admin rights added to staking for token.");

    console.log("Resume : ")
    console.log("Token address :", Token.address);
    console.log("NFT address :", NFT.address);
    console.log("Staking address :", Staking.address);
}

FullContract().then();

const delay = ms => new Promise(res => setTimeout(res, ms));
