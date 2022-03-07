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
 11:  * Based on https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/examples/SimpleToken.sol
 12:  */
 13: contract Simple777Token is ERC777 {
 14: 
 15:     /**
 16:      * @dev Constructor that gives msg.sender all of existing tokens.
 17:      */
 18:     constructor () ERC777("Simple777Token", "S7", new address[](0)) {
 19:         _mint(msg.sender, 10000 * 10 ** 18, "", "", true);
 20:     }
 21: }
