  1: // SPDX-License-Identifier: MIT
  2: pragma solidity >=0.4.22 <0.9.0;
  3: 
  4: import "@openzeppelin/contracts/token/ERC777/IERC777.sol";
  5: import "@openzeppelin/contracts/utils/introspection/IERC1820Registry.sol";
  6: import "@openzeppelin/contracts/utils/introspection/ERC1820Implementer.sol";
  7: import "@openzeppelin/contracts/token/ERC777/IERC777Sender.sol";
  8: 
  9: contract Simple777Sender is IERC777Sender, ERC1820Implementer {
 10: 
 11:     bytes32 constant public TOKENS_SENDER_INTERFACE_HASH = keccak256("ERC777TokensSender");
 12: 
 13:     event DoneStuff(address operator, address from, address to, uint256 amount, bytes userData, bytes operatorData);
 14: 
 15:     function senderFor(address account) public {
 16:         _registerInterfaceForAddress(TOKENS_SENDER_INTERFACE_HASH, account);
 17:     }
 18: 
 19:     function tokensToSend(
 20:         address operator,
 21:         address from,
 22:         address to,
 23:         uint256 amount,
 24:         bytes calldata userData,
 25:         bytes calldata operatorData
 26:     ) external override {
 27: 
 28:         // do stuff
 29:         emit DoneStuff(operator, from, to, amount, userData, operatorData);
 30:     }
 31: }
