const Simple777Token = artifacts.require('Simple777Token');
const Simple777Recipient = artifacts.require('Simple777Recipient');
const Simple777Sender = artifacts.require('Simple777Sender');

require('@openzeppelin/test-helpers/configure')({ provider: web3.currentProvider, environment: 'truffle' });

const { singletons } = require('@openzeppelin/test-helpers');

module.exports = async function (deployer, network, accounts) {
	if (network === 'development') {
		// In a test environment (our local machine) the ERC777 token	will require the deploymet of an
		// ERC1820 registry
		await singletons.ERC1820Registry(accounts[0]);
	}
	// If you use some other local network - add in deploymeht of registry at this point.

	await deployer.deploy(Simple777Token);
	const token = await Simple777Token.deployed();

	await deployer.deploy(Simple777Recipient, token.address);

	await deployer.deploy(Simple777Sender);
};
