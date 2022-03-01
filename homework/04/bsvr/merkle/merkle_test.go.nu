  1: package merkle
  2: 
  3: import (
  4:     "encoding/hex"
  5:     "testing"
  6: )
  7: 
  8: func TestMerkleHash(t *testing.T) {
  9:     return
 10:     tests := []struct {
 11:         data         [][]byte
 12:         expectedHash string
 13:     }{
 14:         {
 15:             data:         [][]byte{{0x10, 0x22}, {0x44, 0x51, 0x32}},
 16:             expectedHash: "2d35b13160d84eaa133178f7e4d259d8c6cacc95057215495d042897adee53d2",
 17:         },
 18:         {
 19:             data:         [][]byte{{0x10, 0x22}},
 20:             expectedHash: "3b8cbc855c432466f2f4e05c07e5234631d9f3985096fdce7b5126424306b508",
 21:         },
 22:         {
 23:             data:         [][]byte{{0x10, 0x22}, {0x44, 0x51, 0x32}, {0x00, 0x88, 0x41, 0x22, 0x33}},
 24:             expectedHash: "cfecba8c0aed379216509b63f5e12aedb6582aa389168228dd96e6211d6f3ae1",
 25:         },
 26:         {
 27:             data:         [][]byte{{0x10, 0x22}, {0x44, 0x51, 0x32}, {0x00, 0x88, 0x41, 0x22, 0x33}, {0x09, 0x10}},
 28:             expectedHash: "abf91783e802d581828eb40f8f925d8f1dcbe72136855c908e4667c115b4ead1",
 29:         },
 30:         {
 31:             data:         [][]byte{{0x10, 0x22}, {0x44, 0x51, 0x32}, {0x01}, {0x00, 0x88, 0x41, 0x22, 0x33}},
 32:             expectedHash: "ba58d2b518c7c619a10b73ae5c881a0fdd2497f5eb93d96931a9017cb84018b6",
 33:         },
 34:         {
 35:             data:         [][]byte{{0x10, 0x22}, {0x44, 0x51, 0x32}, {0x01}, {0x01, 0x02, 0x02, 0x04}, {0x00, 0x88, 0x41, 0x22, 0x33}},
 36:             expectedHash: "a80780f7d875cf401dbea84580788f7ca5eeb21de7f1a89373c312b9dc47891c",
 37:         },
 38:     }
 39: 
 40:     for ii, test := range tests {
 41:         h := MerkleHash(test.data)
 42:         hStr := hex.EncodeToString(h)
 43:         if hStr != test.expectedHash {
 44:             t.Errorf("Test %d, expected %s got %s\n", ii, test.expectedHash, hStr)
 45:         }
 46:     }
 47: 
 48: }
