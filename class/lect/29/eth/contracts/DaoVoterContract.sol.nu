  1: // SPDX-License-Identifier: MIT
  2: pragma solidity >=0.6.0 <=0.9.0;
  3: 
  4: import "@openzeppelin/contracts/proxy/Proxy.sol";
  5: 
  6: /**
  7:  * @title DaoVoterContract
  8:  * @dev Gives the possibility to delegate any call to a foreign implementation.
  9:  * Implements a proxy to the upgradable DaoVoterContractUpgradableV1 contract.
 10:  */
 11: contract DaoVoterContract is Proxy {
 12: 
 13:     address private owner;
 14:     address private DaoVoterContractImpl;
 15:     uint256 public version;
 16: 
 17:     modifier onlyOwner() {
 18:         require( msg.sender == owner, "Sender not authorized.");
 19:         // Do not forget the "_;"! It will be replaced by the actual function
 20:         // body when the modifier is used.
 21:         _;
 22:     }
 23: 
 24:     constructor( address _addr, uint256 _version ) Proxy() {
 25:         DaoVoterContractImpl = _addr;
 26:         owner = msg.sender;
 27:         version = _version;
 28:     }
 29: 
 30:     /**
 31:     * @dev Make `_newOwner` the new owner of this contract.
 32:     */
 33:     function changeOwner(address _newOwner) public onlyOwner() {
 34:         owner = _newOwner;
 35:     }
 36:     
 37:     /**
 38:     * @dev Upgrade the underling contract to a new version. `_newAddr` is the address of
 39:     * the new contract. `_newVersion` is the new version number.
 40:     */
 41:     function upgradeContract(address _newAddr, uint256 _newVersion) public onlyOwner() {
 42:         DaoVoterContractImpl = _newAddr;
 43:         version = _newVersion;
 44:     }
 45: 
 46:     /**
 47:     * @dev Tells the address of the implementation where every call will be delegated.
 48:     * @return address of the implementation to which it will be delegated
 49:     */
 50:     function _implementation() internal view override  returns (address) {
 51:         return ( DaoVoterContractImpl );
 52:     }
 53: 
 54: }
