// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Lottery {
    address private manager;
    address[] private players;
    address private lastWinner;
    uint256 public jackpot;

    constructor() {
        manager = msg.sender;
    }

    modifier restricted() {
        require(msg.sender == manager, "You must be a manager to run this function");
        _;
    }

    function enter() public payable {
        require(msg.value >= 1 ether, "You must send a minimum of 1 ether");
        players.push(msg.sender);
        jackpot = address(this).balance / 1000000000000000000;
    }

    function random() private view returns (uint) {
        return uint(keccak256(abi.encode(block.difficulty, block.timestamp, players)));
    }

    function pickWinner() public restricted {
        uint index = random() % players.length;
        lastWinner = players[index];
        payable(lastWinner).transfer(address(this).balance);
        players = new address[](0);
        jackpot = 0;
    }

    function getLastWinnder() public view returns (address) {
        return lastWinner;
    }

    function getPlayers() public view returns (address[] memory) {
        return players;
    }

    function getManager() public view returns (address) {
        return manager;
    }
}