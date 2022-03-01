  1: // Copyright 2017 The go-ethereum Authors
  2: // This file is part of go-ethereum.
  3: //
  4: // go-ethereum is free software: you can redistribute it and/or modify
  5: // it under the terms of the GNU General Public License as published by
  6: // the Free Software Foundation, either version 3 of the License, or
  7: // (at your option) any later version.
  8: //
  9: // go-ethereum is distributed in the hope that it will be useful,
 10: // but WITHOUT ANY WARRANTY; without even the implied warranty of
 11: // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 12: // GNU General Public License for more details.
 13: //
 14: // You should have received a copy of the GNU General Public License
 15: // along with go-ethereum. If not, see <http://www.gnu.org/licenses/>.
 16: 
 17: package main
 18: 
 19: import (
 20:     "encoding/hex"
 21:     "fmt"
 22:     "io/ioutil"
 23: 
 24:     "github.com/ethereum/go-ethereum/accounts/keystore" //
 25:     "github.com/ethereum/go-ethereum/crypto"            //
 26:     "github.com/urfave/cli/v2"
 27: )
 28: 
 29: /*
 30:     "www.2c-why.com/Corp-Reg/MidGeth/Signature/crypto"   // "github.com/ethereum/go-ethereum/crypto"            //
 31:     "www.2c-why.com/Corp-Reg/MidGeth/Signature/keystore" // "github.com/ethereum/go-ethereum/accounts/keystore" //
 32: */
 33: 
 34: var commandSignMessage = cli.Command{
 35:     Name: "sign-message",
 36:     Usage: `sign a message
 37:                         ./sig-test sign-message <KeyFile.json> "the message to sign"
 38:                             or
 39:                         ./sig-test sign-message --gen-msg <KeyFile.json> 
 40:                             or
 41:                         ./sig-test sign-message --msgfile <MessageInAFile> <KeyFile.json> 
 42:                             or
 43:                         ./sig-test sign-message --gen-msg <KeyFile.json> 
 44: `,
 45:     ArgsUsage: "<keyfile> <message>",
 46:     Description: `
 47: Sign the message with a keyfile.
 48: 
 49: To sign a message contained in a file, use the --msgfile flag.
 50: `,
 51:     Flags: []cli.Flag{
 52:         &passphraseFlag,
 53:         &jsonFlag,
 54:         &msgfileFlag,
 55:         &debugFlag,
 56:         &genMsgFlag,
 57:     },
 58:     Action: ActionSignMessage,
 59: }
 60: 
 61: // ActionSignMessage implement the command line operation "sign-message".
 62: func ActionSignMessage(ctx *cli.Context) error {
 63:     var message []byte
 64:     var signature string
 65:     var err error
 66: 
 67:     genMsg := ctx.Bool(genMsgFlag.Name)
 68:     if !genMsg {
 69:         message = getMessage(ctx, 1, 2)
 70:     }
 71: 
 72:     debugFlags := ctx.String(debugFlag.Name)
 73:     SetDebugFlags(debugFlags)
 74: 
 75:     keyFile := ctx.Args().First()
 76:     password := getPassphrase(ctx, false)
 77:     messageStr, signature, err := GenerateSignature(keyFile, password, message)
 78:     if err != nil {
 79:         Fatalf(2, "Failed to sign message: %v", err)
 80:     }
 81: 
 82:     if ctx.Bool("json") {
 83:         fmt.Printf("{\"Signature\":%q,\"Message\":%q}", signature, messageStr)
 84:     } else {
 85:         fmt.Printf("MessageLengthInBytes: %d\n", len(messageStr))
 86:         fmt.Printf("Message: %s\n", message)
 87:         fmt.Printf("Hash of Message: %s\n", messageStr)
 88:         fmt.Printf("Signature: %s\n", signature)
 89:     }
 90: 
 91:     return nil
 92: }
 93: 
 94: // GenerateSignature uses a keyfile and password to sign a message.  If the input message is "" then a random message
 95: // will be generated.  The messgae and the signature are returned.
 96: func GenerateSignature(keyFile, password string, inMessage []byte) (message, signature string, err error) {
 97:     data, err := ioutil.ReadFile(keyFile)
 98:     if err != nil {
 99:         return "", "", fmt.Errorf("unable to read keyfile %s Error:%s", keyFile, err)
100:     }
101:     key, err := keystore.DecryptKey(data, password)
102:     if err != nil {
103:         return "", "", fmt.Errorf("unable to decrypt %s Error:%s", keyFile, err)
104:     }
105:     if len(inMessage) == 0 {
106:         inMessage, err = GenRandBytes(20)
107:         if err != nil {
108:             return "", "", fmt.Errorf("unable to generate random message Error:%s", err)
109:         }
110:     }
111:     message = hex.EncodeToString(inMessage)
112:     rawSignature, err := crypto.Sign(signHash(inMessage), key.PrivateKey) // Sign Raw Bytes, Return hex of Raw Bytes
113:     if err != nil {
114:         return "", "", fmt.Errorf("unable to sign message Error:%s", err)
115:     }
116:     signature = hex.EncodeToString(rawSignature)
117:     return message, signature, nil
118: }
