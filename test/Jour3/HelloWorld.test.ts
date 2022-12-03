const { expect } = require("chai");

describe("Test HelloWorld", async () => {

    let contract;

    before(async () => {
        const Contract = await ethers.getContractFactory("HelloWorld");
        contract = await Contract.deploy();
    })

    // @dev Test de la fonction
    it("La fonction 'helloWorld()' doit renvoyer 'Hello World !'", async () => {
        const helloWorld = await contract.helloWorld();
        expect(helloWorld).to.equal("Hello World !");
    })
})
