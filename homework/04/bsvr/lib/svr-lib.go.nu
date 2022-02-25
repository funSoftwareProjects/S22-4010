  1: package lib
  2: 
  3: import (
  4:     "fmt"
  5: 
  6:     "github.com/ethereum/go-ethereum/crypto"
  7: )
  8: 
  9: /*
 10: 
 11: // TODO - implement the function ValidSintaure
 12: 
 13: 
 14: 
 15: 
 16: 
 17: // The imports that I used for this:
 18: 
 19: import (
 20:     "encoding/hex"
 21:     "fmt"
 22: 
 23:     "github.com/Univ-Wyo-Education/S22-4010/homework/04/bsvr/addr"
 24:     "github.com/ethereum/go-ethereum/crypto"
 25:     "github.com/pschlump/MiscLib"
 26:     "github.com/pschlump/godebug"
 27: )
 28: 
 29: // if !lib.ValidSignature(lib.SignatureType(signature), msg, addr) { // Assignment 5 implements, just true for now.
 30: func ValidSignature(sig SignatureType, msg string, from addr.AddressType) bool {
 31:     // VerifySignature takes hex encoded addr, sig and msg and verifies that the signature matches with the address.
 32:     // Pulled form go-ethereum code.
 33: 
 34:     // TODO Decode the HEX of the msg to get back the original message.
 35:     // TODO Decode the HEX of the sig (signature) - it is a SignatureType, so cast it to a string.
 36:     // TODO use crypto.SigToPub to the the publick key back.  This will require the hash of the message (signHash) and the signature
 37:     //        Call this the `recovedPubkey`
 38:     // TODO See Below: Coompare the `recoverdPubkey` to the addr (the from account when sending funds)   The data type is different but both should
 39:     //        have the same data in bytes.
 40:     rawRecoveredAddress := crypto.PubkeyToAddress(*recoveredPubkey)
 41:     if fmt.Sprintf("%s", from) != fmt.Sprintf("0x%x", rawRecoveredAddress) {
 42:         // fmt.Printf("%sAT: %s Address >%s<- did not match recovered address >%x< %s\n", MiscLib.ColorRed, godebug.LF(), from, rawRecoveredAddress, MiscLib.ColorReset)
 43:         return false
 44:     }
 45: 
 46:     // Return true if you get to this point.
 47:     return true
 48: }
 49: 
 50: */
 51: 
 52: // signHash is a helper function that calculates a hash for the given message
 53: // that can be safely used to calculate a signature from.
 54: //
 55: // The hash is calulcated as
 56: //   keccak256("\x19Ethereum Signed Message:\n"${message length}${message}).
 57: //
 58: // This gives context to the signed message and prevents signing of transactions.
 59: func signHash(data []byte) []byte {
 60:     msg := fmt.Sprintf("\x19Ethereum Signed Message:\n%d%s", len(data), data)
 61:     return crypto.Keccak256([]byte(msg))
 62: }
