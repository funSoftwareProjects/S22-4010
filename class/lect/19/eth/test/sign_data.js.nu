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
 15:         //function createHash ( uint256 _app, uint256 _name, bytes32 _data, bool _mayChange ) public 
 16:         // needMinPayment payable {
 17:         var tx = await sd.createHash( 10, 4, "0x0213e3852b8afeb08929a0f448f2f693b0fc3ebe", true,
 18:             {"value":amount} );
 19:         // console.log ( tx );
 20: 
 21:         // function setData ( uint256 _app, uint256 _name, bytes32 _data ) public needMinPayment
 22:         // payable {
 23:         tx = await sd.setHash( 10, 4, "0x11111111111afeb08929a0f448f2f693b0fc3ebe",
 24:             {"value":amount} );
 25:         // console.log ( "tx after setHash", tx );
 26: 
 27:         var x, hh, ww;
 28:         x = await sd.getHash ( 10, 4 );
 29:         hh = x[0];
 30:         ww = x[1].toNumber();
 31: 
 32: 
 33:         console.log ( x, "hh=", hh, "ww=", ww );
 34:         let expect = "0x11111111111afeb08929a0f448f2f693b0fc3ebe000000000000000000000000";
 35:         assert.equal(hh, expect, "Invalid stored hash");
 36:         if ( hh != expect ) {
 37:             ok = false;
 38:         }
 39: 
 40:         var today = new Date();
 41:         var sDate = today.getFullYear()+'-'+(today.getMonth()+1)+'-'+today.getDate();
 42: 
 43:         var timestamp = ww * 1000;    // Convert from number of seconds (Eth) since 1970 to mili-seconds
 44:         var date = new Date(timestamp);
 45:         // console.log(date.getDate())
 46:         // console.log(date, sDate) // 2022-03-04T14:40:57.000Z
 47:         var gDate = date.getFullYear()+'-'+(date.getMonth()+1)+'-'+date.getDate();
 48:         assert.equal(sDate,gDate, "Invalid date for this hash.");
 49:         if ( sDate != gDate ) {
 50:             ok = false;
 51:         }
 52: 
 53:         return assert.isTrue(ok);
 54:     });
 55: });
