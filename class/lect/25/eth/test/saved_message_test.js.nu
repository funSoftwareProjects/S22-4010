  1: const SavedMessage = artifacts.require("SavedMessage");
  2: 
  3: /*
  4:  * Test the SavedMessage Client.
  5:  */
  6: contract("SavedMessage", function (accounts) {
  7:     it("should Create contract", async function () {
  8:         let sm = await SavedMessage.deployed();
  9: 
 10:         let account0 = accounts[0];
 11:         let amount = 4000;
 12:         var ok = true;
 13: 
 14:         // var tx = await sm.setCurrentMessageTxt ( "A Message", {"value":amount} );
 15:         var tx = await sm.setCurrentMessageTxt ( "A Message" );
 16:         console.log ( tx );
 17: 
 18:         var rv = await sm.getCurrentMessageTxt();
 19: 
 20:         assert.equal("A Message", rv, "Invalid data for this...");
 21:         if ( "A Message" != rv ) {
 22:             ok = false;
 23:         }
 24: 
 25:         return assert.isTrue(ok);
 26:     });
 27: });
