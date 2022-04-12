// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract GenEvent {
	event DataChanged(bytes32 key, bytes32 value);

	mapping (bytes32 => bytes32) public savedData;

	constructor() {}

	function setData(bytes32 key, bytes32 value) external {
		savedData[key] = value;
		emit DataChanged(key, value);
	}
}
