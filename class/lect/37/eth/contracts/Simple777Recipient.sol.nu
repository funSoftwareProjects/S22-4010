  1: // SPDX-License-Identifier: MIT
  2: pragma solidity >=0.4.22 <0.9.0;
  3: 
  4: import "@openzeppelin/contracts/token/ERC777/IERC777.sol";
  5: import "@openzeppelin/contracts/utils/introspection/IERC1820Registry.sol";
  6: import "@openzeppelin/contracts/token/ERC777/IERC777Recipient.sol";
  7: 
  8: /**
  9:  * @title Simple777Recipient
 10:  * @dev Very simple ERC777 Recipient
 11:  */
 12: contract Simple777Recipient is IERC777Recipient {
 13: 
 14:     IERC1820Registry private _erc1820 = IERC1820Registry(0x1820a4B7618BdE71Dce8cdc73aAB6C95905faD24);
 15:     bytes32 constant private TOKENS_RECIPIENT_INTERFACE_HASH = keccak256("ERC777TokensRecipient");
 16: 
 17:     IERC777 private _token;
 18: 
 19:     event DoneStuff(address operator, address from, address to, uint256 amount, bytes userData, bytes operatorData);
 20: 
 21:     constructor (address token) {
 22:         _token = IERC777(token);
 23: 
 24:         _erc1820.setInterfaceImplementer(address(this), TOKENS_RECIPIENT_INTERFACE_HASH, address(this));
 25:     }
 26: 
 27:     function tokensReceived(
 28:         address operator,
 29:         address from,
 30:         address to,
 31:         uint256 amount,
 32:         bytes calldata userData,
 33:         bytes calldata operatorData
 34:     ) external override {
 35:         require(msg.sender == address(_token), "Simple777Recipient: Invalid token");
 36: 
 37:         // do stuff
 38:         emit DoneStuff(operator, from, to, amount, userData, operatorData);
 39:     }
 40: }
