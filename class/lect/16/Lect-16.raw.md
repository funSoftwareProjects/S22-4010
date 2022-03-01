
m4_include(../../../setup.m4)

Lecture 16 - Creating a 1st contract
==

## Setting up a new project

```
$ mkdir payfor2
$ cd payfor2
$ truffle init 
```

Scaffold commands to start with

```
$ truffle create contract PayFor 
$ truffle create test PayFor    
```


You can now build the empty contract and test it.

In a 2nd window start ganache-cli

```
$ ganache-cli
```

Edit truffle-config.js - to connect to ganache.  Around line 74

```
74:    development: {
75:      host: "127.0.0.1", 
76:      port: 8545,       
77:      network_id: "*", 
78:    },
```

add a "migration" file in the ./migrations/ directory
create `2_initial_migrations.js` with:

```
const PayFor = artifacts.require("PayFor");

module.exports = function(deployer) {
  deployer.deploy(PayFor);
};
```

Now Compile and load the contract:


```
$ truffle comile
$ truffle migrate
```

Save the output from the migrate - it is important!

and... Run the empty test

```
$ truffle test
```

It procures a cute output:

![output-test.png](output-test.png)


To reload a contract you need a "truffle migrate --reset".

```
(base) philip@victoria payfor % truffle migrate --reset

Compiling your contracts...
===========================
> Everything is up to date, there is nothing to compile.



Starting migrations...
======================
> Network name:    'development'
> Network id:      1645743739818
> Block gas limit: 6721975 (0x6691b7)


1_initial_migration.js
======================

   Replacing 'Migrations'
   ----------------------
   > transaction hash:    0xc2215471f6e946eb1990156ccd5367b81f540f5d4b775fdf7aa2fda6d3161330
   > Blocks: 0            Seconds: 0
   > contract address:    0x3b6bdDFC0A92E3BDa4dd4941D5319b40227cdE21
   > block number:        31
   > block timestamp:     1645795766
   > account:             0x5C046b3B982a2073584613213e40C22d6A876300
   > balance:             99.89637302
   > gas used:            191943 (0x2edc7)
   > gas price:           20 gwei
   > value sent:          0 ETH
   > total cost:          0.00383886 ETH


   > Saving migration to chain.
   > Saving artifacts
   -------------------------------------
   > Total cost:          0.00383886 ETH


2_initial_migrations.js
=======================

   Replacing 'PayFor'
   ------------------
   > transaction hash:    0x768be0029d0a020c861bb22ffe7dd0efab40eb1f3a4a96f8d4191f70638c3f59
   > Blocks: 0            Seconds: 0
   > contract address:    0x921511c8972EA1e3c4A9Acf117714917eB3f6a15
   > block number:        33
   > block timestamp:     1645795766
   > account:             0x5C046b3B982a2073584613213e40C22d6A876300
   > balance:             99.8828177
   > gas used:            635428 (0x9b224)
   > gas price:           20 gwei
   > value sent:          0 ETH
   > total cost:          0.01270856 ETH


   > Saving migration to chain.
   > Saving artifacts
   -------------------------------------
   > Total cost:          0.01270856 ETH


Summary
=======
> Total deployments:   2
> Final cost:          0.01654742 ETH

```


<div class="pagebreak"></div>

## Take a look at the contract code.

```
m4_include(PayFor.sol.nu)
```
