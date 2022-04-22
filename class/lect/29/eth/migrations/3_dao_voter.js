const SavedMessage = artifacts.require("SavedMessage");

module.exports = function (deployer) {
  deployer.deploy(SavedMessage);
};
