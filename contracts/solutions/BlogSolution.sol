// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

contract BlogSolution {

    struct Article {
        uint id;
        string titre;
        string texte;
        address auteur;
        uint timestamp;
    }

    mapping(uint => Article) public articles;

    uint public id = 0;

    address public auteur;

    event NouvelArticle(uint id, string titre, string texte, address auteur, uint timestamp);

    constructor() {
        auteur = msg.sender;
    }

    function modifierAuteur(address _auteur) public {
        require(msg.sender == auteur, "Vous n'etes pas l'auteur");
        auteur = _auteur;
    }

    function creerArticle(string memory _titre, string memory _texte) public {
        id++;
        require(msg.sender == auteur, "Vous n'etes pas l'auteur");
        articles[id] = Article(id, _titre, _texte, msg.sender, block.timestamp);
        emit NouvelArticle(id, _titre, _texte, msg.sender, block.timestamp);
    }

}
