// Based on https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/test/examples/VvvToken.test.js
const { expectEvent, singletons, constants } = require('@openzeppelin/test-helpers');
const { ZERO_ADDRESS } = constants;

const VvvToken = artifacts.require('VvvToken');

contract('VvvToken', function ([_, registryFunder, creator, operator]) {

	beforeEach(async function () {
		this.erc1820 = await singletons.ERC1820Registry(registryFunder);
		this.token = await VvvToken.new({ from: creator });
	});

	// assert.equal("A Message", rv, "Invalid data for this...");

	it('has a name', async function () {
		let x = await this.token.name();
		return assert.equal(x, 'VvvToken', "Name did not match...");
	});

	it('has a symbol', async function () {
		let x = await this.token.symbol();
		return assert.equal(x, 'VVV', "Symbol did not match...");
	});

	it('assigns the initial total supply to the creator', async function () {
		const totalSupply = await this.token.totalSupply();
		const creatorBalance = await this.token.balanceOf(creator);

		let ok = assert.equal(creatorBalance.toString(), totalSupply.toString());

	//	await expectEvent.inConstruction(this.token, 'Transfer', {
	//		from: ZERO_ADDRESS,
	//		to: creator,
	//		value: totalSupply,
	//	});

		return !ok;
	});

	it('allows operator burn', async function () {
		const creatorBalance = await this.token.balanceOf(creator);
		const data = web3.utils.sha3('VvvData');
		const operatorData = web3.utils.sha3('VvvOperatorData');

		await this.token.authorizeOperator(operator, { from: creator });
		await this.token.operatorBurn(creator, creatorBalance, data, operatorData, { from: operator });
		let x = await this.token.balanceOf(creator);
		return assert.equal(x.toString(), "0", "Should have 0 tokens..." )
	});

});
