const GenEvent = artifacts.require("GenEvent");

module.exports = function(deployer) {
  deployer.deploy(GenEvent);
};
