// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";


contract NekrIsERC721 is ERC721, Ownable {

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

    bool public metadataFrozen = false;

    event newMint(address indexed sender, uint256 amount);
    event stepUpdated(Step currentStep);

    constructor(string memory _baseTokenURI, bytes32 _merkleRoot) ERC721("Calendar Collection", "CALCO") {
        Ownable(msg.sender);
        baseTokenURI = _baseTokenURI;
        merkleRoot = _merkleRoot;
    }

    function totalSupply() public view returns (uint) {
        return _tokenIds.current();
    }

    function mint(uint _count,  bytes32[] calldata _proof) external payable {
        require(currentStep == Step.WhitelistSale || currentStep == Step.PublicSale, "The sale is not open or closed ");
        uint current_price = getCurrentPrice();
        uint totalMinted = _tokenIds.current();

        if (currentStep == Step.WhitelistSale) {
            require(isWhitelisted(msg.sender, _proof), "Not whitelisted");
            require(amountMintedByAddress[msg.sender] + _count <= 1, "You can mint only 1 NFT per address");
            require(totalMinted + _count  <= maxWhitelist, "Max supply exceeded");
        }

        require(totalMinted + _count <= maxSupply, "The total supply has been reached.");
        require(msg.value >= current_price * _count, "Not enough funds to purchase.");

        for (uint i = 0; i < _count; i++) {
            uint newTokenID = _tokenIds.current();
            _mint(msg.sender, newTokenID);
            _tokenIds.increment();
        }

        emit newMint(msg.sender, _count);
    }

    function setBaseURI(string memory _baseTokenURI) public onlyOwner {
        require(!metadataFrozen, "Metadata are frozen");
        baseTokenURI = _baseTokenURI;
    }

    function freezeMetadata() public onlyOwner {
        metadataFrozen = true;
    }

    function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
        require(_exists(_tokenId),"ERC721Metadata: URI query for nonexistent token");
        return string(abi.encodePacked(baseTokenURI, _tokenId.toString()));
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

    function setStep(Step _step) external onlyOwner {
        currentStep = _step;
        emit stepUpdated(_step);
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
