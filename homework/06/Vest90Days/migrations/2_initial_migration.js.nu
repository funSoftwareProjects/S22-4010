  1: const VvvToken = artifacts.require("./VvvToken");
  2: const Vest90Days = artifacts.require("Vest90Days");
  3: 
  4: require('@openzeppelin/test-helpers/configure')({ provider: web3.currentProvider, environment: 'truffle' });
  5: 
  6: const { singletons } = require('@openzeppelin/test-helpers');
  7: 
  8: module.exports = async function (deployer, network, accounts) {
  9:     if (network === 'development') {
 10:         // In a test environment an ERC777 token requires deploying an ERC1820 registry
 11:         await singletons.ERC1820Registry(accounts[0]);
 12:     }
 13:     await deployer.deploy(VvvToken);
 14:     await deployer.deploy(Vest90Days, VvvToken.address);
 15: };
