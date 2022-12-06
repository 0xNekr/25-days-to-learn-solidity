// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract Blog {

    // @dev : Une structure contenant les infos de l'article avec comme noms (id, titre, texte, auteur et timestamp);

    // @dev : Un mapping contenant les articles par id avec comme nom (articles)

    // @dev : Une variable (id) qui peut être récupérée

    // @dev : Une variable (auteur) qui peut être récupérée

    // @dev : Un événement (NouvelArticle) avec toutes les informations de l'article

    // @dev : Le créateur du contrat doit devenir auteur à la création
    constructor() {

    }

    // @dev : Une fonction (modifierAuteur) qui permet de modifier l'auteur du blog, seulement par l'auteur actuel

    // @dev : Une fonction (creerArticle) qui permet d'ajouter un article, seulement par l'auteur actuel
    // elle doit émettre un événement NouvelArticle avec toutes les informations de l'article
}
