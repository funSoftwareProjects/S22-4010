  1: package block
  2: 
  3: import (
  4:     "encoding/json"
  5:     "fmt"
  6:     "io/ioutil"
  7:     "os"
  8: 
  9:     "github.com/pschlump/godebug"
 10: )
 11: 
 12: // ReadBlock reads in from a file a block and returns it.
 13: func ReadBlock(fn string) (bk *BlockType, err error) {
 14:     data, err := ioutil.ReadFile(fn)
 15:     if err != nil {
 16:         fmt.Fprintf(os.Stderr, "Unable to read block %s [at %s], %s\n", fn, godebug.LF(), err)
 17:         return nil, err
 18:     }
 19:     bk = &BlockType{}
 20:     err = json.Unmarshal(data, bk)
 21:     if err != nil {
 22:         fmt.Fprintf(os.Stderr, "Unable to read block %s [at %s], %s\n", fn, godebug.LF(), err)
 23:         return nil, err
 24:     }
 25:     return bk, nil
 26: }
 27: 
 28: // WriteBlock read i;n a block from a file.
 29: func WriteBlock(fn string, bk *BlockType) (err error) {
 30: 
 31:     data := IndentJSON(bk)
 32: 
 33:     err = ioutil.WriteFile(fn, []byte(data), 0644)
 34: 
 35:     return
 36: }
 37: 
 38: // IndentJSON converts data to JSON format and returns it as a string.
 39: func IndentJSON(v interface{}) string {
 40:     s, err := json.MarshalIndent(v, "", "\t")
 41:     if err != nil {
 42:         return fmt.Sprintf("Error:%s", err)
 43:     } else {
 44:         return string(s)
 45:     }
 46: }
