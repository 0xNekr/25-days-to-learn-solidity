// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

contract HelloWorldSolution {

    constructor() {}

    // Créez une fonction qui renvoie "Hello World !" lorsque vous appelez la fonction
    function helloWorld() public pure returns (string memory) {
        return "Hello World !";
    }
}
