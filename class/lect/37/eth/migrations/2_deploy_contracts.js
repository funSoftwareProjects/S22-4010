var KVPair = artifacts.require("KVPair");

module.exports = function(deployer) {
  deployer.deploy(KVPair);
};
