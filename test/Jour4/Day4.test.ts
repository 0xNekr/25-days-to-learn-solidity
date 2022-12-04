import {expect} from "chai";
import {ethers} from "hardhat";

describe("Test Day4", async () => {

    let contract;
    let deployer;

    before(async () => {
        [deployer] = await ethers.getSigners();
        const Contract = await ethers.getContractFactory("Day4");
        contract = await Contract.deploy();
    })

    // @dev Test de l'import de Ownable
    it("'owner' doit retourner une adresse si Ownable est correctement importé.", async () => {
        expect(await contract.owner()).to.equal(deployer.address);
    })

    // @dev Test de la fonction retournerLeNumeroDuJour()
    it('retournerLeNumeroDuJour() doit renvoyer le numéro du jour (4)', async () => {
        const numeroDuJour = await contract.retournerLeNumeroDuJour();
        expect(numeroDuJour.toNumber()).to.equal(4);
    });

    // @dev Test de la fonction retournerLeNomDuJour()
    it('retournerLeNomDuJour() doit renvoyer le nom du jour (Dimanche)', async () => {
        const nomDuJour = await contract.retournerLeNomDuJour();
        expect(nomDuJour).to.equal("Dimanche");
    });

    // @dev Test de la fonction retounerLadresseDuContrat()
    it('retounerLadresseDuContrat() doit renvoyer l\'adresse du contract', async () => {
       const adresseDuContract = await contract.retounerLadresseDuContrat();
       expect(adresseDuContract).to.equal(contract.address);
    });
})
