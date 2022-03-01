  1: pragma solidity >=0.5.2;
  2: // pragma solidity ^0.5.2;
  3: 
  4: /**
  5:  * @title Ownable
  6:  * @dev The Ownable contract has an owner address, and provides basic authorization control
  7:  * functions, this simplifies the implementation of "user permissions".
  8:  */
  9: contract Ownable {
 10:     address private _owner;
 11: 
 12:     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
 13: 
 14:     /**
 15:      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
 16:      * account.
 17:      */
 18:     constructor () internal {
 19:         _owner = msg.sender;
 20:         emit OwnershipTransferred(address(0), _owner);
 21:     }
 22: 
 23:     /**
 24:      * @return the address of the owner.
 25:      */
 26:     function owner() public view returns (address) {
 27:         return _owner;
 28:     }
 29: 
 30:     /**
 31:      * @dev Throws if called by any account other than the owner.
 32:      */
 33:     modifier onlyOwner() {
 34:         require(isOwner());
 35:         _;
 36:     }
 37: 
 38:     /**
 39:      * @return true if `msg.sender` is the owner of the contract.
 40:      */
 41:     function isOwner() public view returns (bool) {
 42:         return msg.sender == _owner;
 43:     }
 44: 
 45:     /**
 46:      * @dev Allows the current owner to relinquish control of the contract.
 47:      * It will not be possible to call the functions with the `onlyOwner`
 48:      * modifier anymore.
 49:      * @notice Renouncing ownership will leave the contract without an owner,
 50:      * thereby removing any functionality that is only available to the owner.
 51:      */
 52:     function renounceOwnership() public onlyOwner {
 53:         emit OwnershipTransferred(_owner, address(0));
 54:         _owner = address(0);
 55:     }
 56: 
 57:     /**
 58:      * @dev Allows the current owner to transfer control of the contract to a newOwner.
 59:      * @param newOwner The address to transfer ownership to.
 60:      */
 61:     function transferOwnership(address newOwner) public onlyOwner {
 62:         _transferOwnership(newOwner);
 63:     }
 64: 
 65:     /**
 66:      * @dev Transfers control of the contract to a newOwner.
 67:      * @param newOwner The address to transfer ownership to.
 68:      */
 69:     function _transferOwnership(address newOwner) internal {
 70:         require(newOwner != address(0));
 71:         emit OwnershipTransferred(_owner, newOwner);
 72:         _owner = newOwner;
 73:     }
 74: }
