  1: package lib
  2: 
  3: import (
  4:     "encoding/hex"
  5:     "fmt"
  6: 
  7:     "github.com/Univ-Wyo-Education/S22-4010/homework/03/bsvr/addr"
  8:     "github.com/ethereum/go-ethereum/crypto"
  9:     "github.com/pschlump/MiscLib"
 10:     "github.com/pschlump/godebug"
 11: )
 12: 
 13: // if !lib.ValidSignature(lib.SignatureType(signature), msg, addr) { // Assignment 5 implements, just true for now.
 14: func ValidSignature(sig SignatureType, msg string, from addr.AddressType) bool {
 15: 
 16:     fmt.Printf("%s!!!!!!!!!!!!!!!!!!!!!!!!!!%s AT: %s\n", MiscLib.ColorCyan, MiscLib.ColorReset, godebug.LF())
 17: 
 18:     // TODO - xyzyz - we will validate signatures in the "Wallet" homework.  AS-05.
 19:     // return true
 20:     // }
 21:     // VerifySignature takes hex encoded addr, sig and msg and verifies that the signature matches with the address.
 22:     // Pulled form go-ethereum code.
 23:     // func VerifySignature2(addr, sig, msg string) (recoveredAddress, recoveredPublicKey string, err error) {
 24:     message, err := hex.DecodeString(msg)
 25:     if err != nil {
 26:         // return "", "", fmt.Errorf("unabgle to decode message (invalid hex data) Error:%s", err)
 27:         return false
 28:     }
 29:     fmt.Printf("AT: %s\n", godebug.LF())
 30:     //    if !common.IsHexAddress(addr) {
 31:     //        return "", "", fmt.Errorf("invalid address: %s", addr)
 32:     //    }
 33:     // fmt.Printf("AT: %s\n", godebug.LF())
 34:     // address := common.HexToAddress(addr)
 35:     // address := common.HexToAddress(fmt.Sprintf("%x", from))
 36:     signature, err := hex.DecodeString(string(sig))
 37:     if err != nil {
 38:         // return "", "", fmt.Errorf("signature is not valid hex Error:%s", err)
 39:         return false
 40:     }
 41:     fmt.Printf("AT: %s\n", godebug.LF())
 42: 
 43:     recoveredPubkey, err := crypto.SigToPub(signHash(message), signature)
 44:     if err != nil || recoveredPubkey == nil {
 45:         // return "", "", fmt.Errorf("signature verification failed Error:%s", err)
 46:         return false
 47:     }
 48:     fmt.Printf("AT: %s\n", godebug.LF())
 49:     recoveredPublicKey := hex.EncodeToString(crypto.FromECDSAPub(recoveredPubkey))
 50:     rawRecoveredAddress := crypto.PubkeyToAddress(*recoveredPubkey)
 51:     // if address != rawRecoveredAddress {
 52:     if fmt.Sprintf("%s", from) != fmt.Sprintf("0x%x", rawRecoveredAddress) {
 53:         fmt.Printf("%sAT: %s Address >%s<- did not match recovered address >%x< %s\n", MiscLib.ColorRed, godebug.LF(), from, rawRecoveredAddress, MiscLib.ColorReset)
 54:         // return "", "", fmt.Errorf("signature did not verify, addresses did not match")
 55:         return false
 56:     }
 57:     fmt.Printf("AT: %s\n", godebug.LF())
 58:     recoveredAddress := rawRecoveredAddress.Hex()
 59:     _ = recoveredAddress
 60:     _ = recoveredPublicKey
 61:     // return
 62:     return true
 63: }
 64: 
 65: // signHash is a helper function that calculates a hash for the given message
 66: // that can be safely used to calculate a signature from.
 67: //
 68: // The hash is calulcated as
 69: //   keccak256("\x19Ethereum Signed Message:\n"${message length}${message}).
 70: //
 71: // This gives context to the signed message and prevents signing of transactions.
 72: //func signHash(data []byte) []byte {
 73: //    msg := fmt.Sprintf("\x19Ethereum Signed Message:\n%d%s", len(data), data)
 74: //    return crypto.Keccak256([]byte(msg))
 75: //}
