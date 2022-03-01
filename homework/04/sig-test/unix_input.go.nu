  1: // +build darwin freebsd netbsd openbsd linux darwin
  2: 
  3: package main
  4: 
  5: import (
  6:     "bufio"
  7:     "fmt"
  8:     "os"
  9: )
 10: 
 11: //import "github.com/ethereum/go-ethereum/console"
 12: 
 13: func GetPassphrase(p string) (string, error) {
 14: 
 15:     //    passphrase, err := console.Stdin.PromptPassword("Passphrase: ")
 16:     //    return passphrase, err
 17: 
 18:     reader := bufio.NewReader(os.Stdin)
 19:     fmt.Println("%s", p)
 20: 
 21:     text, err := reader.ReadString('\n')
 22:     return text, err
 23: }
