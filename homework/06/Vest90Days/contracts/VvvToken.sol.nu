  1: // SPDX-License-Identifier: MIT
  2: pragma solidity >=0.8.0 <0.9.0;
  3: 
  4: import "@openzeppelin/contracts/access/Ownable.sol";
  5: import "@openzeppelin/contracts/token/ERC777/ERC777.sol";
  6: 
  7: contract VvvToken is Ownable, ERC777 {
  8:     /**
  9:      * @dev Constructor that gives msg.sender all of existing tokens.
 10:      */
 11:     constructor () ERC777("VvvToken", "VVV", new address[](0)) {
 12:         // _mint(msg.sender, msg.sender, 100000000000 * 10 ** 18, "", "");
 13:         _mint(msg.sender, 100000000000 * 10 ** 18, "", "");
 14:     }
 15: }
