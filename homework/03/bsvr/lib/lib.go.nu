  1: package lib
  2: 
  3: import (
  4:     "errors"
  5:     "fmt"
  6:     "os"
  7: 
  8:     "github.com/pschlump/MiscLib"
  9:     "github.com/pschlump/godebug"
 10:     "github.com/pschlump/json"
 11: )
 12: 
 13: //    "encoding/json"
 14: 
 15: // SVarI  marshals and indents a data structure into JSON.
 16: func SVarI(v interface{}) string {
 17:     // s, err := json.Marshal ( v )
 18:     s, err := json.MarshalIndent(v, "", "\t")
 19:     if err != nil {
 20:         return fmt.Sprintf("Error:%s", err)
 21:     }
 22:     return string(s)
 23: }
 24: 
 25: // Assert that 'assertion' is true.  If not exit program.
 26: func Assert(assertion bool) {
 27:     if !assertion {
 28:         fmt.Fprintf(os.Stderr, "%sFatal: Failed Assertion AT: %s%s\n", MiscLib.ColorRed, godebug.LF(2), MiscLib.ColorReset)
 29:         os.Exit(2)
 30:     }
 31: }
 32: 
 33: // Exists returns true if file exists. It will return true for directories also.
 34: func Exists(name string) bool {
 35:     if _, err := os.Stat(name); err != nil {
 36:         if os.IsNotExist(err) {
 37:             return false
 38:         }
 39:     }
 40:     return true
 41: }
 42: 
 43: var invalidMode = errors.New("Invalid Mode")
 44: 
 45: // Fopen opens the file name with mode having the same meaing as the C/C++ stdio.h Fopen.
 46: func Fopen(fn string, mode string) (file *os.File, err error) {
 47:     file = nil
 48:     if mode == "r" {
 49:         file, err = os.Open(fn) // For read access.
 50:     } else if mode == "w" {
 51:         file, err = os.OpenFile(fn, os.O_WRONLY|os.O_CREATE|os.O_TRUNC, 0666)
 52:     } else if mode == "a" {
 53:         file, err = os.OpenFile(fn, os.O_RDWR|os.O_APPEND, 0660)
 54:         if err != nil {
 55:             file, err = os.OpenFile(fn, os.O_WRONLY|os.O_CREATE|os.O_TRUNC, 0666)
 56:         }
 57:     } else {
 58:         err = invalidMode
 59:     }
 60:     return
 61: }
