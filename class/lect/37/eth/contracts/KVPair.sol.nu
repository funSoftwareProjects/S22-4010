  1: // SPDX-License-Identifier: MIT
  2: pragma solidity >=0.4.24 <0.9.0;
  3: 
  4: contract KVPair {
  5: 
  6:     event SetKVEvent(bytes32 key, bytes32 value);
  7: 
  8:     mapping (bytes32 => bytes32) public theData;
  9: 
 10:     constructor() { }
 11: 
 12:     function setKVPair(bytes32 key, bytes32 value) external {
 13:         theData[key] = value;
 14:         emit SetKVEvent(key, value);
 15:     }
 16: 
 17: }
