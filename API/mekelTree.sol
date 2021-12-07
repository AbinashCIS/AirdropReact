//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

//import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract MerkleProofTest {
  function verify(
    bytes32 root,
    bytes32 leaf,
    bytes32[] memory proof,
    uint256 index
  )
    public 
    pure
    returns (bool)
  {
    bytes32 computedHash = leaf;

    for (uint256 i = 0; i < proof.length; i++) {
      bytes32 proofElement = proof[i];

      if (index % 2 == 1) {
        computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
      } else {
        computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
      }
      
      index = index / 2;
    }

    return computedHash == root;
  }
}

/**
  Ref: https://github.com/Uniswap/merkle-distributor
 */
contract MerkleDistributor is MerkleProofTest{
    bytes32 public immutable merkleRoot;

    event Claimed(string transaction);

    constructor(bytes32 merkleRoot_) {
        merkleRoot = merkleRoot_;
    }

    function claim(
        string memory transaction,
        bytes32[] calldata merkleProof,
        uint256 index
    ) public {
        // Verify the merkle proof.
        bytes32 node = keccak256(abi.encodePacked(transaction));
    
        /*require(
            MerkleProof.verify(merkleProof, merkleRoot, node),
            "MerkleDistributor: Invalid proof."
        );*/
        
        require(
            verify(merkleRoot , node , merkleProof, index),
            "MerkleDistributor: Invalid proof."
        );

        // do your logic accordingly here

        emit Claimed(transaction);
    }
    
    // function claimTest(
    //     address account,
    //     uint256 amount,
    //     bytes32[] calldata merkleProof,
    //     uint256[] memory positions
    // ) public {
    //     // Verify the merkle proof.
    //     bytes32 node = keccak256(abi.encodePacked(account, amount));
    
    //     require(
    //         MerkleProofTest.verify( merkleRoot, node , merkleProof , positions) , 
    //         "MerkleDistributor: Invalid proof."
    //     );

    //     // do your logic accordingly here
    //     emit Claimed(account, amount);
    // }
    
    function getDecodedString(string memory _string) public view returns(bytes32){
        return keccak256("alice -> bob");
    }
    
    function getHash(address account , uint256 amount) public view returns(bytes32){
        bytes32 node = keccak256(abi.encodePacked(account, amount));
        return node;
    }
    
    function getMerkleRoon() public view returns(bytes32){
        return merkleRoot;
    }
}

//0x56c64ad7d0e3c106f23c2d406709c591b7c22deebbc2afb13e9b1460e9c1e03e
//["0xd24d002c88a75771fc4516ed00b4f3decb98511eb1f7b968898c2f454e34ba23","0x5c5af2aaaf7ceef8765334d7bca35ee11fa8463fdbca63d29a3f307ba8018e2f"]


