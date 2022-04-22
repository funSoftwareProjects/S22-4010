  1: var Migrations = artifacts.require("./Migrations.sol");
  2: 
  3: module.exports = function(deployer) {
  4:   deployer.deploy(Migrations);
  5: };
