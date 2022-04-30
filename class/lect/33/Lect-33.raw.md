
m4_include(../../../setup.m4)

# Snowflake

## Current Families

1. "Classical consensus" - Leslie Lamport and Barbra Liscoff 
- Quick finality.  
- Quadratic communication.
- Security Judicious Overlap between quorums of people.
- Paxos is based on this.

Good basis for Permissions Chained.

2. Nakamoto 2009 - Robust 
- Slow (Bitcoin is 3-10 TPS, Power = 2 times Denmark, Ethereum runs 15+ TPS etc.)
- High communication - Order n squared.
- Limited Throughput - bandwidth / communication limited.
- Expensive - When we are using these systems - we are paying for all that electricity.  Either via minting new tokens or via transaction fees.

Snowflake (Avalance)
1. Finality in 2 seconds - 
2. Thousands of TPS
3. Scales from 10,000 to millions of nodes
4. No special ecosystem of mining 

It is a Gosip or Epidemic Protocol.  This is basically a sub-sample voting system.
In each round you are getting a sub-sample of the voting for a result and with
each round you increase the probability of "A" result.

New Idea has "meta stability"

No stability in the middle.  You want it to tip in some direction.

A Vote Process - but not by "counting" the votes.

The process - when you look at the proofs - relies on chaotic instability.

You as a listener can see the votes of the nodes that you talk to.  You pick
a solution (based on your data) and reveal your solution.  Let's call this solution
"left".  You see the solutions of your neighbors ("left" or "right") and you can choose
witch direction to go in.    If you see a preponderance of, let's say, "right" you can
choose to switch your solution to "right".  In each round you get this choice.

With a larger and larger set of nodes the rate at which you can "see" the "left" or "right"
in a solution rises.  More nodes leads to a faster spread of the instability and a faster
rate of going from one solution to a common agreed upon solution.

A lying node - one attempting to produce a solution that is incorrect - has to persuade
other nodes that it's lie is more valid than all the other nodes promoting commonly accepted
solutions.   This makes the protocol robust.

The economy of the protocol means that it is egalitarian - It is runnable from virtually
any computing device.  A Phone is at a disadvantage because of network latency - not because
of lack of compute power.   However it is at no more of a disadvantage than a person on a
slow network connection.


### Evolution and Extra Legality

Bitcoin (Nakomoto) protocol is extra legal and brittle.

Snowflake can be persuaded to fix results via consensus.  This makes it manageable by an
avalanche of consensus.    Centralized authority can then drive corrective actions to
the "state" of the chain.


### Implications

1. Participant (nodes) need not "participate" - this means that nodes may not affect safety
of the system.  Nodes are only visible if the "vote".
2. "Green" System - low costs and low overhead.
3. No liveness grantee - A double spend scenario - you send to A, and B at the same time.   There
is no grantee to resolve this.   The tokens can be stuck in the middle.  There is no grantee that
the chain will ever "choose" one over the other.   In practical terms this is improbable - but -
it puts the burden of responsibility on the "sender" who tried to defraud the receivers.  


### Avalanche (AVA) tokens based on this.

1. This uses a "staking" mechanism with traditional Solidity/Viper contracts (Ethereum) or
via a off-chain based contract with Bitcoin.
2. The "stake" is a non-paying stake that prevents the creation of accounts for free.
This stops the ability to have Sybil (51%) attacks on the system.
3. No "risk" - the stake is not a grantee of accuracy.  There is no risk of loosing your
stake - but you can not participate if you withdraw your stake.  "Free" creates a commons
that can be abused - "free" email created spam - this removes "free" - you have to have
some "skin" in the game - to participate.  The real "risk" or "cost" is opportunity cost risk.
4. Large enough staking allows the "minting" of new AVA tokens.  This is a builtin interest
rate that is payed on the "stake" in AVA tokens.   It is low but it can change.

## Governance

4. Corrections to the chain can take place.  Via "consensus" you can change the minting 
rate - inflation - or the rate of return can be increased to "grow" the network.
This is "dental banking" via chain consensus.



## Stock v.s. Bonds

An example business with an ICO or Stock raise.

You want to start a business but you don't have the capital to do it.
SO you create a company - 
Then sell some stock to some investors.

You need to invest in hardware / fixed asset.  This asset depreciates.

You need to pay for labor / this is a liability - the value can't be counted.

Now you need more money - but you don't want to sell more of the business.

The alternative is to get a "loan".

There are 2 forms of loans - bank loans and bonds.


An example bond contract:

```
m4_include(eth/contracts/ZeroCouplonBond.sol.nu)
```









