  1: package hash
  2: 
  3: import (
  4:     "encoding/hex"
  5: 
  6:     "golang.org/x/crypto/sha3"
  7: )
  8: 
  9: // Keccak256 use the Ethereum Keccak hasing fucntions to return a hash from a list of values.
 10: func Keccak256(data ...[]byte) []byte {
 11:     d := sha3.NewLegacyKeccak256()
 12:     for _, b := range data {
 13:         d.Write(b)
 14:     }
 15:     return d.Sum(nil)
 16: }
 17: 
 18: // HashOfBlock calcualtes the hash of the 'data' and returns it.
 19: func HashOf(data []byte) (h []byte) {
 20:     h = Keccak256(data)
 21:     return
 22: }
 23: 
 24: // HashStringOf calcualtes the hash of the 'data' and returns it.
 25: func HashStrngOf(data string) (h []byte) {
 26:     h = Keccak256([]byte(data))
 27:     return
 28: }
 29: 
 30: // HashStringOfReturnHex calcualtes the hash of the 'data' and returns it.
 31: func HashStrngOfReturnHex(data string) (s string) {
 32:     h := Keccak256([]byte(data))
 33:     s = hex.EncodeToString(h)
 34:     return
 35: }
