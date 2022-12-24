const { MerkleTree } = require('merkletreejs');
const keccak256 = require('keccak256');
const whitelist = require('../assets/whitelist.json');

export function GetMerkleRoot() {
    let wlTab = [];
    whitelist.map(a => {
        wlTab.push(a.address);
    })
    const leaves = wlTab.map(a => keccak256(a));
    const tree = new MerkleTree(leaves, keccak256, { sort: true });
    return tree.getHexRoot();
}

GetMerkleRoot();
