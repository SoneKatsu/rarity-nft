// SPDX-License-Identifier: MIT
pragma solidity 0.8.11;

import "./interfaces/IRandomizer.sol";

contract Randomizer is IRandomizer {
    uint16[] public _buffer;

    constructor(uint16 amount) {
        for(uint16 i = 0; i < amount; i ++) {
            _buffer.push(i);
        }
    }

    function getRandomAvatar() external override returns (uint256) {
        require(_buffer.length > 0, "No NFT exist");

        uint256 randIdx;
        uint256 randNum;
        
        randIdx = uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, _buffer.length))) % (_buffer.length);
        randNum = _buffer[randIdx];
        _buffer[randIdx] = _buffer[_buffer.length - 1];
        _buffer.pop();

        return randNum + 1; //random number from 1 ~ 1000
    }

    function getBufferLength() public view returns (uint256) {
        return _buffer.length;
    }
}
