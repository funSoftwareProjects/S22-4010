  1: package merkle
  2: 
  3: import (
  4:     "fmt"
  5: 
  6:     "github.com/Univ-Wyo-Education/S22-4010/homework/03/bsvr/hash"
  7: )
  8: 
  9: // TODO - uncomment the imports when you build your code.
 10: /*
 11: import (
 12:     "fmt"
 13: 
 14:     "github.com/Univ-Wyo-Education/S21-4010-a04/bsvr/hash"
 15: )
 16: */
 17: 
 18: func MerkleHash(data [][]byte) []byte {
 19:     // return InstructorMerkleHash(data) // TODO: Replace this line with your code.
 20: 
 21:     // Build a place to put the hashes for the leaves
 22:     hLeaf := make([][]byte, 0, len(data))
 23:     // Calculate Leaf Hashes
 24:     for ii := range data {
 25:         aHash := hash.HashOf(data[ii])
 26:         hLeaf = append(hLeaf, aHash)
 27:     }
 28:     // fmt.Printf("Leaf Hashes : %s, AT: %s\n", dumpSSB(hLeaf), godebug.LF())
 29:     hMid := make([][]byte, 0, (len(hLeaf)/2)+1)
 30:     ln := len(hLeaf)/2 + 1
 31:     // fmt.Printf("ln=%d AT:%s\n", ln, godebug.LF())
 32:     for ln >= 1 {
 33:         // fmt.Printf("\n%s-------- TOP -------- AT:%s %s\n", MiscLib.ColorGreen, godebug.LF(), MiscLib.ColorReset)
 34:         for ii := 0; ii < len(hLeaf); ii += 2 {
 35:             // fmt.Printf("ii+1 = %d len(hLeaf) = %d AT:%s\n", ii+1, len(hLeaf), godebug.LF())
 36:             if ii+1 < len(hLeaf) {
 37:                 hT := hash.Keccak256(hLeaf[ii], hLeaf[ii+1])
 38:                 hMid = append(hMid, hT)
 39:                 // fmt.Printf("AT:%s\n", godebug.LF())
 40:             } else {
 41:                 hT := hash.Keccak256(hLeaf[ii])
 42:                 hMid = append(hMid, hT)
 43:                 // fmt.Printf("AT:%s\n", godebug.LF())
 44:             }
 45:         }
 46:         hLeaf = hMid
 47:         ln = len(hLeaf) / 2
 48:         hMid = make([][]byte, 0, ln)
 49:         // fmt.Printf("ln = %d Mid Hashes : %s, AT: %s\n", ln, dumpSSB(hLeaf), godebug.LF())
 50:     }
 51:     // fmt.Printf("\nFinal Hash : %s, AT: %s\n", dumpSSB(hLeaf), godebug.LF())
 52:     return hLeaf[0]
 53: }
 54: 
 55: func dumpSSB(x [][]byte) (s string) {
 56:     s = "["
 57:     com := ""
 58:     for ii := range x {
 59:         st := fmt.Sprintf("%x", x[ii])
 60:         s += com + st
 61:         com = ", "
 62:     }
 63:     s += "]"
 64:     return
 65: }
