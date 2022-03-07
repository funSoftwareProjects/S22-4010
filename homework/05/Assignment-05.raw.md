m4_include(../.././setup.m4)

## Assignment 5 - Develop a Document Contract.

300pts (in 2 parts) <br>
Due Mar 11 - 100pts - the hello truffle part <br>
Due Mar 25 - 200pts - the document contract <br>

m4_comment([[[
     March 2022       
Su Mo Tu We Th Fr Sa  
       1  2  3  4  5  
 6  7  8  9 10 11 12  
13 14 15 16 17 18 19  
20 21 22 23 24 25 26  
27 28 29 30 31        
]]])


## Part 1 - Install Truffle, Ganache

1. Install truffle, ganache-cli
2. Get the sample contract to work (MetaToken)
3. Get open-zeppelin installed
4. Get the Doc0.sol contract to compile, migrate, and run a non-useful test on it.

## Part 2 - Develop a Document Contract

One of the common uses of the blockchain is as a proof of authenticity
for external data.   The way that this works is to take some set of external
data, generate a hash for that data (SHA1 hash, or PGP2 signature example) and then write the
hash to the chain.  The outside code is reasonably straight forward -
in some fashion you read a document, hash it - then you call a smart contract
on chain to store the data on chain.   The on chain contract
provides the time and proof of authenticity.

A number of companies are using this kind of a system.  There is an ISO900/ISO9002 document
tracking company that is doing this.   IOHK / BeefChain is using this approach for supply chain tracking.

This is often referred to as a "metta-data tracking" system.

In this homework we will implement the smart contract in Ethereum/Solidity to do the
on-chain tracking.   You will need to write the contract and to develop some tests
that show that your contract works.

Develop the contract using truffle and solidity.

Turn in your contract and the test code.





Take a "document" signature and associate it with a user/acct - to mark the 

1. Keep track of a users set of documents
2. Allow search for a document "hash" to see when signed
3. Keep validity of documents - time when signed
4. Noterize contract based on a list of valid notary agents.


Sample Code and Interface
---------------------------------------------------------

Complete the following code:

File: Doc0.sol

```
m4_include(Doc0.sol)
```

Develop and write some tests for this code.


