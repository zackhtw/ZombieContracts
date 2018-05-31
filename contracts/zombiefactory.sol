pragma solidity ^0.4.20;

import "./ownable.sol";
import "./safemath.sol";
contract ZombieFactory is Ownable{ // create a contract
  using SafeMath for uint256;// prevent overflow uint256 max + 1 = 1;
  using SafeMath32 for uint32;
  using SafeMath16 for uint16;
  event NewZombie(uint zombieId, string name, uint dna); // create an event and fire later
  uint dnaDigits = 16; // create an unsigned int
  uint dnaModulus = 10 ** dnaDigits;
  uint cooldownTime = 1 days;// time uint days
  struct Zombie { //create a struct
    string name;
    uint dna;
    uint32 level;// save gas when use uint32
    uint32 readyTime;
    uint16 winCount;
    uint16 lossCount;
  }

  Zombie[] public zombies; // arrary of Zombie named zombies
  mapping(uint => address) public zombieToOwner;//mapping uint values called zombieToOwner to adrress
  mapping(address => uint) ownerZombieCount;//mapping count to address
  //mapping can be consider as a customer data type that links to a value of any type, which can be used to compare values easily
  function _createZombie(string _name, uint _dna) internal { // create a function; make it interal so only ZombieFactroy contract and its inherits can call
    //zombies.push(Zombie(_name,_dna));//push a Zombie to zombies
    uint id = zombies.push(Zombie(_name, _dna,1,uint32(now+cooldownTime),0,0)) -1;//create id from index
    NewZombie(id,_name,_dna);
  }
  //view does not change state but can read states, cost no gas
  function _generateRandomDna(string _str) private view returns (uint){ //create a private view function
    uint rand = uint(keccak256(_str));//hash _str and convert is to uint
    return rand % dnaModulus;
  }

  function _createRandomZombie (string _name) private{ //make it private
    uint randDna = _generateRandomDna(_name);
    zombieToOwner[id]=msg.sender;// update id to user's address, msg.sender return address of owner
    ownerZombieCount[msg.sender] = ownerZombieCount[msg.sender].add(1);//update count user's address

    _createZombie(_name,randDna);

  }

  function createRandomZombie (string _name) public {
    require(ownerZombieCount[msg.sender]==0);// check to see if owner has any zombie and exectue lines
    uint randDna = _generateRandomDna(_name);
    _createZombie(_name,randDna);
  }
}|
