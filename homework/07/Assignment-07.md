

<style>
.pagebreak { page-break-before: always; }
.half { height: 200px; }
</style>
<style>
.pagebreak { page-break-before: always; }
.half { height: 200px; }
.markdown-body {
	font-size: 12px;
}
.markdown-body td {
	font-size: 12px;
}
</style>


## Assignment 7 - Proxy Contact / Vyper Contract

400pts  <br>
Due May 2 - 2 Parts - Last homework




Build a pair of contracts, a Proxy contract that allows
the upgrade of an implementation contract and a more
general voting contract.

The test code for the contracts should call the
proxy and check that it voting works through
the proxy.




# Part 1 - 200pts

Part 1: Use the Proxy contract from the class lecture, 29.
`.../S22-4010/class/lect/29/eth/contracts`
DaoVoterContract.sol and
DaoVoterContractUpgradableV1.sol

Modify DaoVoterContract.sol to work with a version 1 vote
contract in Vyper.  Name changes, change file name etc.

Load and test the pair of contracts using a modified
`.../S22-4010/class/lect/29/eth/migrations/2_*.js` 
../../class/lect/29/eth/migrations/3_dao_voter.js

```
// SPDX-License-Identifier: MIT

const DaoVoterContract = artifacts.require("DaoVoterContract");
const DaoVoterContractUpgradableV1 = artifacts.require("DaoVoterContractUpgradableV1");

module.exports = (deployer) => {
	deployer.then(async () => {

		// Load Contract
		await deployer.deploy(DaoVoterContractUpgradableV1); 

		// Create proxy
		await deployer.deploy(DaoVoterContract, DaoVoterContractUpgradableV1.address, 10000);	
	});
};
```

Note that this migration deploys the proxy contract, then uses the address of the
deployed contract and passes that to the proxy contract.

<div class="pagebreak"></div>

# Part 2 - 200pts

Part 2: Implement and test the voting contract.


Take the example voting contract in Vyper and modify
it to allow for multiple things to be voted on.

```
@external
def createProposal(_proposalNames: bytes32[10], _nProposedItems: int128):
```

1. Check that a vote is not currently in progress.  If so then error.
1. Check that the person creating the proposal is the owner/self.chairpeson for the contract.
2. Check that the number of items that is being voted on is 10 or less.   There must be at least 1 item to vote on.
3. Create the item - for all the unused slots in the 10 items set the name of the item to ""

Modify the constructor to not create a proposal.

Create a test that creates a proposal and then votes on it.

Create a pair of functions/methods that start the voting window and ends the voting window.

```
@external
def startVote():
```

and 

```
@external
def endVote():
```


