  1: package block
  2: 
  3: import (
  4:     "bytes"
  5:     "encoding/binary"
  6: 
  7:     "github.com/Univ-Wyo-Education/S22-4010/homework/04/bsvr/hash"
  8:     "github.com/Univ-Wyo-Education/S22-4010/homework/04/bsvr/merkle"
  9:     "github.com/Univ-Wyo-Education/S22-4010/homework/04/bsvr/transactions"
 10: )
 11: 
 12: // GenesisDesc is the constant that marks that a block is a genesis block.
 13: const GenesisDesc = "GenesisBlock Fri Aug 17 23:16:12 MDT 2018"
 14: 
 15: // BlockType is a single block in the block chain.
 16: type BlockType struct {
 17:     Index         int                             // position of this block in the chain, 0, 1, 2, ...
 18:     Desc          string                          // if "genesis" string then this is a genesis block.
 19:     ThisBlockHash hash.BlockHashType              //
 20:     PrevBlockHash hash.BlockHashType              // This is 0 length if this is a "genesis" block
 21:     Nonce         uint64                          //
 22:     Seal          hash.SealType                   //
 23:     MerkleHash    hash.MerkleHashType             // AS-03
 24:     Tx            []*transactions.TransactionType // Add Transactions to Block Later, (AS-04 will do this)
 25: }
 26: 
 27: // InitGenesisBlock create and return a genesis block.   This is a special
 28: // block at the beginning of a chain.
 29: func InitGenesisBlock() (gb *BlockType) {
 30:     gb = &BlockType{
 31:         Index:         0,
 32:         Desc:          GenesisDesc,
 33:         ThisBlockHash: []byte{},
 34:         PrevBlockHash: []byte{},
 35:         Nonce:         0,
 36:         Seal:          []byte{},
 37:         MerkleHash:    []byte{},
 38:         Tx:            make([]*transactions.TransactionType, 0, 1), // Add Transactions to Block Later, (AS-04 will do this)
 39:     }
 40:     gb.ThisBlockHash = hash.HashOf(SerializeBlock(gb))
 41:     return
 42: }
 43: 
 44: // InitBlock creates and returns a block.
 45: func InitBlock(ii int, dd string, prev hash.BlockHashType) (bk *BlockType) {
 46:     bk = &BlockType{
 47:         Index:         ii,
 48:         Desc:          dd,
 49:         ThisBlockHash: []byte{},
 50:         PrevBlockHash: prev,
 51:         Nonce:         0,
 52:         Seal:          []byte{},
 53:         MerkleHash:    []byte{},
 54:         Tx:            make([]*transactions.TransactionType, 0, 1), // Add Transactions to Block Later, (AS-04 will do this)
 55:     }
 56:     bk.ThisBlockHash = hash.HashOf(SerializeBlock(bk))
 57:     return
 58: }
 59: 
 60: // IsGenesisBlock returns true if this is a genisis block.
 61: func IsGenesisBlock(bk *BlockType) bool {
 62:     if bk.Desc == GenesisDesc && len(bk.PrevBlockHash) == 0 {
 63:         return true
 64:     }
 65:     return false
 66: }
 67: 
 68: // SearalizeBlock searializes into bytes the fields that will be hashed the hash of the block.
 69: // This is the hash that the next block will use to point to this block and the hash that
 70: // this block will be saved as.
 71: func SerializeBlock(bk *BlockType) []byte {
 72:     var buf bytes.Buffer
 73:     binary.Write(&buf, binary.BigEndian, bk.Index)
 74:     buf.Write([]byte(bk.Desc))
 75:     buf.Write([]byte(bk.PrevBlockHash))
 76:     if len(bk.Tx) > 0 {
 77:         mData := make([][]byte, 0, len(bk.Tx))
 78:         for _, tx := range bk.Tx {
 79:             it := transactions.SerializeForSeal(tx)
 80:             buf.Write(it)
 81:             mData = append(mData, it)
 82:         }
 83:         bk.MerkleHash = merkle.MerkleHash(mData)
 84:         buf.Write([]byte(bk.MerkleHash))
 85:     }
 86:     return buf.Bytes()
 87: }
 88: 
 89: // SearalizeForSeal searializes into bytes the fields that will be hashed for the mining seal.
 90: func SerializeForSeal(bk *BlockType) []byte {
 91:     var buf bytes.Buffer
 92:     binary.Write(&buf, binary.BigEndian, bk.Index)
 93:     buf.Write([]byte(bk.Desc))
 94:     buf.Write([]byte(bk.ThisBlockHash))
 95:     buf.Write([]byte(bk.PrevBlockHash))
 96:     binary.Write(&buf, binary.BigEndian, bk.Nonce)
 97:     if len(bk.Tx) > 0 {
 98:         mData := make([][]byte, 0, len(bk.Tx))
 99:         for _, tx := range bk.Tx {
100:             it := transactions.SerializeForSeal(tx)
101:             buf.Write(it)
102:             mData = append(mData, it)
103:         }
104:         bk.MerkleHash = merkle.MerkleHash(mData)
105:         buf.Write([]byte(bk.MerkleHash))
106:     }
107:     return buf.Bytes()
108: }
