pragma solidity ^0.4.20;

import "./zombieattack.sol";
import "./erc721.sol";

contract ZombieOwnership is zombieAttack, ERC721{
  mapping (uint => address) zombieApprovals; // mapping approved address
  function balanceOf(address _owner) public view returns (uint256 _balance) {
    // Return the number of zombies `_owner` has here
    return ownerZombieCount[_owner];
  }

  function ownerOf(uint256 _tokenId) public view returns (address _owner) {
    // 2. Return the owner of `_tokenId` here
    return zombieToOwner[_tokenId];
  }
  //logic of trnasfer
  function _transfer(address _from, address _to, uint256 _tokenId) private {
    ownerZombieCount[_to]=ownerZombieCount[_to].add(1);
    ownerZombieCount[_from]=ownerZombieCount[_from].sub(1);
    zombieToOwner[_tokenId] = _to;
    Transfer(_from, _to, _tokenId);// transfer event trigger

  }
  function transfer(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
    _transfer(msg.sender, _to, _tokenId);
  }

  function approve(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
    zombieApprovals[_tokenId] = _to;
    Approval(msg.sender, _to, _tokenId);
  }

  function takeOwnership(uint256 _tokenId) public {
    require(zombieApprovals[_tokenId] == msg.sender);
    address owner = ownerOf(_tokenId);
    _transfer(owner, msg.sender, _tokenId);
  }
}
