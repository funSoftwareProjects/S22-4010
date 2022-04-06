
<style>
.pagebreak { page-break-before: always; }
.half { height: 200px; }
</style>
<style>
.pagebreak { page-break-before: always; }
.half { height: 200px; }
.markdown-body {
	font-size: 12px;
}
.markdown-body td {
	font-size: 12px;
}
</style>


# Lecture 30 - Games and other stuff

## CryptoKitties (ERC 721) game

CryptoKitties was the first "game" built for Ethereum.

![CryptoKitties.png](CryptoKitties.png)

The project raised $12 million in VC and over $50 million in
digital cats have been sold.  The most expensive cat sold for
over $100,000.

Hot it works...

You can buy a cat or a set of cats.   Cats can be bread together.
Each cat has is a NFT with a "hash" code.  Breading the cats
genetically mixes the "hash" code to produce a new cat.   The 
more rare characteristics of the cat the more valuable it is.

Yes I own 2 cryptokitties that are worth basically nothing.

![CryptoKitties2.png](CryptoKitties2.png)

CryptoKitties revealed 2 things about Ethereum...

1. The network would saturate at about 15 TPS
2. Latency is an absolute killer

CryptoKitties is a purely distributed web3.js app.  The images
of the cats are generated and stored in IPFS a distributed
file store.

Each time you take 2 cats and bread them to produce a new cat
the CryptoKitties ERC-721 contract gets a fee.   Every time you
sell a cat it gets a fee.  The number of cats is limited 
making them a collectible.

The first CryptoKitty—the “genesis cats“—were born on December 2, 2017.
Since then, a new “generation 0” cat has been born (popped into existence/minted etc.) on a 15 minute schedule.
The last of the "minted" cats happened 1 year after the start of the game.
Now all new kitties are produced through breeding.

You can “breed” two different CryptoKitties together to get a new CryptoKitty.
Breeding can be with any pair of cats because the don't have a biological sex.
The owners of the cats just have to agree as to which cat is the "dame" and the "sire".
The "dame" keeps the offspring.  The Choice of "dame"/"sire" is not permanent - so you
can reverse this in a later breeding or in future encounters.   There is a small
random component involved in the genetic outcome.

All of this is in smart contracts on Ethereum.  You pay in Eth to make it happen.

## How IPFS works 

IPFS the Interplanetary File Store is a P2P network based file store.  A file is stored based on its Merkle hash
of the contents of the file.

So you:

```
	ipfs add -r ./my-dir
	QmQac2chFyJ24yfG2Dfuqg1P5gipLcgUDuiuYkQ5ExwGap
	my-dir/my-file.txt
```

```
	https://ipfs.io/v1/QmQac2chFyJ24yfG2Dfuqg1P5gipLcgUDuiuYkQ5ExwGap/my-dir/my-file.txt
```

then to get back the file you need the hash

```
	ipfs object get QmQac2chFyJ24yfG2Dfuqg1P5gipLcgUDuiuYkQ5ExwGap
```

## How Amazon S3 works / Amazon Glacier

ZFS bsased file store.

## Distributed file store

Example: [https://storej.io](https://storej.io)



