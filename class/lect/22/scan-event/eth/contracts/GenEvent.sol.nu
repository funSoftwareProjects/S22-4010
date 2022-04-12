  1: // SPDX-License-Identifier: MIT
  2: pragma solidity >=0.4.22 <0.9.0;
  3: 
  4: contract GenEvent {
  5:     event DataChanged(bytes32 key, bytes32 value);
  6: 
  7:     mapping (bytes32 => bytes32) public savedData;
  8: 
  9:     constructor() {}
 10: 
 11:     function setData(bytes32 key, bytes32 value) external {
 12:         savedData[key] = value;
 13:         emit DataChanged(key, value);
 14:     }
 15: }
