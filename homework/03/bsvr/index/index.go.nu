  1: package index
  2: 
  3: import (
  4:     "encoding/json"
  5:     "fmt"
  6:     "io/ioutil"
  7: 
  8:     "github.com/Univ-Wyo-Education/S22-4010/homework/03/bsvr/addr"
  9:     "github.com/Univ-Wyo-Education/S22-4010/homework/03/bsvr/block"
 10:     "github.com/Univ-Wyo-Education/S22-4010/homework/03/bsvr/lib"
 11: )
 12: 
 13: /*
 14: 
 15: Example Data (sort of with stuff ...ed out)
 16:     {
 17:         "Index": [ "126c..", .... ]
 18:         "TxHashIndex": {
 19:             "1212121...": {
 20:                 "Index": 0,
 21:                 "BlockHash": "1212222",
 22:             },
 23:             "2212121...": {
 24:                 "Index": 1,
 25:                 "BlockHash": "1212222",
 26:             }
 27:         }
 28:     }
 29: 
 30: */
 31: 
 32: //type TxHashIndexType struct {
 33: //    Index     int
 34: //    BlockHash string
 35: //}
 36: 
 37: type AddrHashIndexType struct {
 38:     Addr addr.AddressType
 39:     Data string
 40: }
 41: 
 42: type TxWithValue struct {
 43:     Addr  addr.AddressType // Address of Self
 44:     Value []TxWithAValue   // List of Values in a set of blocks, may have more than one value per block.
 45: }
 46: 
 47: type TxWithAValue struct {
 48:     BlockIndex  int // Index of this block
 49:     TxOffset    int // position of this Tx in the array of Tx in the block, this is in block.Tx[TxOffset]
 50:     TxOutputPos int // positon of the output with a positive value in the transaction, block.Tx[TxOffset].Output[TxOutputPos]
 51: }
 52: 
 53: type AddressIndex struct {
 54:     AddrIndex map[string]AddrHashIndexType // Map of address to date (for S.C.)
 55: }
 56: 
 57: type ValueIndex struct {
 58:     AddrIndex map[string]TxWithValue // Map of address to list of Transaction with output value.
 59: }
 60: 
 61: type BlockIndex struct {
 62:     Index            []string       // List of block-hash
 63:     BlockHashToIndex map[string]int // map from hash back to index
 64:     AddrData         AddressIndex   // Contains map of addresses to data on this address
 65:     FindValue        ValueIndex     // Locaitons of value
 66:     // TxHashIndex      map[string]TxHashIndexType // Map of block-hash to transactions
 67: }
 68: 
 69: func ReadIndex(fn string) (idx *BlockIndex, err error) {
 70:     var buf []byte
 71:     buf, err = ioutil.ReadFile(fn)
 72:     if err != nil {
 73:         return nil, err
 74:     }
 75:     idx = &BlockIndex{}
 76:     err = json.Unmarshal(buf, idx)
 77:     if err != nil {
 78:         err = fmt.Errorf("invalid initialization - Unable to parse JSON file, %s", err)
 79:         return nil, err
 80:     }
 81:     return
 82: }
 83: 
 84: //func WriteIndex(fn string, bkslice []*block.BlockType) {
 85: //    indexForBlocks := BuildIndex(bkslice)
 86: //    ioutil.WriteFile(fn, []byte(lib.SVarI(indexForBlocks)), 0644)
 87: //}
 88: 
 89: func WriteIndex(fn string, indexForBlocks *BlockIndex) error {
 90:     return ioutil.WriteFile(fn, []byte(lib.SVarI(indexForBlocks)), 0644)
 91: }
 92: 
 93: func BuildIndex(bkslice []*block.BlockType) (idx BlockIndex) {
 94:     for _, bk := range bkslice {
 95:         idx.Index = append(idx.Index, fmt.Sprintf("%x", bk.ThisBlockHash))
 96:     }
 97:     //idx.TxHashIndex = make(map[string]TxHashIndexType)
 98:     //for ii, bk := range bkslice {
 99:     //    idx.TxHashIndex[fmt.Sprintf("%x", bk.ThisBlockHash)] = TxHashIndexType{
100:     //        Index:     ii,
101:     //        BlockHash: fmt.Sprintf("%x", bk.ThisBlockHash),
102:     //    }
103:     //}
104:     return
105: }
