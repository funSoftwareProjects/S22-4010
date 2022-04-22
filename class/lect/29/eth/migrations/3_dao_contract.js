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

