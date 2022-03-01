  1: package main
  2: 
  3: import (
  4:     "bufio"
  5:     "fmt"
  6:     "os"
  7: )
  8: 
  9: //    password, err := readLIneFromStdin("Password: " )
 10: 
 11: func readLIneFromStdin(s string) (rv string, err error) {
 12: 
 13:     fmt.Printf("%s", s)
 14:     scanner := bufio.NewScanner(os.Stdin)
 15:     if scanner.Scan() {
 16:         rv = scanner.Text()
 17:     }
 18: 
 19:     err = scanner.Err()
 20:     return
 21: }
