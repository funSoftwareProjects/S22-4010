  1: // SPDX-License-Identifier: MIT
  2: pragma solidity >=0.4.22 <0.9.0;
  3: 
  4: import "@openzeppelin/contracts/token/ERC777/ERC777.sol";
  5: 
  6: /**
  7:  * @title Simple777Token
  8:  * @dev Very simple ERC777 Token example, where all tokens are pre-assigned to the creator.
  9:  * Note they can later distribute these tokens as they wish using `transfer` and other
 10:  * `ERC20` or `ERC777` functions.
 11:  */
 12: contract Simple777Token is ERC777 {
 13: 
 14:     /**
 15:      * @dev Constructor that gives msg.sender all of existing tokens.
 16:      */
 17:     constructor () ERC777("Simple777Token", "S7", new address[](0)) {
 18:         _mint(msg.sender, 10000 * 10 ** 18, "", "", true);
 19:     }
 20: }
