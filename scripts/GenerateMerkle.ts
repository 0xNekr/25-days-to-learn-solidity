const { MerkleTree } = require('merkletreejs');
const keccak256 = require('keccak256');
const whitelist = require('../assets/whitelist.json');

function GenerateMerkle() {
    let wlTab = []; // Tableau des adresses de la whitelist

    // Itération sur toutes les adresses de la whitelist pour les ajouter au tableau
    whitelist.map(a => {
        wlTab.push(a.address);
    })

    // Création des feuilles de l'arbre de merkle
    const leaves = wlTab.map(a => keccak256(a));

    // Création de l'arbre de merkle
    const tree = new MerkleTree(leaves, keccak256, { sort: true });

    // Récupération de la racine de l'arbre de merkle
    const root = tree.getHexRoot();
    console.log("Whitelist root :", root);

    const addressToCheck = "0xBcD09dfEc85285eE39D7CbF195fc973CdE2213c2";
    // Vérification de l'existence d'une adresse dans l'arbre de merkle
    const proof = tree.getHexProof(keccak256(addressToCheck));
    console.log('Merkle proof for', addressToCheck, ':', proof);
}

GenerateMerkle();


