pragma solidity ^0.4.19; // solidity version

contract ZombieFactory{ // create a contract
  event NewZombie(uint zombieId, string name, uint dna); // create an event and fire later
  uint dnaDigits = 16; // create an unsigned int
  uint dnaModulus = 10 ** dnaDigits;
  
  struct Zombie { //create a struct
    string name;
    uint dna;
  
  }
  
  Zombie[] public zombies; // arrary of Zombie named zombies
  
  function _createZombie(string _name, uint _dna) private{ // create a function; make it private so only ZombieFactroy contract can call
    //zombies.push(Zombie(_name,_dna));//push a Zombie to zombies
    uint id = zombies.push(Zombie(_name, _dna)) -1;//create id from index
    NewZombie(id,_name,_dna);
  }
  //view does not change state but can read states, cost no gas
  function _generateRandomDna(string _str) privateview returns (uint){ //create a private view function
    uint rand = uint(keccak256(_str));//hash _str and convert is to uint
    return rand % dnaModulus;
  }
  
  function createRandomZombie (string _name) public{
    uint randDna = _generateRandomDna(_name);
    _createZombie(_name,randDna);
    
  }
  
}|
