  1: package mine
  2: 
  3: import (
  4:     "encoding/hex"
  5:     "testing"
  6: 
  7:     "github.com/Univ-Wyo-Education/S22-4010/homework/04/bsvr/block"
  8:     "github.com/Univ-Wyo-Education/S22-4010/homework/04/bsvr/hash"
  9: )
 10: 
 11: func TestMineBlock(t *testing.T) {
 12: 
 13:     tests := []struct {
 14:         bk               block.BlockType
 15:         expectedSealHash string
 16:         expectedNonce    uint64
 17:     }{
 18:         {
 19:             bk: block.BlockType{
 20:                 Index:         0,
 21:                 Desc:          block.GenesisDesc,
 22:                 ThisBlockHash: []byte{},
 23:                 PrevBlockHash: []byte{},
 24:                 Nonce:         0,
 25:                 Seal:          []byte{},
 26:             },
 27:             expectedSealHash: "0000ae2cab130b4836988969f731c4f884ac4675790e5575a5161e5b96ab13d7",
 28:             expectedNonce:    54586,
 29:         },
 30:         {
 31:             bk: block.BlockType{
 32:                 Index:         1,
 33:                 Desc:          "My First Block",
 34:                 ThisBlockHash: []byte{},
 35:                 PrevBlockHash: []byte{},
 36:                 Nonce:         0,
 37:                 Seal:          []byte{},
 38:             },
 39:             expectedSealHash: "0000adc29a80f1f0df08c8687c013d179050f5d1b449599e4d1437e4fad23525",
 40:             expectedNonce:    46734,
 41:         },
 42:         {
 43:             bk: block.BlockType{
 44:                 Index:         1,
 45:                 Desc:          "My First Block",
 46:                 ThisBlockHash: []byte{},
 47:                 PrevBlockHash: MustDecodeString("136c53391115ab7ff717bd24e62dd0df2c270500d7194290169a83488022548e"),
 48:                 Nonce:         0,
 49:                 Seal:          []byte{},
 50:             },
 51:             expectedSealHash: "000026ac02359874bdfa606769a8f2a4e9d3d3de781214774128d604c67ffc46",
 52:             expectedNonce:    143620,
 53:         },
 54:     }
 55: 
 56:     for ii, test := range tests {
 57:         test.bk.ThisBlockHash = hash.HashOf(block.SerializeBlock(&test.bk))
 58:         tests[ii] = test
 59:     }
 60: 
 61:     for ii, test := range tests {
 62:         bk := &test.bk
 63:         MineBlock(bk, "0000")
 64:         SealString := hex.EncodeToString(bk.Seal)
 65:         if SealString != test.expectedSealHash {
 66:             t.Errorf("Test %d, expected %s got %s\n", ii, test.expectedSealHash, SealString)
 67:         }
 68:         if bk.Nonce != test.expectedNonce {
 69:             t.Errorf("Test %d, expected %d got %d\n", ii, test.expectedNonce, bk.Nonce)
 70:         }
 71:     }
 72: 
 73: }
 74: 
 75: func MustDecodeString(s string) []byte {
 76:     rv, err := hex.DecodeString("136c53391115ab7ff717bd24e62dd0df2c270500d7194290169a83488022548e")
 77:     if err != nil {
 78:         panic(err)
 79:     }
 80:     return rv
 81: }
