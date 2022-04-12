  1: // SPDX-License-Identifier: MIT
  2: pragma solidity >=0.4.22 <0.9.0;
  3: 
  4: contract SavedMessage {
  5:     string public currentMessage = "Hello World, from Ethereum";
  6: 
  7:     constructor() {
  8:     }
  9: 
 10:     function getCurrentMessageTxt() external view returns (string memory) {
 11:         return currentMessage;
 12:     }
 13: 
 14:     function setCurrentMessageTxt(string calldata _msg) external {
 15:         currentMessage = _msg;
 16:     }
 17: }
