  1: const Migrations = artifacts.require("Migrations");
  2: 
  3: module.exports = function(deployer) {
  4:   deployer.deploy(Migrations);
  5: };
