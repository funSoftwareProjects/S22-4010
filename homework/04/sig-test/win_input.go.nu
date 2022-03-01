  1: // +build windows
  2: 
  3: package main
  4: 
  5: import (
  6:     "bufio"
  7:     "fmt"
  8:     "os"
  9: )
 10: 
 11: func GetPassphrase(p string) (string, error) {
 12:     reader := bufio.NewReader(os.Stdin)
 13:     fmt.Println("%s", p)
 14: 
 15:     text, err := reader.ReadString('\n')
 16:     return text, err
 17: }
