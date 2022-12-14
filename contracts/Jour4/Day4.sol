// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/access/Ownable.sol";


contract Day4 is Ownable {

    constructor() {}

    function retournerLeNumeroDuJour() public pure returns (uint) {
        return 4;
    }

    function retournerLeNomDuJour() public pure returns (string memory) {
        return "Dimanche";
    }

    function retounerLadresseDuContrat () public view returns (address) {
        return address(this);
    }
}

