pragma solidity ^0.4.20;

import "./zombiefactory.sol"; //import from another file
// create an interface
contract KittyInterface {
  function getKitty(uint256 _id) external view returns (
    bool isGestating,
    bool isReady,
    uint256 cooldownIndex,
    uint256 nextActionAt,
    uint256 siringWithId,
    uint256 birthTime,
    uint256 matronId,
    uint256 sireId,
    uint256 generation,
    uint256 genes
    );
}

contract ZombieFeeding is ZombieFactory { //create a new contract by inhert a contract
  /* // address of cyptokittens contract, where address of interface, use external contract
  address ckAddress = 0x06012c8cf97BEaD5deAe237070F9587f8E7A266d;
  //create kittycontract by call interface by address
  KittyInterface kittyContract = KittyInterface(ckAddress); */
  KittyInterface kittyContract;
  modifier onlyOwnerOf(uint _zombieId){
    require(msg.sender==zombieToOwner[_zombieId]);
    _;
  }
  function setKittyContractAddress(address _address) external onlyOwner{ // add modifier function (originally from ownable) so that only only can use this function
    kittyContract=KittyInterface(_address);
  }
  // set cooldowntime
  function _triggerCooldown(Zombie storage _zombie) internal{
    _zombie.readyTime=uint32(now + cooldownTime);
  }
  //check if cooldown is ready
  function _isReady(Zombie storage _zombie) internal view returns (bool){
    return (_zombie.readyTime <= now);
  }
  function feedAndMultiply(uint _zombieId, uint _targetDna, string _speices) internal onlyOwnerOf(_zombieId) {// internal makes it more secure, only onlyownerOf can use this function
      //require(msg.sender == zombieToOwner[_zombieId]);// check if zombie belongs to owner, replaced by ownOf
      Zombie storage myZombie = zombies[_zombieId];
      require(_isReady(myZombie));//require will not run lines of code after is not true
      _targetDna = _targetDna % dnaModulus; // tagetDna to length of 16
      uint newDna = (myZombie.dna + _targetDna) / 2; // breeding a new zombie
      if (keccak256(_species) == keccak256("kitty")){ //compare to see if it is a kitty
        newDna = newDna - newDna % 100 +99;
      }
      _createZombie("NoName", newDna);
      _triggerCooldown(myZombie);
  }

  function feedOnKitty(uint _zombieId, uint _kittyId) public{
        uint kittyDna;
        //store only kittyDna value from getKitty(var of interests), use ,,, for not interested
        (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);
        feedAndMultiply(_zombieId, kittyDna,"kitty");
    }

}
