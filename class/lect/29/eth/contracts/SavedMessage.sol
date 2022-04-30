// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract SavedMessage {
	string public currentMessage = "Hello World, from Ethereum";

	constructor() {
	}

	function getCurrentMessageTxt() external view returns (string memory) {
		return currentMessage;
	}

	function setCurrentMessageTxt(string calldata _msg) external {
		currentMessage = _msg;
	}
}
