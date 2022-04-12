  1: // Based on https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/test/examples/VvvToken.test.js
  2: const { expectEvent, singletons, constants } = require('@openzeppelin/test-helpers');
  3: const { ZERO_ADDRESS } = constants;
  4: 
  5: const VvvToken = artifacts.require('VvvToken');
  6: 
  7: contract('VvvToken', function ([_, registryFunder, creator, operator]) {
  8: 
  9:     beforeEach(async function () {
 10:         this.erc1820 = await singletons.ERC1820Registry(registryFunder);
 11:         this.token = await VvvToken.new({ from: creator });
 12:     });
 13: 
 14:     // assert.equal("A Message", rv, "Invalid data for this...");
 15: 
 16:     it('has a name', async function () {
 17:         let x = await this.token.name();
 18:         return assert.equal(x, 'VvvToken', "Name did not match...");
 19:     });
 20: 
 21:     it('has a symbol', async function () {
 22:         let x = await this.token.symbol();
 23:         return assert.equal(x, 'VVV', "Symbol did not match...");
 24:     });
 25: 
 26:     it('assigns the initial total supply to the creator', async function () {
 27:         const totalSupply = await this.token.totalSupply();
 28:         const creatorBalance = await this.token.balanceOf(creator);
 29: 
 30:         let ok = assert.equal(creatorBalance.toString(), totalSupply.toString());
 31: 
 32:     //    await expectEvent.inConstruction(this.token, 'Transfer', {
 33:     //        from: ZERO_ADDRESS,
 34:     //        to: creator,
 35:     //        value: totalSupply,
 36:     //    });
 37: 
 38:         return !ok;
 39:     });
 40: 
 41:     it('allows operator burn', async function () {
 42:         const creatorBalance = await this.token.balanceOf(creator);
 43:         const data = web3.utils.sha3('VvvData');
 44:         const operatorData = web3.utils.sha3('VvvOperatorData');
 45: 
 46:         await this.token.authorizeOperator(operator, { from: creator });
 47:         await this.token.operatorBurn(creator, creatorBalance, data, operatorData, { from: operator });
 48:         let x = await this.token.balanceOf(creator);
 49:         return assert.equal(x.toString(), "0", "Should have 0 tokens..." )
 50:     });
 51: 
 52: });
