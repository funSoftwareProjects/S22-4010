  1: package lib
  2: 
  3: import (
  4:     "encoding/hex"
  5:     "fmt"
  6: 
  7:     "github.com/Univ-Wyo-Education/S22-4010/homework/04/bsvr/addr"
  8:     "github.com/ethereum/go-ethereum/crypto"
  9:     "github.com/pschlump/MiscLib"
 10:     "github.com/pschlump/godebug"
 11: )
 12: 
 13: // if !lib.ValidSignature(lib.SignatureType(signature), msg, addr) { // Assignment 5 implements, just true for now.
 14: func ValidSignature(sig SignatureType, msg string, from addr.AddressType) bool {
 15: 
 16:     fmt.Printf("%s!!!!!!!!!!!!!!!!!!!!!!!!!!%s Top of /Users/philip/go/src/github.com/Univ-Wyo-Education/S22-4010/homework/04/bsvr/main\n\tsig=->%s<- msg->%s<- addr=->%s<- AT: %s\n", MiscLib.ColorCyan, MiscLib.ColorReset, sig, msg, from, godebug.LF())
 17: 
 18:     // fake Return True
 19:     fmt.Printf("%sWill just return a fake 'true' for testing/demo: at:%s\n%s", MiscLib.ColorGreen, godebug.LF(), MiscLib.ColorReset)
 20:     return true
 21: 
 22:     // TODO - xyzyz - we will validate signatures in the "Wallet" homework.  AS-05.
 23:     // return true
 24:     // }
 25:     // VerifySignature takes hex encoded addr, sig and msg and verifies that the signature matches with the address.
 26:     // Pulled form go-ethereum code.
 27:     // func VerifySignature2(addr, sig, msg string) (recoveredAddress, recoveredPublicKey string, err error) {
 28:     message, err := hex.DecodeString(msg)
 29:     if err != nil {
 30:         // return "", "", fmt.Errorf("unabgle to decode message (invalid hex data) Error:%s", err)
 31:         fmt.Printf("AT: %s\n", godebug.LF())
 32:         return false
 33:     }
 34:     fmt.Printf("AT: %s\n", godebug.LF())
 35:     //    if !common.IsHexAddress(addr) {
 36:     //        return "", "", fmt.Errorf("invalid address: %s", addr)
 37:     //    }
 38:     // fmt.Printf("AT: %s\n", godebug.LF())
 39:     // address := common.HexToAddress(addr)
 40:     // address := common.HexToAddress(fmt.Sprintf("%x", from))
 41:     signature, err := hex.DecodeString(string(sig))
 42:     if err != nil {
 43:         // return "", "", fmt.Errorf("signature is not valid hex Error:%s", err)
 44:         fmt.Printf("AT: %s\n", godebug.LF())
 45:         return false
 46:     }
 47:     fmt.Printf("AT: %s\n", godebug.LF())
 48: 
 49:     recoveredPubkey, err := crypto.SigToPub(signHash(message), signature)
 50:     if err != nil || recoveredPubkey == nil {
 51:         // return "", "", fmt.Errorf("signature verification failed Error:%s", err)
 52:         fmt.Printf("AT: %s\n", godebug.LF())
 53:         return false
 54:     }
 55:     fmt.Printf("AT: %s\n", godebug.LF())
 56:     recoveredPublicKey := hex.EncodeToString(crypto.FromECDSAPub(recoveredPubkey))
 57:     rawRecoveredAddress := crypto.PubkeyToAddress(*recoveredPubkey)
 58:     // if address != rawRecoveredAddress {
 59:     if fmt.Sprintf("%s", from) != fmt.Sprintf("0x%x", rawRecoveredAddress) {
 60:         fmt.Printf("%sAT: %s Address >%s<- did not match recovered address >%x< %s\n", MiscLib.ColorRed, godebug.LF(), from, rawRecoveredAddress, MiscLib.ColorReset)
 61:         // return "", "", fmt.Errorf("signature did not verify, addresses did not match")
 62:         return false
 63:     }
 64:     fmt.Printf("AT: %s\n", godebug.LF())
 65:     recoveredAddress := rawRecoveredAddress.Hex()
 66:     _ = recoveredAddress
 67:     _ = recoveredPublicKey
 68:     // return
 69:     return true
 70: }
 71: 
 72: // signHash is a helper function that calculates a hash for the given message
 73: // that can be safely used to calculate a signature from.
 74: //
 75: // The hash is calulcated as
 76: //   keccak256("\x19Ethereum Signed Message:\n"${message length}${message}).
 77: //
 78: // This gives context to the signed message and prevents signing of transactions.
 79: //func signHash(data []byte) []byte {
 80: //    msg := fmt.Sprintf("\x19Ethereum Signed Message:\n%d%s", len(data), data)
 81: //    return crypto.Keccak256([]byte(msg))
 82: //}
