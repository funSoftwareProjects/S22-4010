  1: package main
  2: 
  3: // Copyright 2017 The go-ethereum Authors
  4: // This file is part of go-ethereum.
  5: //
  6: // go-ethereum is free software: you can redistribute it and/or modify
  7: // it under the terms of the GNU General Public License as published by
  8: // the Free Software Foundation, either version 3 of the License, or
  9: // (at your option) any later version.
 10: //
 11: // go-ethereum is distributed in the hope that it will be useful,
 12: // but WITHOUT ANY WARRANTY; without even the implied warranty of
 13: // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 14: // GNU General Public License for more details.
 15: //
 16: // You should have received a copy of the GNU General Public License
 17: // along with go-ethereum. If not, see <http://www.gnu.org/licenses/>.
 18: 
 19: import (
 20:     "encoding/hex"
 21:     "fmt"
 22: 
 23:     "github.com/ethereum/go-ethereum/common"
 24:     "github.com/ethereum/go-ethereum/crypto"
 25:     "github.com/urfave/cli/v2"
 26: )
 27: 
 28: var commandVerifyMessage = cli.Command{
 29:     Name: "verify-message",
 30:     Usage: `verify the signature of a signed message
 31:                 ./sig-test very-message Address Signature "message" "original-message"
 32:                     or
 33:                 ./sig-test very-message --json Address Signature "message" "original-message"
 34: `,
 35:     ArgsUsage: "<address> <signature> <hash-message> <original-message>",
 36:     Description: `
 37: Verify the signature of the message.
 38: It is possible to refer to a file containing the message.`,
 39:     Flags: []cli.Flag{
 40:         &jsonFlag,
 41:         &msgfileFlag,
 42:         &debugFlag,
 43:     },
 44:     Action: ActionVerifyMessage,
 45: }
 46: 
 47: // ActinVerifyMessage takes an address, signature and the original messsage on the command line and verifies the
 48: // signature for that message.
 49: func ActionVerifyMessage(ctx *cli.Context) error {
 50:     addressStr := ctx.Args().First()
 51:     signatureHex := ctx.Args().Get(1)
 52:     message := getMessage(ctx, 2, 3)
 53:     origMessage := ctx.Args().Get(3)
 54: 
 55:     fmt.Printf("->%s<- original message\n", origMessage)
 56:     mChk := hex.EncodeToString([]byte(origMessage))
 57:     // mChk := fmt.Sprintf("%x", origMessage)
 58:     if mChk != fmt.Sprintf("%s", message) {
 59:         fmt.Printf("Warning: Message did not match its '''hash'''\n")
 60:         // return fmt.Errorf("signature did not verify - invalid message")
 61:     }
 62: 
 63:     debugFlags := ctx.String(debugFlag.Name)
 64:     SetDebugFlags(debugFlags)
 65: 
 66:     // message is hex, need to convert back to byte, line 61 dose this.
 67: 
 68:     rAddr, rPubKey, err := VerifySignature(addressStr, signatureHex, string(message))
 69:     if err != nil {
 70:         // fmt.Printf("Signature verification failed!\n")
 71:         return fmt.Errorf("signature did not verify")
 72:     }
 73:     fmt.Printf("Signature verified\n")
 74:     fmt.Printf("Recovered public key: %s\n", rPubKey)
 75:     // See: https://github.com/ethereum/EIPs/blob/master/EIPS/eip-55.md
 76:     fmt.Printf("Recovered address (in EIP-55 format): %s\n", rAddr)
 77: 
 78:     return nil
 79: }
 80: 
 81: // VerifySignature takes hex encoded addr, sig and msg and verifies that the signature matches with the address.
 82: func VerifySignature(addr, sig, msg string) (recoveredAddress, recoveredPublicKey string, err error) {
 83:     message, err := hex.DecodeString(msg)
 84:     if err != nil {
 85:         return "", "", fmt.Errorf("unabgle to decode message (invalid hex data) Error:%s", err)
 86:     }
 87:     if !common.IsHexAddress(addr) {
 88:         return "", "", fmt.Errorf("invalid address: %s", addr)
 89:     }
 90:     address := common.HexToAddress(addr)
 91:     signature, err := hex.DecodeString(sig)
 92:     if err != nil {
 93:         return "", "", fmt.Errorf("signature is not valid hex Error:%s", err)
 94:     }
 95: 
 96:     recoveredPubkey, err := crypto.SigToPub(signHash(message), signature)
 97:     if err != nil || recoveredPubkey == nil {
 98:         return "", "", fmt.Errorf("signature verification failed Error:%s", err)
 99:     }
100:     recoveredPublicKey = hex.EncodeToString(crypto.FromECDSAPub(recoveredPubkey))
101:     rawRecoveredAddress := crypto.PubkeyToAddress(*recoveredPubkey)
102:     if address != rawRecoveredAddress {
103:         return "", "", fmt.Errorf("signature did not verify, addresses did not match")
104:     }
105:     recoveredAddress = rawRecoveredAddress.Hex()
106:     return
107: }
