  1: package merkle
  2: 
  3: //
  4: //import (
  5: //    "fmt"
  6: //
  7: //    "github.com/Univ-Wyo-Education/S21-4010-a04/bsvr/hash"
  8: //)
  9: //
 10: //func StudentAyaMerkleHash(data [][]byte) []byte {
 11: //    hTmp := make([][]byte, 0, len(data))
 12: //    var hasedDataBlk []byte
 13: //    for _, dat := range data {
 14: //        hasedDataBlk = hash.HashOf(dat)
 15: //        hTmp = append(hTmp, hasedDataBlk)
 16: //    }
 17: //    length := (len(data) / 2) + 1
 18: //    hMid := make([][]byte, 0, length)
 19: //    for length >= 1 {
 20: //        fmt.Printf("lenght = %d\n", length)
 21: //        // for i, _ := range hMid {    // orig
 22: //        // for i := 0; i < len(hTmp); i += 2 {
 23: //        for i := 0; i < len(hTmp); {
 24: //            // Expected behavior is i == 0, 2, 4, 6... - even numbes
 25: //            fmt.Printf("Top of inner loop: i=%d\n", i)
 26: //            if i < 0 || i >= len(hTmp) {
 27: //                fmt.Printf("i out of range - will go boom soon, i=%d\n", i)
 28: //            }
 29: //            if (i % 2) == 1 { // is odd
 30: //                fmt.Printf("i should never be ood, thisis odd i=%d\n", i)
 31: //            }
 32: //            if i == len(hTmp)-1 {
 33: //                // hasedDataBlk = hash.HashOf(hMid[i]) // Orig
 34: //                hasedDataBlk = hash.HashOf(hTmp[i])
 35: //            } else {
 36: //                // hasedDataBlk = hash.Keccak256(hMid[i], hMid[i+1]) // Orig
 37: //                hasedDataBlk = hash.Keccak256(hTmp[i], hTmp[i+1])
 38: //            }
 39: //            // i = i + 2 // orig
 40: //            i += 2
 41: //            hMid = append(hMid, hasedDataBlk)
 42: //            fmt.Printf("Bot of inner loop: i=%d, after += 2\n", i)
 43: //        }
 44: //        hTmp = hMid
 45: //        length = (len(hTmp) / 2) // TODO - maybee len(hTmp)/2+1
 46: //        hMid = make([][]byte, 0, length)
 47: //    }
 48: //    return hTmp[0]
 49: //}
