  1: package addr
  2: 
  3: import (
  4:     "encoding/hex"
  5:     "encoding/json"
  6:     "fmt"
  7:     "os"
  8: )
  9: 
 10: type AddressType []byte
 11: 
 12: func (ww AddressType) MarshalJSON() ([]byte, error) {
 13:     return []byte(`"` + hex.EncodeToString(ww) + `"`), nil
 14: }
 15: 
 16: func (ww *AddressType) UnmarshalJSON(b []byte) error {
 17:     // First, deserialize everything into a local data type that matches with data.
 18:     var objMap string
 19:     err := json.Unmarshal(b, &objMap)
 20:     if err != nil {
 21:         return err
 22:     }
 23:     // fmt.Printf("string ->%s<-, %s\n", objMap, godebug.LF())
 24: 
 25:     xx, err := hex.DecodeString(objMap)
 26:     if err != nil {
 27:         return err
 28:     }
 29:     // fmt.Printf("hex ->%x<-, %s\n", xx, godebug.LF())
 30: 
 31:     *ww = append(*ww, xx...)
 32: 
 33:     // fmt.Printf("got ->%x<-, %s\n", *ww, godebug.LF())
 34:     return nil
 35: }
 36: 
 37: // String is the insterface for fmt.String so that you can print an address as a "%s" and get human output.
 38: func (aa AddressType) String() string {
 39:     return "0x" + hex.EncodeToString(aa)
 40: }
 41: 
 42: func ParseAddr(s string) (addr AddressType, err error) {
 43:     if s[0:2] == "0x" {
 44:         s = s[2:]
 45:     }
 46:     addr, err = hex.DecodeString(s)
 47:     if err != nil {
 48:         return []byte{}, err
 49:     }
 50:     return
 51: }
 52: 
 53: func MustParseAddr(s string) AddressType {
 54:     addr, err := ParseAddr(s)
 55:     if err != nil {
 56:         fmt.Printf("Error parsing address [%s] error [%s]\n", s, err)
 57:         os.Exit(1)
 58:     }
 59:     return addr
 60: }
