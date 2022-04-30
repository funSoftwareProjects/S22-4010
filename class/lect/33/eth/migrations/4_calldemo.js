const Callee = artifacts.require('Callee');
const Caller = artifacts.require('Caller');

module.exports = async function (deployer, network, accounts) {
	await deployer.deploy(Callee);
	const tmp = await Callee.deployed();

	await deployer.deploy(Callee, tmp.address);
};
