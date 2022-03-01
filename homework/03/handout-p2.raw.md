m4_include(../.././setup.m4)

# handout-p2.md

# Data types in Code

from bsvr/block/block.go:

```
m4_include(block-example.go.nu)
m4_comment([[[
// BlockType is a single block in the block chain.
type BlockType struct {
	Index         int                             // position of this block in the chain, 0, 1, 2, ...
	Desc          string                          // if "genesis" string then this is a genesis block.
	ThisBlockHash hash.BlockHashType              //
	PrevBlockHash hash.BlockHashType              // This is 0 length if this is a "genesis" block
	Nonce         uint64                          //
	Seal          hash.SealType                   //
	MerkleHash    hash.MerkleHashType             // AS-02
	Tx            []*transactions.TransactionType // Add Transactions to Block Later, (AS-03 will do this)
}
]]])
```

from bsvr/transactions/tx.go:

```
m4_include(tx-example.go.nu)
m4_comment([[[
type TransactionType struct {
	TxOffset       int               // The position of this in the block.
	Input          []TxInputType     // Set of inputs to a transaction
	Output         []TxOutputType    // Set of outputs to a tranaction
	SCOwnerAccount addr.AddressType  // Used in HW 6 - Smart Contracts - Owner of Contract
	SCAddress      addr.AddressType  // Used in HW 6 - Smart Contracts - Address of Contract
	SCOutputData   string            // Used in HW 6 - Smart Contracts - Output data from contract
	Account        addr.AddressType  //
	Signature      lib.SignatureType //	Used in HW 5 - Signature that this is a valid tranaction for this account
	Message        string            //	Used in HW 5 - Message (hash of original) that signature signs for
	Comment        string            //
}

type TxInputType struct {
	BlockNo     int // Which block is this from
	TxOffset    int // The transaction in the block. In the block[BlockHash].Tx[TxOffset]
	TxOutputPos int // Position of the output in the transaction. In the  block[BlockHash].Tx[TxOffset].Output[TxOutptuPos]
	Amount      int // Value
}

type TxOutputType struct {
	BlockNo     int              // Which block is this in
	TxOffset    int              // Which transaction in this block.  block[this].Tx[TxOffset]
	TxOutputPos int              // Position of the output in this block. In the  block[this].Tx[TxOffset].Output[TxOutptuPos]
	Account     addr.AddressType // Acctount funds go to (If this is ""chagne"" then this is the same as TransactionType.Account
	Amount      int              // Amoutn to go to accoutn
}
]]])
```
