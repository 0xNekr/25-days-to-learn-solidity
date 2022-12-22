// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "../solutions/NekrIsERC721.sol";
import "../solutions/NekrTokenIsERC20.sol";

contract Staking_Jour22 {


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

    function getRewards(address owner, uint[] calldata tokenIds) external view returns(uint) {
        uint totalEarned;

        for (uint i = 0 ; i < tokenIds.length ; i++) {
            require(StructByID[tokenIds[i]].owner == owner, "All owners are not the same");

            uint stakingStartTime = StructByID[tokenIds[i]].stakingStartTime;
            totalEarned += (block.timestamp - stakingStartTime) * rewardsPerHour / 3600;
        }

        return totalEarned;
    }

    function claim(uint[] calldata tokenIds) external {
        _claim(msg.sender, tokenIds, false);
    }

    function _claim(address _owner, uint[] calldata _tokenIds, bool _unstake) internal {
        uint totalEarned;

        for (uint i = 0 ; i < _tokenIds.length ; i++) {
            require(StructByID[_tokenIds[i]].owner == _owner, "Not the owner, you cannot claim the awards");

            uint stakingStartTime = StructByID[_tokenIds[i]].stakingStartTime;
            totalEarned += (block.timestamp - stakingStartTime) * rewardsPerHour / 3600;

            StructByID[_tokenIds[i]] = StakeStruct({
                tokenId: _tokenIds[i],
                stakingStartTime: block.timestamp,
                owner: _owner
            });
        }

        if (totalEarned > 0) {
            token.mint(_owner, totalEarned);
        }

        if (_unstake) {
            // _unstakeNFT(_owner, _tokenIds);
        }

        emit Claimed(_owner, totalEarned);
    }

}
