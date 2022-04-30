  1: // SPDX-License-Identifier: MIT
  2: 
  3: const DaoVoterContract = artifacts.require("DaoVoterContract");
  4: const DaoVoterContractUpgradableV1 = artifacts.require("DaoVoterContractUpgradableV1");
  5: 
  6: module.exports = (deployer) => {
  7:     deployer.then(async () => {
  8:         await deployer.deploy(DaoVoterContract);
  9:         await deployer.deploy(DaoVoterContract, DaoVoterContractV1.address, 10000 );    // Address, Version(as number)
 10:     });
 11: };
 12: 
