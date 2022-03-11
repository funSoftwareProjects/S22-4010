  1: package main
  2: 
  3: import (
  4:     "fmt"
  5:     "io/ioutil"
  6: 
  7:     "github.com/pschlump/json"
  8: )
  9: 
 10: // EmptyDflt if s is empty, then return d.  Creates a default value for parametrs
 11: func EmptyDflt(s, d string) string {
 12:     if s == "" {
 13:         return d
 14:     }
 15:     return s
 16: }
 17: 
 18: // ReadJson read in a JSON file into a go data structure.
 19: func ReadJson(fn string, x interface{}) (err error) {
 20:     var buf []byte
 21:     buf, err = ioutil.ReadFile(fn)
 22:     if err != nil {
 23:         return
 24:     }
 25:     err = json.Unmarshal(buf, x)
 26:     return
 27: }
 28: 
 29: // SVar return the JSON encoded version of the data.
 30: func SVar(v interface{}) string {
 31:     s, err := json.Marshal(v)
 32:     // s, err := json.MarshalIndent ( v, "", "\t" )
 33:     if err != nil {
 34:         return fmt.Sprintf("Error:%s", err)
 35:     } else {
 36:         return string(s)
 37:     }
 38: }
 39: 
 40: // SVarI return the JSON encoded version of the data with tab indentation.
 41: func SVarI(v interface{}) string {
 42:     // s, err := json.Marshal ( v )
 43:     s, err := json.MarshalIndent(v, "", "\t")
 44:     if err != nil {
 45:         return fmt.Sprintf("Error:%s", err)
 46:     } else {
 47:         return string(s)
 48:     }
 49: }
