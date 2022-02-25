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
 34: type outputInspect struct {
 35:     Address    string
 36:     PublicKey  string
 37:     PrivateKey string
 38: }
 39: 
 40: var commandInspect = cli.Command{
 41:     Name: "inspect",
 42:     Usage: `inspect a keyfile
 43:                  sig-test inspect --priave <KeyFile.json> 
 44:                  Print out the Address, Public Key, Private Key for a keyfile.
 45: `,
 46:     ArgsUsage: "<KeyFile.json>",
 47:     Description: `
 48: Print the address and the publick key from the keyfile.   Optionally print the private key.
 49: 
 50: Private key information can be printed by using the --private flag;
 51: Use this feature with great caution!  It is your **private** unencrypted key.
 52: 
 53: Status 
 54:     0 (sucdess) if a valid password is provided
 55:     1 if an invalid password is provide
 56:     2 if some other error occures (missing file etc.)
 57: `,
 58:     Flags: []cli.Flag{
 59:         &passphraseFlag,
 60:         &jsonFlag,
 61:         &cli.BoolFlag{
 62:             Name:  "private",
 63:             Usage: "include the private key in the output",
 64:         },
 65:         &debugFlag, // from common-flags.go
 66:     },
 67:     Action: ActionInspect,
 68: }
 69: 
 70: func ActionInspect(ctx *cli.Context) error {
 71:     keyfilepath := ctx.Args().First()
 72: 
 73:     debugFlags := ctx.String(debugFlag.Name)
 74:     SetDebugFlags(debugFlags)
 75: 
 76:     // Read key from file.
 77:     keyjson, err := ioutil.ReadFile(keyfilepath)
 78:     if err != nil {
 79:         Fatalf(2, "Failed to read the keyfile at '%s': %v", keyfilepath, err)
 80:     }
 81: 
 82:     // Decrypt key with passphrase.
 83:     passphrase := getPassphrase(ctx, true)
 84:     key, err := keystore.DecryptKey(keyjson, passphrase)
 85:     if err != nil {
 86:         Fatalf(1, "Error decrypting key: %v", err)
 87:     }
 88: 
 89:     // Output all relevant information we can retrieve.
 90:     showPrivate := ctx.Bool("private")
 91:     out := outputInspect{
 92:         Address:   key.Address.Hex(),
 93:         PublicKey: hex.EncodeToString(crypto.FromECDSAPub(&key.PrivateKey.PublicKey)),
 94:     }
 95:     if showPrivate {
 96:         out.PrivateKey = hex.EncodeToString(crypto.FromECDSA(key.PrivateKey))
 97:     }
 98: 
 99:     if ctx.Bool(jsonFlag.Name) {
100:         mustPrintJSON(out)
101:     } else {
102:         fmt.Println("Address:       ", out.Address)
103:         fmt.Println("Public key:    ", out.PublicKey)
104:         if showPrivate {
105:             fmt.Println("Private key:   ", out.PrivateKey)
106:         }
107:     }
108:     return nil
109: }
