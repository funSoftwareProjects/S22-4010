  1: const SignData = artifacts.require("SignData");
  2: 
  3: /*
  4:  * Ethereum client
  5:  */
  6: contract("SignData", function (accounts) {
  7:     it("should Create contract and sign data", async function () {
  8:         let sd = await SignData.deployed();
  9: 
 10:         let account0 = accounts[0];
 11:         let account1 = accounts[1];
 12:         let amount = 1000;
 13:         var ok = true;
 14: 
 15:         //function createSignature ( uint256 _app, uint256 _name, bytes32 _data, bool _mayChange ) public needMinPayment payable {
 16:         var tx = await sd.createHash( 10, 4, "0x0213e3852b8afeb08929a0f448f2f693b0fc3ebe", true, {"value":amount} );
 17:         // console.log ( tx );
 18: 
 19:         // function setData ( uint256 _app, uint256 _name, bytes32 _data ) public needMinPayment payable {
 20:         tx = await sd.setHash( 10, 4, "0x11111111111afeb08929a0f448f2f693b0fc3ebe", {"value":amount} );
 21:         // console.log ( "tx after setHash", tx );
 22: 
 23:         var x, hh, ww;
 24:         x = await sd.getHash ( 10, 4 );
 25:         hh = x[0];
 26:         ww = x[1].toNumber();
 27: 
 28: 
 29:         // console.log ( x, "hh=", hh, "ww=", ww );
 30:         let expect = "0x11111111111afeb08929a0f448f2f693b0fc3ebe000000000000000000000000";
 31:         assert.equal(hh, expect, "Invalid stored hash");
 32:         if ( hh != expect ) {
 33:             ok = false;
 34:         }
 35: 
 36:         var today = new Date();
 37:         var sDate = today.getFullYear()+'-'+(today.getMonth()+1)+'-'+today.getDate();
 38: 
 39:         var timestamp = ww * 1000;    // Convert from number of seconds (Eth) since 1970 to mili-seconds
 40:         var date = new Date(timestamp);
 41:         // console.log(date.getDate())
 42:         // console.log(date, sDate) // 2022-03-04T14:40:57.000Z
 43:         var gDate = date.getFullYear()+'-'+(date.getMonth()+1)+'-'+date.getDate();
 44:         assert.equal(sDate,gDate, "Invalid date for this hash.");
 45:         if ( sDate != gDate ) {
 46:             ok = false;
 47:         }
 48: 
 49:         return assert.isTrue(ok);
 50:     });
 51: });
