  1: package hash
  2: 
  3: import (
  4:     "encoding/hex"
  5:     "encoding/json"
  6: )
  7: 
  8: type MerkleHashType []byte // Hash of data in block -- Eventually a Merkle hash
  9: 
 10: func (ww MerkleHashType) MarshalJSON() ([]byte, error) {
 11:     return []byte(`"` + hex.EncodeToString(ww) + `"`), nil
 12: }
 13: 
 14: func (ww *MerkleHashType) UnmarshalJSON(b []byte) error {
 15:     // First, deserialize everything into a local data type that matches with data.
 16:     var objMap string
 17:     err := json.Unmarshal(b, &objMap)
 18:     if err != nil {
 19:         return err
 20:     }
 21:     // fmt.Printf("string ->%s<-, %s\n", objMap, godebug.LF())
 22: 
 23:     xx, err := hex.DecodeString(objMap)
 24:     if err != nil {
 25:         return err
 26:     }
 27:     // fmt.Printf("hex ->%x<-, %s\n", xx, godebug.LF())
 28: 
 29:     *ww = append(*ww, xx...)
 30: 
 31:     // fmt.Printf("got ->%x<-, %s\n", *ww, godebug.LF())
 32:     return nil
 33: }
