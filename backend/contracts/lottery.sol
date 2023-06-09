// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

contract Lottery{
    address payable[] public players;

    address manager;

    address payable public winner;

    constructor(){
        manager=msg.sender;
    }

    receive() external payable  {
        require(msg.value>= 1 ether,"Enter Valid Amount");
        players.push(payable(msg.sender));
    }

    function getBalance() public view returns(uint){
        require(msg.sender==manager,"You are not a manger");
        return address(this).balance;
    }

    function random() internal view returns(uint) {
        return uint(keccak256(abi.encodePacked(block.prevrandao,block.timestamp,players.length)));
    }

    function pickWinner() public {
        require(msg.sender==manager,"You are not a manager");
        require(players.length>=3,"Player are less than 3");

        uint r=random();
        uint index=r%players.length;

        winner=players[index];
        winner.transfer(getBalance());
        players=new address payable[](0);
    }

    function allPlayers() public view returns(address payable[] memory){
        return players;
    }


}