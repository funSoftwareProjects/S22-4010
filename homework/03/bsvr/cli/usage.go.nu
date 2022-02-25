  1: package cli
  2: 
  3: import (
  4:     "fmt"
  5:     "os"
  6: )
  7: 
  8: func (cc *CLI) Usage() {
  9:     if len(os.Args) > 1 {
 10:         fmt.Printf("got ->%s<-\n", os.Args[1])
 11:     }
 12:     fmt.Printf(`Usage: %s [ --cfg cfg.json ] [ --create-genesis ] [ --test-read-block ] [ --test-send-funds ] [ --list-accounts ] [ --show-balance AccoutNumber ] [ --server http://Host:Port ]
 13: 
 14:         --cfg cfg.json          Configuration file
 15:         --list-accounts            List all of the current accounts in the system
 16:         --show-balance    Acct    Show the current value in a specifed account
 17:         --server URL            Run as a server on the specified host/port.
 18: 
 19: `, os.Args[0])
 20: }
