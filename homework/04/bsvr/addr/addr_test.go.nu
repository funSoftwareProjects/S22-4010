  1: package addr
  2: 
  3: import (
  4:     "fmt"
  5:     "testing"
  6: )
  7: 
  8: /*
  9: // String is the insterface for fmt.String so that you can print an address as a "%s" and get human output.
 10: func (aa AddressType) String() string {
 11:     return "0x" + hex.EncodeToString(aa)
 12: }
 13: */
 14: 
 15: func Test_FormatAsString(t *testing.T) {
 16:     var aa AddressType
 17:     aa = []byte{4, 1, 3, 1, 8, 5}
 18:     ss := fmt.Sprintf("%s", aa)
 19:     // fmt.Printf("%s\n", ss)
 20:     if ss != "0x040103010805" {
 21:         t.Errorf("Should have formatted, did not.")
 22:     }
 23: }
