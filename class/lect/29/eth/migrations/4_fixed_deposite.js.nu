  1: // contract FixedTermDesposite is Ownable {
  2: 
  3: const FixedTermDesposite = artifacts.require("FixedTermDesposite");
  4: 
  5: module.exports = function (deployer) {
  6:     deployer.deploy(FixedTermDesposite, 20000); // 2% Per Year * 1000000 = 20000
  7: };
