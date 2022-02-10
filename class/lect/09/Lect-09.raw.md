m4_include(../../../setup.m4)


m4_comment([[[

   February 2022      
Su Mo Tu We Th Fr Sa  
       1  2  3  4  5  
 6  7  8  9 10 11 12  
    ^--------------------
13 14 15 16 17 18 19  
20 21 22 23 24 25 26  
27 28                 
                      
]]])

# Lecture 9 - 

## Feb 7 2022



Blocks in our Go Code
======================

Transactions in Blockchain
-------

Data Structure from .../block/block.go:

```
// BlockType is a single block in the block chain.
type BlockType struct {
  Index         int                             // position of this
                                                // block in the
                                                // chain, 0, 1, ...
  Desc          string                          // if "genesis" str.
                                                // then this is a
                                                // genesis block.
  ThisBlockHash hash.BlockHashType              //
  PrevBlockHash hash.BlockHashType              // This is 0 len.
                                                // if this is a
                                                // "genesis" block
  Nonce         uint64                          //
  Seal          hash.SealType                   //
  MerkleHash    hash.MerkleHashType             // Hw 03 
  Tx            []*transactions.TransactionType // Tx for Block
}

```


<br><div class="pagebreak"> </div>
Data Structure from .../transactions/tx.go:

```
type TransactionType struct {
  TxOffset       int               // The pos. of this in the block.
  Input          []TxInputType     // Set of inputs to a transaction
  Output         []TxOutputType    // Set of outputs to a tranaction
  SCOwnerAccount addr.AddressType  // ... for SmartContracts ... 
  SCAddress      addr.AddressType  // ... for SmartContracts ... 
  SCOutputData   string            // ... for SmartContracts ... 
  Account        addr.AddressType  //
  Signature      lib.SignatureType //  Used in HW 5 - Signature 
  Message        string            //  Used in HW 5 - Message
  Comment        string            //
}

type TxInputType struct {
  BlockNo     int // Which block is this from
  TxOffset    int // The transaction in the block.
                  // In the block[BlockHash].Tx[TxOffset]
  TxOutputPos int // Position of the output in the transaction.
                  // In the block[BlockHash].Tx[TxOffset].
                  // Output[TxOutptuPos]
  Amount      int // Value $$
}

type TxOutputType struct {
  BlockNo     int              // Which block is this in
  TxOffset    int              // Which transaction in this block. 
                               // block[this].Tx[TxOffset]
  TxOutputPos int              // Pos. of the output in this block.
                               // In the  block[this].Tx[TxOffset].
                               // Output[TxOutptuPos]
  Account     addr.AddressType // Acctount funds go to (If this is
                               // ""chagne"" then this is the same
                               // as TransactionType.Account
  Amount      int              // Amoutn to go to accoutn
}
```

