  1: ...
  2: // BlockType is a single block in the block chain.
  3: type BlockType struct {
  4:     Index         int                             // position of this block in the chain, 0, 1, 2, ...
  5:     Desc          string                          // if "genesis" string then this is a genesis block.
  6:     ThisBlockHash hash.BlockHashType              //
  7:     PrevBlockHash hash.BlockHashType              // This is 0 length if this is a "genesis" block
  8:     Nonce         uint64                          //
  9:     Seal          hash.SealType                   //
 10:     MerkleHash    hash.MerkleHashType             // AS-03
 11:     Tx            []*transactions.TransactionType // Add Transactions to Block Later, (AS-04 will do this)
 12: }
 13: ...
