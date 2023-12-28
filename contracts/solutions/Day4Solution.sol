// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Day4Solution is Ownable {

    constructor() {
        Ownable(msg.sender);
    }

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

