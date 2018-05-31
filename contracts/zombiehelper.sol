pragma solidity ^0.4.20;

import "./zombiefeeding.sol";

contract ZombieHelper is ZombieFeeding {
  uint levelUpFee = 0.001 ether;

  modifier aboveLevel(uint _level, uint _zombieId){ //modifier used for certain condition(ACL)
    require(zombies[_zombieId].level>=_level);
    _;
  }

  function withdraw() external onlyOwner {
    owner.transfer(this.balance); // this.balance return total balance on the contract
  }

  function setLevelUpFee(uint _fee) external onlyOwner {
    levelUpFee = _fee;
  }


  function levelUp(uint _zombieId) external payable{ //payable can send tokens
    require(msg.value==levelUpFee); // msg.values store value of payment along side with the address
    zombies[_zombieId].level++;
  }
  //able to change name when level >1
  function changeName(uint _zombieId, string _newName) external aboveLevel(2, _zombieId) ownOf(_zombieId){ //trigger when zombie level >1 only owner can call function
    //require(msg.sender==zombieToOwner[_zombieId]);//check if owner owns this zombie
    zombies[_zombieId].name=_newName;
  }
  // able to change dna when level > 20
  function changeDna(uint _zombieId, uint _newDna) external aboveLevel(20, _zombieId) ownOf(_zombieId){ //trigger when zombie level >1
    //require(msg.sender==zombieToOwner[_zombieId]);//check if owner owns this zombie
    zombies[_zombieId].dna=_newDna;
  }
  // display owner's zombie
  function getZombiesByOwner(address _owner) external view returns (uint[]){//storage is gas consuming use memory, memory will be created at the end of function
    uint[] memory result = new uint[](ownerZombieCount[_owner]);
    uint counter = 0;
    for (uint i=0;i<zombies.length;i++){
      if (zombieToOwner[i]==_owner){//compare to see if zombie belongs to owner
        result[counter]=i;
        counter++;
      }
    }
    return results;
  }
}
