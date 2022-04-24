  1: const Simple777Token = artifacts.require('Simple777Token');
  2: const Simple777Recipient = artifacts.require('Simple777Recipient');
  3: const Simple777Sender = artifacts.require('Simple777Sender');
  4: 
  5: require('@openzeppelin/test-helpers/configure')({ provider: web3.currentProvider, environment: 'truffle' });
  6: 
  7: const { singletons } = require('@openzeppelin/test-helpers');
  8: 
  9: module.exports = async function (deployer, network, accounts) {
 10:     if (network === 'development') {
 11:         // In a test environment (our local machine) the ERC777 token    will require the deploymet of an
 12:         // ERC1820 registry
 13:         await singletons.ERC1820Registry(accounts[0]);
 14:     }
 15:     // If you use some other local network - add in deploymeht of registry at this point.
 16: 
 17:     await deployer.deploy(Simple777Token);
 18:     const token = await Simple777Token.deployed();
 19: 
 20:     await deployer.deploy(Simple777Recipient, token.address);
 21: 
 22:     await deployer.deploy(Simple777Sender);
 23: };
