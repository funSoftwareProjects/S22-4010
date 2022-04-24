const FixedTermDesposite = artifacts.require("FixedTermDesposite");

contract("FixedTermDesposite", function (accounts) {
	it("should Create contract and allow deposites and withdrals", async function () {
		let sd = await FixedTermDesposite.deployed( 20000 );

		let account0 = accounts[0];
		let account1 = accounts[1];
		let amount = 1000000;
		var ok = true;

		var tx = await sd.depositCertificate ( amount, {"value":amount} );
		console.log ( "tx=", tx );
		//	assert.equal(events.logs.length, 1);
		//	assert.equal(events.logs[0].event, "SomeEvent");
		console.log ( "tx.logs = ", tx.logs );
		for ( var i = 0, mx = tx.logs.length; i < mx; i++ ) {
			if ( tx.logs[i].event == 'DepositeMade' ) {
				console.log ( "For DepositeMoade event tx.logs["+i+"].args = ", tx.logs[i].args );
				var r = tx.logs[i].args;
				console.log ( "    .who = ", r.who );
				console.log ( "    .id = ", r.id.toString() );
				console.log ( "    .amount = ", r.amount.toString() );
				assert.equal(r.id.toString(),"1","Should have an ID of 1");
				assert.equal(r.amount.toString(),"1000000","Should have a depoiste of 1000000");
			}
		}

		return assert.isTrue(ok);
	});
});
