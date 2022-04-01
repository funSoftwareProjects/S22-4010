const VvvToken = artifacts.require("./VvvToken.sol");
const Vest90Days = artifacts.require("Vest90Days");

module.exports = (deployer) => {
	deployer.then(async () => {
		await deployer.deploy(VvvToken);
		await deployer.deploy(Vest90Days, VvvToken.address);
	});
};
