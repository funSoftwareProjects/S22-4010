// SPDX-License-Identifier: MIT

const DaoVoterContract = artifacts.require("DaoVoterContract");
const DaoVoterContractUpgradableV1 = artifacts.require("DaoVoterContractUpgradableV1");

module.exports = (deployer) => {
	deployer.then(async () => {
		await deployer.deploy(DaoVoterContract);
		await deployer.deploy(DaoVoterContract, DaoVoterContractV1.address, 10000 );	// Address, Version(as number)
	});
};

