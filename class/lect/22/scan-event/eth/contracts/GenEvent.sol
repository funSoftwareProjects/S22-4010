// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract GenEvent {
	event DataChanged(bytes32 key, uint256 value);

	mapping (bytes32 => uint256) public savedData;

	constructor() {}

	function setData(bytes32 key, uint256 value) external {
		savedData[key] = value;
		emit DataChanged(key, value);
	}
}
