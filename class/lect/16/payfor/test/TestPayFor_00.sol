pragma solidity >=0.4.25 <0.9.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/PayFor.sol";

contract TestPayFor_00 {

	PayFor pay = new PayFor();

	function testHasCorrectOwner() public {
		Assert.equal(pay.isOwner(), true, "isOwner should return true");
	}

}
