// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "../solutions/NekrIsERC721.sol";
import "../solutions/NekrTokenIsERC20.sol";

contract Staking_Jour21 {

    NekrTokenIsERC20 token;
    NekrIsERC721 nft;

    uint public totalStaked;

    struct StakeStruct {
        uint tokenId;
        uint stakingStartTime;
        address owner;
    }

    mapping (uint => StakeStruct) public StructByID;

    uint rewardsPerHour = 500000000000000000;

    event Staked(address indexed owner, uint tokenId, uint value);
    event UnStaked(address indexed owner, uint tokenId, uint value);
    event Claimed(address indexed owner, uint amount);

    constructor(NekrTokenIsERC20 _token, NekrIsERC721 _nft) {
        token = _token;
        nft = _nft;
    }

    function stake(uint[] calldata tokenIds) external {
        for (uint i = 0 ; i < tokenIds.length ; i++) {
            require(nft.ownerOf(tokenIds[i]) == msg.sender, "Not the owner");
            require(StructByID[tokenIds[i]].stakingStartTime == 0, "Already staked");

            nft.transferFrom(msg.sender, address(this), tokenIds[i]);
            emit Staked(msg.sender, tokenIds[i], block.timestamp);

            StructByID[tokenIds[i]] = StakeStruct({
            tokenId: tokenIds[i],
            stakingStartTime: block.timestamp,
            owner: msg.sender
            });
        }

        totalStaked += tokenIds.length;
    }

}
