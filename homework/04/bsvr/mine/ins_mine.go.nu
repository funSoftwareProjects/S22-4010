  1: package mine
  2: 
  3: import (
  4:     "encoding/hex"
  5:     "fmt"
  6: 
  7:     "github.com/Univ-Wyo-Education/S22-4010/homework/04/bsvr/block"
  8:     "github.com/Univ-Wyo-Education/S22-4010/homework/04/bsvr/hash"
  9: )
 10: 
 11: // MineBlock implements a proof of work mining system where the first 4 digits (2 bytes) of the hex value are 0.
 12: // Difficulty can be increaesed by requiring more digits to be 0 or by requring some other pattern to apear in
 13: // the resulting hash.
 14: func MineBlock(bk *block.BlockType, difficulty string) {
 15:     for {
 16:         data := block.SerializeForSeal(bk)
 17:         hh := hash.HashOf(data)
 18:         hhStr := hex.EncodeToString(hh)
 19:         // fmt.Printf("((Mining)) Hash for Block [%s] nonce [%8d]\r", hhStr, bk.Nonce)
 20:         // This is where proof-of-stake will be checked
 21:         if len(difficulty) == 0 || hhStr[0:len(difficulty)] == difficulty {
 22:             bk.Seal = hh
 23:             fmt.Printf("((Mining)) Hash for Block [%s] nonce [%8d]\n", hhStr, bk.Nonce)
 24:             return
 25:         }
 26:         bk.Nonce++
 27:     }
 28: }
