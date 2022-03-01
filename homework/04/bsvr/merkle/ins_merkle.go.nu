  1: package merkle
  2: 
  3: // import (
  4: //     "fmt"
  5: //
  6: //     "github.com/Univ-Wyo-Education/S21-4010-a04/bsvr/hash"
  7: // )
  8: //
  9: // func InstructorMerkleHash(data [][]byte) []byte {
 10: //     // Build a place to put the hashes for the leaves
 11: //     hLeaf := make([][]byte, 0, len(data))
 12: //     // Calculate Leaf Hashes
 13: //     for ii := range data {
 14: //         aHash := hash.HashOf(data[ii])
 15: //         hLeaf = append(hLeaf, aHash)
 16: //     }
 17: //     // fmt.Printf("Leaf Hashes : %s, AT: %s\n", dumpSSB(hLeaf), godebug.LF())
 18: //     hMid := make([][]byte, 0, (len(hLeaf)/2)+1)
 19: //     ln := len(hLeaf)/2 + 1
 20: //     // fmt.Printf("ln=%d AT:%s\n", ln, godebug.LF())
 21: //     for ln >= 1 {
 22: //         // fmt.Printf("\n%s-------- TOP -------- AT:%s %s\n", MiscLib.ColorGreen, godebug.LF(), MiscLib.ColorReset)
 23: //         for ii := 0; ii < len(hLeaf); ii += 2 {
 24: //             // fmt.Printf("ii+1 = %d len(hLeaf) = %d AT:%s\n", ii+1, len(hLeaf), godebug.LF())
 25: //             if ii+1 < len(hLeaf) {
 26: //                 hT := hash.Keccak256(hLeaf[ii], hLeaf[ii+1])
 27: //                 hMid = append(hMid, hT)
 28: //                 // fmt.Printf("AT:%s\n", godebug.LF())
 29: //             } else {
 30: //                 hT := hash.Keccak256(hLeaf[ii])
 31: //                 hMid = append(hMid, hT)
 32: //                 // fmt.Printf("AT:%s\n", godebug.LF())
 33: //             }
 34: //         }
 35: //         hLeaf = hMid
 36: //         ln = len(hLeaf) / 2
 37: //         hMid = make([][]byte, 0, ln)
 38: //         // fmt.Printf("ln = %d Mid Hashes : %s, AT: %s\n", ln, dumpSSB(hLeaf), godebug.LF())
 39: //     }
 40: //     // fmt.Printf("\nFinal Hash : %s, AT: %s\n", dumpSSB(hLeaf), godebug.LF())
 41: //     return hLeaf[0]
 42: // }
 43: //
 44: // func dumpSSB(x [][]byte) (s string) {
 45: //     s = "["
 46: //     com := ""
 47: //     for ii := range x {
 48: //         st := fmt.Sprintf("%x", x[ii])
 49: //         s += com + st
 50: //         com = ", "
 51: //     }
 52: //     s += "]"
 53: //     return
 54: // }
