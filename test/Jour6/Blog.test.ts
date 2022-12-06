import {expect} from "chai";
import {ethers} from "hardhat";

describe("Test Blog", async () => {

    let contract;
    let deployer;
    let nouvelAuteur

    before(async () => {
        [deployer, nouvelAuteur] = await ethers.getSigners();
        const Contract = await ethers.getContractFactory("Blog");
        contract = await Contract.deploy();
    })

    // @dev A la création du contrat, votre adresse doit être enregistrer en tant qu’auteur
    it("L'adresse qui déploie le contrat doit être enregistrée en tant qu'auteur", async () => {
        const auteur = await contract.auteur();
        expect(auteur).to.equal(deployer.address);
    });

    // @dev Il n’y a que l’auteur qui peut ajouter un article
    it("Seul l'auteur peut ajouter un article", async () => {
        const article = "Mon premier article";
        const texte = "Mon premier texte";
        await expect(contract.connect(nouvelAuteur).creerArticle(article, texte)).to.be.reverted;
    });

    // @dev L'auteur peut ajouter un article
    it("L'auteur peut ajouter un article et un event est envoyé", async () => {
        const article = "Mon premier article";
        const texte = "Mon premier texte";
        await expect(contract.creerArticle(article, texte)).to.emit(contract, "NouvelArticle");
    });

    // @dev Quelqu'un qui n'est pas auteur ne doit pas pouvoir modifier l'auteur actuel
    it("Seul l'auteur peut modifier l'auteur actuel", async () => {
        await expect(contract.connect(nouvelAuteur).modifierAuteur(nouvelAuteur.address)).to.be.reverted;
        await contract.connect(deployer).modifierAuteur(nouvelAuteur.address);
        const auteur = await contract.auteur();
        expect(auteur).to.equal(nouvelAuteur.address);
    });

    // @dev Il est possible de récupérer un article via son ID
    it("Il est possible de récupérer un article via son ID", async () => {
        const premierArticle = await contract.articles(1);
        expect(premierArticle.id).to.equal(1);
        expect(premierArticle.titre).to.equal("Mon premier article");
        expect(premierArticle.texte).to.equal("Mon premier texte");
    });

    // @dev Il est possible de récupérer la liste des articles via une boucle off-chain grâce à l'id.
    it("Il est possible de récupérer la liste des articles via une boucle off-chain grâce à l'id", async () => {
        for (let i = 2; i <= 4; i++) {
            await contract.connect(nouvelAuteur).creerArticle("Mon article " + i, "Mon texte " + i);
        }

        const NombreArticles = await contract.id();
        for (let i = 1; i <= NombreArticles.toNumber(); i++) {
            const article = await contract.articles(i);
            if (i === 1) {
                expect(article.titre).to.equal("Mon premier article");
                expect(article.texte).to.equal("Mon premier texte");
            } else {
                expect(article.id).to.equal(i);
                expect(article.titre).to.equal("Mon article " + i);
                expect(article.texte).to.equal("Mon texte " + i);
            }
        }
    });
})
