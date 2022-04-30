const SavedMessage = artifacts.require("SavedMessage");

/*
 * Test the SavedMessage Client.
 */
contract("SavedMessage", function (accounts) {
	it("should Create contract", async function () {
		let sm = await SavedMessage.deployed();

		let account0 = accounts[0];
		let amount = 4000;
		var ok = true;

		// var tx = await sm.setCurrentMessageTxt ( "A Message", {"value":amount} );
		var tx = await sm.setCurrentMessageTxt ( "A Message" );
		console.log ( tx );

		var rv = await sm.getCurrentMessageTxt();

		assert.equal("A Message", rv, "Invalid data for this...");
		if ( "A Message" != rv ) {
			ok = false;
		}

		return assert.isTrue(ok);
	});
});
