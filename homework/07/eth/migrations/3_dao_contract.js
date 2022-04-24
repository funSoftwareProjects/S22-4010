// SPDX-License-Identifier: MIT

const Voting = artifacts.require("Voting");
const VotingV1 = artifacts.require("VotingV1");

module.exports = (deployer) => {
	deployer.then(async () => {

		// Load Contract
		await deployer.deploy(VotingV1);

		// Create proxy
		await deployer.deploy(Voting, VotingV1.address, 10000 );	
	});
};

