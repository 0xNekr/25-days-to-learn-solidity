// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";


contract NekrIsERC721_Jour11 is ERC721, Ownable {

    using Counters for Counters.Counter;
    using Strings for uint;

    Counters.Counter private _tokenIds;

    enum Step {
        SaleNotStarted,
        WhitelistSale,
        PublicSale,
        SoldOut
    }

    Step public currentStep;

    bytes32 public merkleRoot;

    uint public constant maxSupply = 20;
    uint public constant maxWhitelist = 10;

    uint public whitelistPrice = 0.5 ether;
    uint public publicPrice = 1 ether;

    mapping(address => uint) public amountMintedByAddress;

    string public baseTokenURI;

    constructor() ERC721("", ""){}

}
