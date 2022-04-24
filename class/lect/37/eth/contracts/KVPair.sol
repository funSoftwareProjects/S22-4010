// SPDX-License-Identifier: MIT
pragma solidity >=0.4.24 <0.9.0;

contract KVPair {

	event SetKVEvent(bytes32 key, bytes32 value);

	mapping (bytes32 => bytes32) public theData;

	constructor() { }

	function setKVPair(bytes32 key, bytes32 value) external {
		theData[key] = value;
		emit SetKVEvent(key, value);
	}

}
