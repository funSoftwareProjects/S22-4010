package lib

import (
	"fmt"

	"github.com/ethereum/go-ethereum/crypto"
)

/*

// TODO - implement the function ValidSintaure





// The imports that I used for this:

import (
	"encoding/hex"
	"fmt"

	"github.com/Univ-Wyo-Education/S22-4010/homework/03/bsvr/addr"
	"github.com/ethereum/go-ethereum/crypto"
	"github.com/pschlump/MiscLib"
	"github.com/pschlump/godebug"
)

// if !lib.ValidSignature(lib.SignatureType(signature), msg, addr) { // Assignment 5 implements, just true for now.
func ValidSignature(sig SignatureType, msg string, from addr.AddressType) bool {
	// VerifySignature takes hex encoded addr, sig and msg and verifies that the signature matches with the address.
	// Pulled form go-ethereum code.

	// TODO Decode the HEX of the msg to get back the original message.
	// TODO Decode the HEX of the sig (signature) - it is a SignatureType, so cast it to a string.
	// TODO use crypto.SigToPub to the the publick key back.  This will require the hash of the message (signHash) and the signature
	//		Call this the `recovedPubkey`
	// TODO See Below: Coompare the `recoverdPubkey` to the addr (the from account when sending funds)   The data type is different but both should
	//		have the same data in bytes.
	rawRecoveredAddress := crypto.PubkeyToAddress(*recoveredPubkey)
	if fmt.Sprintf("%s", from) != fmt.Sprintf("0x%x", rawRecoveredAddress) {
		// fmt.Printf("%sAT: %s Address >%s<- did not match recovered address >%x< %s\n", MiscLib.ColorRed, godebug.LF(), from, rawRecoveredAddress, MiscLib.ColorReset)
		return false
	}

	// Return true if you get to this point.
	return true
}

*/

// signHash is a helper function that calculates a hash for the given message
// that can be safely used to calculate a signature from.
//
// The hash is calulcated as
//   keccak256("\x19Ethereum Signed Message:\n"${message length}${message}).
//
// This gives context to the signed message and prevents signing of transactions.
func signHash(data []byte) []byte {
	msg := fmt.Sprintf("\x19Ethereum Signed Message:\n%d%s", len(data), data)
	return crypto.Keccak256([]byte(msg))
}
