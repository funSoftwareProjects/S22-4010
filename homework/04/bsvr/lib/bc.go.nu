  1: package lib
  2: 
  3: import (
  4:     "encoding/hex"
  5:     "fmt"
  6: 
  7:     "github.com/Univ-Wyo-Education/S22-4010/homework/04/bsvr/addr"
  8: )
  9: 
 10: type SignatureType string
 11: 
 12: // func ValidSignature(sig SignatureType, msg string, from addr.AddressType) bool {
 13: //     return true
 14: // }
 15: 
 16: // IsValidAddress returns true if the addresss is a validate looking address.
 17: func IsValidAddress(addrStr string) bool {
 18:     if len(addrStr) != 40+2 { // must be 2 chars for 0x, then 20 bytes of public key.
 19:         // fmt.Printf("Len=%d AT: %s\n", len(addrStr), godebug.LF())
 20:         return false
 21:     }
 22:     if addrStr[0:2] != "0x" { // must stat with 0x
 23:         // fmt.Printf("AT: %s\n", godebug.LF())
 24:         return false
 25:     }
 26:     // We could check if the address is EIP-55 encoded also!
 27:     addrStr = addrStr[2:] // Keep all the stuff after the 0x
 28:     _, err := hex.DecodeString(addrStr)
 29:     if err != nil {
 30:         // fmt.Printf("AT: %s\n", godebug.LF())
 31:         return false
 32:     }
 33:     return true
 34: }
 35: 
 36: func ConvAddrStrToAddressType(addrStr string) (addr addr.AddressType, err error) {
 37:     if !IsValidAddress(addrStr) {
 38:         // fmt.Printf("ERR 1 Input: %s AT: %s\n", addrStr, godebug.LF())
 39:         return []byte{}, fmt.Errorf("invalid address, not 0xHEX...\n")
 40:     }
 41:     tmp, err := hex.DecodeString(addrStr[2:])
 42:     if err != nil {
 43:         // fmt.Printf("ERR 2 AT: %s\n", godebug.LF())
 44:         return []byte{}, err
 45:     }
 46:     addr = tmp
 47:     // fmt.Printf("SUCCESS tmp=%x addr=%s AT: %s\n", tmp, addr, godebug.LF())
 48:     return
 49: }
 50: 
 51: // RunSmartContract -- Implemented in Assignment 6
 52: func RunSmartContract() {
 53:     // TODO - we will implement this in asssignment 6 - AS-06.
 54: }
