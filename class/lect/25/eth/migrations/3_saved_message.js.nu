  1: const SavedMessage = artifacts.require("SavedMessage");
  2: 
  3: module.exports = function (deployer) {
  4:   deployer.deploy(SavedMessage);
  5: };
