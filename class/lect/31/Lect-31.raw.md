m4_include(../../../setup.m4)

# Lecture 32 - How do Layer 2 Solutions Work

If you want to build real world applications the 3 big factors that limit what you can do are:

1. Cost of Gas on the Eth Main Chian ($30 to do a simple contract call)
2. Speed - Latency of the main chain - it is high - 22 seconds.
3. Throughput of main gain - it is low.  

The thing that you want is: 

1. It runs and works EVM (Solidity for example) contracts.
2. It gives you financial transactions using real Eth

For just payments there are solutions like the Lightning Network for Bitcoin.
Specifically, the Lightning Network is based on state channels, which are basically attached channels that perform blockchain operations and report them to the main chain. State channels are payment channels.  It not really a "smart contract" solution.

Layer 2 solutions address these problems (well... some of them better than others)...

There are 2 primary methods to the Layer 2 systems.


## Zero-Knowledge Rollups 

Zero-knowledge rollups – used in  ZK-Rollups – are sets of data
that are collateralized by a smart contract (ERC 20 type) on the
main chain.  The work is transported off-chain for processing.  It
takes about a minute to produce a block - so latency is still a
problem.  However it runs total at over 2,000 TPS.  Also there is
a tremendous level of privacy.  The off chain data storage helps.

## Optimistic Rollups 

Optimistic rollups run on Ethereum’s base layer while moving the contract work and storage off chain.
Consensus is via computation of merkle roots that have to mach between different side chains and the main
chain.  Optimistic rollups have to rely on a set of external validators to check the merkle roots.
Dragon chain works this way.


## An Example Polygon (Matic)

Polygon's main chain is a Proof-of-Stake (PoS) sidechain. MATIC is
the native token for the Polygon network. Is used as staking token
to validate transactions and vote on network upgrades. MATIC is
also used to pay for the gas fees on Polygon.   Essentially they
have an Ethereum network that is much faster that you run as a
side chain.


## What is involved in an optimistic rollup system

Let's suppose that you have a staking contract - ERC777 based.

```
m4_include(eth/contracts/InsLogEvent.sol.nu)
```

This contract has some extra stuff... 

```	
function IndexedEvent ( address _acct, string memory _msg ) public returns ( bool ) {
```	

```
function SendEth ( address payable _acct, uint256 _amount ) public onlyOwner {
```

Now we build a side chain based on this.

First let's use postgresql for the side chain.  It is fast, has tables and indexes and triggers and all sorts of stuff...

```
m4_include(eth/demo-table.sql.nu)
```

This relies on sending messages from PostgreSQL to the contract.  PostgreSQL has a nice facility to do pub/sub.
So let's use that in go.

```
m4_include(eth/lstn.go.nu)
```



