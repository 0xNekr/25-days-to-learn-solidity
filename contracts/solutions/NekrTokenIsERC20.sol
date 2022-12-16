// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NekrTokenIsERC20 is ERC20, Ownable {

    mapping(address => bool) admins;
    uint256 public maxSupply = 1000000000 * 10**18;

    constructor() ERC20("Nekr Token", "NKTK") {}

    function mint(address _to, uint _amount) external {
        require(admins[msg.sender], "You can't mint, you are not admin");
        require(totalSupply() + _amount <= maxSupply, "Max supply exceeded");
        _mint(_to, _amount);
    }

    function addAdmin(address _admin) external onlyOwner {
        admins[_admin] = true;
    }

    function removeAdmin(address _admin) external onlyOwner {
        admins[_admin] = false;
    }
}
