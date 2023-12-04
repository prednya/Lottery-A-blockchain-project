// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Lottery{
 //entities - manager,players and winner
 address public manager;    //can be made private or internal
 address payable[] public players;  //dynamic - can send and receive ethers
 address payable public winner;  //can receive eithers

  mapping(address => bool) public participants;
  
  constructor(){
      manager=msg.sender;   //during deployment, this constructor will run and whoever deploys 
      //the smart contract, their address will be stored
  }

  function getPlayers() public view returns (address payable[] memory) {
        return players;
  }
  
  function isParticipant(address _address) public view returns (bool) {
    for (uint i = 0; i < players.length; i++) {
        if (players[i] == payable(_address)) {
            return true;
        }
    }
    return false;
  } 

  function getNumberOfParticipants() public view returns (uint) {
    return players.length;
  }

// payable bacause they have to send ethers to participate
  function participate() public payable{
      require(msg.value==1 ether,"Please pay 1 ether only");
      players.push(payable(msg.sender));
  }

  function getBalance() public view returns(uint){
      require(manager==msg.sender,"You are not the manager");
      return address(this).balance;
  }

  function random() internal view returns(uint){
      return uint(keccak256(abi.encodePacked(blockhash(block.number-1), block.timestamp, players.length)));
  }

  function pickWinner() public{
      require(manager==msg.sender,"You are not the manager");
      require(players.length>=3,"Players are less than 3");

      uint r=random();
      uint index = r%players.length;
      winner=players[index];
      winner.transfer(getBalance());
      players= new address payable[](0); //this will intiliaze the players array back to 0
  }
}