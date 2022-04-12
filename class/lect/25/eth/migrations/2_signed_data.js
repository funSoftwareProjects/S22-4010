const SignData = artifacts.require("SignData");

module.exports = function(deployer) {
  deployer.deploy(SignData);
};
