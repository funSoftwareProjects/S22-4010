  1: const FixedTermDesposite = artifacts.require("FixedTermDesposite");
  2: 
  3: contract("FixedTermDesposite", function (accounts) {
  4:     it("should Create contract and allow deposites and withdrals", async function () {
  5:         let sd = await FixedTermDesposite.deployed( 20000 );
  6: 
  7:         let account0 = accounts[0];
  8:         let account1 = accounts[1];
  9:         let amount = 1000000;
 10:         var ok = true;
 11: 
 12:         var tx = await sd.depositCertificate ( amount, {"value":amount} );
 13:         console.log ( "tx=", tx );
 14:         //    assert.equal(events.logs.length, 1);
 15:         //    assert.equal(events.logs[0].event, "SomeEvent");
 16:         console.log ( "tx.logs = ", tx.logs );
 17:         for ( var i = 0, mx = tx.logs.length; i < mx; i++ ) {
 18:             if ( tx.logs[i].event == 'DepositeMade' ) {
 19:                 console.log ( "For DepositeMoade event tx.logs["+i+"].args = ", tx.logs[i].args );
 20:                 var r = tx.logs[i].args;
 21:                 console.log ( "    .who = ", r.who );
 22:                 console.log ( "    .id = ", r.id.toString() );
 23:                 console.log ( "    .amount = ", r.amount.toString() );
 24:                 assert.equal(r.id.toString(),"1","Should have an ID of 1");
 25:                 assert.equal(r.amount.toString(),"1000000","Should have a depoiste of 1000000");
 26:             }
 27:         }
 28: 
 29:         return assert.isTrue(ok);
 30:     });
 31: });
