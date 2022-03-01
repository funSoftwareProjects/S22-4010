  1: package merkle
  2: 
  3: //
  4: //import (
  5: //    "encoding/hex"
  6: //    "testing"
  7: //)
  8: //
  9: //func TestMerkleHashStudentAyaCode(t *testing.T) {
 10: //
 11: //    tests := []struct {
 12: //        data         [][]byte
 13: //        expectedHash string
 14: //    }{
 15: //        {
 16: //            data:         [][]byte{{0x10, 0x22}, {0x44, 0x51, 0x32}},
 17: //            expectedHash: "2d35b13160d84eaa133178f7e4d259d8c6cacc95057215495d042897adee53d2",
 18: //        },
 19: //        {
 20: //            data:         [][]byte{{0x10, 0x22}},
 21: //            expectedHash: "3b8cbc855c432466f2f4e05c07e5234631d9f3985096fdce7b5126424306b508",
 22: //        },
 23: //        {
 24: //            data:         [][]byte{{0x10, 0x22}, {0x44, 0x51, 0x32}, {0x00, 0x88, 0x41, 0x22, 0x33}},
 25: //            expectedHash: "cfecba8c0aed379216509b63f5e12aedb6582aa389168228dd96e6211d6f3ae1",
 26: //        },
 27: //        {
 28: //            data:         [][]byte{{0x10, 0x22}, {0x44, 0x51, 0x32}, {0x00, 0x88, 0x41, 0x22, 0x33}, {0x09, 0x10}},
 29: //            expectedHash: "abf91783e802d581828eb40f8f925d8f1dcbe72136855c908e4667c115b4ead1",
 30: //        },
 31: //        {
 32: //            data:         [][]byte{{0x10, 0x22}, {0x44, 0x51, 0x32}, {0x01}, {0x00, 0x88, 0x41, 0x22, 0x33}},
 33: //            expectedHash: "ba58d2b518c7c619a10b73ae5c881a0fdd2497f5eb93d96931a9017cb84018b6",
 34: //        },
 35: //        {
 36: //            data:         [][]byte{{0x10, 0x22}, {0x44, 0x51, 0x32}, {0x01}, {0x01, 0x02, 0x02, 0x04}, {0x00, 0x88, 0x41, 0x22, 0x33}},
 37: //            expectedHash: "a80780f7d875cf401dbea84580788f7ca5eeb21de7f1a89373c312b9dc47891c",
 38: //        },
 39: //    }
 40: //
 41: //    for ii, test := range tests {
 42: //        h := StudentAyaMerkleHash(test.data)
 43: //        hStr := hex.EncodeToString(h)
 44: //        if hStr != test.expectedHash {
 45: //            t.Errorf("Test %d, expected %s got %s\n", ii, test.expectedHash, hStr)
 46: //        }
 47: //    }
 48: //
 49: //}
