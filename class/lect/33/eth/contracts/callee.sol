// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

// This is the contract that will get called.
// Migration file is ../migration/4_calldemo.js

contract Callee {
    uint public x;
    uint public value;

    function setX(uint _x) public returns (uint) {
        x = _x;
        return x;
    }

    function setXandSendEther(uint) public payable returns (uint256) {
        x = msg.value;
        return x;
    }
}

