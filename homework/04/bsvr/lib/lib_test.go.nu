  1: package lib
  2: 
  3: import (
  4:     "fmt"
  5:     "testing"
  6:     // "github.com/Univ-Wyo-Education/S21-4010-a04/bsvr/addr"
  7:     // "github.com/pschlump/godebug"
  8: )
  9: 
 10: func TestIsValidAddress(t *testing.T) {
 11:     tests := []struct {
 12:         AddrStr string
 13:         expect  bool
 14:     }{
 15:         {AddrStr: "0x885765a2fcfB72e68D82D656C6411b7D27BacDD7", expect: true},
 16:         {AddrStr: "0x885765a2fcfB72e68D82D656C6411b7D27BacD7", expect: false},
 17:         {AddrStr: "0x885765a2fcfB72e68D82D656C6411b7D27BacD700", expect: false},
 18:         {AddrStr: "885765a2fcfB72e68D82D656C6411b7D27BacDD7", expect: false},
 19:         {AddrStr: "885765a2fcfB72e68D82D656C6411b7D27BacDD700", expect: false},
 20:     }
 21: 
 22:     for ii, test := range tests {
 23:         // func IsValidAddress(addrStr string) bool {
 24:         got := IsValidAddress(test.AddrStr)
 25:         if got != test.expect {
 26:             t.Errorf("Test %d, expected %v got %v for %s\n", ii, test.expect, got, test.AddrStr)
 27:         }
 28:     }
 29: 
 30: }
 31: 
 32: func TestConvAddrStrToAddressType(t *testing.T) {
 33:     tests := []struct {
 34:         AddrStr    string
 35:         expectErr  bool
 36:         expectAddr string
 37:     }{
 38:         {
 39:             AddrStr:    "0x885765a2fcfB72e68D82D656C6411b7D27BacDD7",
 40:             expectErr:  false,
 41:             expectAddr: "0x885765a2fcfb72e68d82d656c6411b7d27bacdd7",
 42:         },
 43:         {AddrStr: "0x885765a2fcfB72e68D82D656C6411b7D27BacD7", expectErr: true},
 44:         {AddrStr: "0x885765a2fcfB72e68D82D656C6411b7D27BacD700", expectErr: true},
 45:         {AddrStr: "885765a2fcfB72e68D82D656C6411b7D27BacDD7", expectErr: true},
 46:         {AddrStr: "885765a2fcfB72e68D82D656C6411b7D27BacDD700", expectErr: true},
 47:     }
 48: 
 49:     for ii, test := range tests {
 50:         // func ConvAddrStrToAddressType(addrStr string) (addr addr.AddressType, err error) {
 51:         aa, err := ConvAddrStrToAddressType(test.AddrStr)
 52:         if err != nil && test.expectErr == false {
 53:             t.Errorf("Test %d, expected success got err %s\n", ii, err)
 54:         } else if err == nil && test.expectErr == true {
 55:             t.Errorf("Test %d, expected error got none, for [%s]\n", ii, test.AddrStr)
 56:         } else if test.expectErr == false {
 57:             s := fmt.Sprintf("%s", aa)
 58:             // fmt.Printf("Just Before AT:%s ->%s<-\n", godebug.LF(), s)
 59:             if s != test.expectAddr {
 60:                 t.Errorf("Test %d\n   expected ->%s<-\n   got      ->%s<-\n", ii, test.expectAddr, aa)
 61:             }
 62:         }
 63:     }
 64: 
 65: }
