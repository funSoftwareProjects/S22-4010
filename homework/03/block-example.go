...
// BlockType is a single block in the block chain.
type BlockType struct {
	Index         int                             // position of this block in the chain, 0, 1, 2, ...
	Desc          string                          // if "genesis" string then this is a genesis block.
	ThisBlockHash hash.BlockHashType              //
	PrevBlockHash hash.BlockHashType              // This is 0 length if this is a "genesis" block
	Nonce         uint64                          //
	Seal          hash.SealType                   //
	MerkleHash    hash.MerkleHashType             // AS-03
	Tx            []*transactions.TransactionType // Add Transactions to Block Later, (AS-04 will do this)
}
...
