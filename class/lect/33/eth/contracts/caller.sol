// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

// This is the contract that will do the calling.
// Note the constructor
// Migration file is ../migration/4_calldemo.js

import "./Callee.sol";

contract Caller {
	address _callee;

	constructor ( address _address_for_contrct ) {
		_callee = _address_for_contrct ;
	}

    function setXFromAddress(uint _x) public {
        Callee callee = Callee(_callee);
        callee.setX(_x);
    }

    function setXandSendEther(uint _x) public payable returns ( uint256 ) {
        Callee callee = Callee(_callee);
        uint256 x = callee.setXandSendEther{value: msg.value}(_x);
		return x;
    }
}
