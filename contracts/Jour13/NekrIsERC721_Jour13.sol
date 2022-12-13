// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";


contract NekrIsERC721_Jour13 is ERC721, Ownable {

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

    event newMint(address indexed sender, uint256 amount);
    event stepUpdated(Step currentStep);

    constructor(string memory _baseTokenURI, bytes32 _merkleRoot) ERC721("Calendar Collection", "CALCO") {
        baseTokenURI = _baseTokenURI;
        merkleRoot = _merkleRoot;
    }

    function withdraw() external onlyOwner {
        require(address(this).balance > 0, "Nothing to withdraw");
        payable(msg.sender).transfer(address(this).balance);
    }

    function updatePublicPrice(uint _newPrice) external onlyOwner {
        publicPrice = _newPrice;
    }

    function updateWhitelistPrice(uint _newPrice) external onlyOwner {
        whitelistPrice = _newPrice;
    }

    function getCurrentPrice() public view returns (uint) {
        if (currentStep == Step.WhitelistSale) {
            return whitelistPrice;
        } else {
            return publicPrice;
        }
    }

    function setMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
        merkleRoot = _merkleRoot;
    }

    function isWhitelisted(address _account, bytes32[] calldata proof) public view returns(bool) {
        return _verify(_leaf(_account), proof);
    }

    function _leaf(address _account) internal pure returns(bytes32) {
        return keccak256(abi.encodePacked(_account));
    }

    function _verify(bytes32 leaf, bytes32[] memory proof) internal view returns(bool) {
        return MerkleProof.verify(proof, merkleRoot, leaf);
    }

}
