  1: package hash
  2: 
  3: import (
  4:     "encoding/json"
  5:     "reflect"
  6:     "testing"
  7: 
  8:     "github.com/Univ-Wyo-Education/S22-4010/homework/04/bsvr/lib"
  9: )
 10: 
 11: func Test_ToJSON(t *testing.T) {
 12: 
 13:     type Test1 struct {
 14:         Sh SealType
 15:         Bh BlockHashType
 16:     }
 17: 
 18:     t1 := Test1{
 19:         Sh: []byte{22, 33, 11},
 20:         Bh: Keccak256([]byte("abcdef")),
 21:     }
 22: 
 23:     got := lib.SVarI(t1)
 24:     exp := `{
 25:     "Sh": "16210b",
 26:     "Bh": "acd0c377fe36d5b209125185bc3ac41155ed1bf7103ef9f0c2aff4320460b6df"
 27: }`
 28: 
 29:     if got != exp {
 30:         t.Errorf("Got ->%s<- expected ->%s<-\n", got, exp)
 31:     }
 32: 
 33: }
 34: 
 35: func Test_FromJSON(t *testing.T) {
 36: 
 37:     type Test1 struct {
 38:         Sh SealType
 39:         Bh BlockHashType
 40:     }
 41: 
 42:     var got Test1
 43: 
 44:     exp := Test1{
 45:         Sh: []byte{22, 33, 11},
 46:         Bh: Keccak256([]byte("abcdef")),
 47:     }
 48: 
 49:     have := `{
 50:     "Sh": "16210b",
 51:     "Bh": "acd0c377fe36d5b209125185bc3ac41155ed1bf7103ef9f0c2aff4320460b6df"
 52: }`
 53: 
 54:     err := json.Unmarshal([]byte(have), &got)
 55:     if err != nil {
 56:         t.Fatalf("Error unmarshal: %s\n", err)
 57:     }
 58: 
 59:     if !reflect.DeepEqual(got, exp) {
 60:         t.Errorf("Got ->%+v<- expected ->%+v<-\n", got, exp)
 61:     }
 62: 
 63: }
