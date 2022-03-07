const SignData = artifacts.require("SignData");

/*
 * Ethereum client
 */
contract("SignData", function (accounts) {
	it("should Create contract and sign data", async function () {
		let sd = await SignData.deployed();

		let account0 = accounts[0];
		let account1 = accounts[1];
		let amount = 1000;
		var ok = true;

		//function createHash ( uint256 _app, uint256 _name, bytes32 _data, bool _mayChange ) public 
		// needMinPayment payable {
		var tx = await sd.createHash( 10, 4, "0x0213e3852b8afeb08929a0f448f2f693b0fc3ebe", true,
			{"value":amount} );
		// console.log ( tx );

		// function setData ( uint256 _app, uint256 _name, bytes32 _data ) public needMinPayment
		// payable {
		tx = await sd.setHash( 10, 4, "0x11111111111afeb08929a0f448f2f693b0fc3ebe",
			{"value":amount} );
		// console.log ( "tx after setHash", tx );

		var x, hh, ww;
		x = await sd.getHash ( 10, 4 );
		hh = x[0];
		ww = x[1].toNumber();


		console.log ( x, "hh=", hh, "ww=", ww );
    	let expect = "0x11111111111afeb08929a0f448f2f693b0fc3ebe000000000000000000000000";
    	assert.equal(hh, expect, "Invalid stored hash");
		if ( hh != expect ) {
			ok = false;
		}

		var today = new Date();
		var sDate = today.getFullYear()+'-'+(today.getMonth()+1)+'-'+today.getDate();

		var timestamp = ww * 1000;	// Convert from number of seconds (Eth) since 1970 to mili-seconds
		var date = new Date(timestamp);
		// console.log(date.getDate())
		// console.log(date, sDate) // 2022-03-04T14:40:57.000Z
		var gDate = date.getFullYear()+'-'+(date.getMonth()+1)+'-'+date.getDate();
		assert.equal(sDate,gDate, "Invalid date for this hash.");
		if ( sDate != gDate ) {
			ok = false;
		}

		return assert.isTrue(ok);
	});
});
