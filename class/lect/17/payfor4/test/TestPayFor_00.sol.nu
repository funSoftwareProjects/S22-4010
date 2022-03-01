  1: pragma solidity >=0.4.25 <0.9.0;
  2: 
  3: import "truffle/Assert.sol";
  4: import "truffle/DeployedAddresses.sol";
  5: import "../contracts/PayFor.sol";
  6: 
  7: contract TestPayFor_00 {
  8: 
  9:     PayFor pay = new PayFor();
 10: 
 11:     function testHasCorrectOwner() public {
 12:         Assert.equal(pay.isOwner(), true, "isOwner should return true");
 13:         Assert.equal(pay.getNPayments(), 0, "no payments yet");
 14:     }
 15: 
 16: }
