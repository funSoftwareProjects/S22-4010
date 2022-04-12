// contract FixedTermDesposite is Ownable {

const FixedTermDesposite = artifacts.require("FixedTermDesposite");

module.exports = function (deployer) {
	deployer.deploy(FixedTermDesposite, 20000); // 2% Per Year * 1000000 = 20000
};
