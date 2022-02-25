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
 20:     "fmt"
 21:     "io/ioutil"
 22:     "strings"
 23:     "time"
 24: 
 25:     "github.com/ethereum/go-ethereum/accounts/keystore"
 26:     "github.com/urfave/cli/v2"
 27: )
 28: 
 29: var commandChangePassphrase = cli.Command{
 30:     Name:    "change-passphrase",
 31:     Aliases: []string{"change-password"},
 32:     Usage: `change the passphrase on a keyfile
 33:                  sig-test changepassphrase --newname <newKeyFileName.json> <ExistingKeyFile.json> 
 34:                  if <newKeyFileName.json> is "-" then the existing file will be overwritten with the new one.
 35:                  You will be prompted for the passwords - unles you supply the --password and --newPassword flags.
 36:                  sig-test changepassphrase --newname <NewFileName.json> --password <FileWithOldPassword> --newPassword <fileWithNewPw> <ExistingKeyFile.json>
 37: `,
 38:     ArgsUsage: "<keyfile>",
 39:     Description: `
 40: Change the passphrase/password of a keyfile.  
 41: `,
 42:     Flags: []cli.Flag{
 43:         &passphraseFlag,    // --passwordfile <filename> - from common-flags.go
 44:         &newPassphraseFlag, // --newpasswordfile <filename> - from common-flags.go
 45:         &newNameFlag,
 46:         &defaultNameFlag,
 47:         &debugFlag, // --debug Flag1,Flag2,... - from common-flags.go
 48:     },
 49:     Action: ActionChangeKeyfilePassword,
 50: }
 51: 
 52: var commandChangePassword = cli.Command{
 53:     Name: "change-password",
 54:     Usage: `change the passphrase on a keyfile
 55:                  sig-test change-password --newname <newKeyFileName.json> <ExistingKeyFile.json> 
 56:                  if <newKeyFileName.json> is "-" then the existing file will be overwritten with the new one.
 57:                  You will be prompted for the passwords - unles you supply the --password and --newPassword flags.
 58:                  sig-test change-password --newname <NewFileName.json> --password <FileWithOldPassword> --newPassword <fileWithNewPw> <ExistingKeyFile.json>
 59: `,
 60:     ArgsUsage: "<keyfile>",
 61:     Description: `
 62: Change the passphrase/password of a keyfile.  
 63: `,
 64:     Flags: []cli.Flag{
 65:         &passphraseFlag,    // --passwordfile <filename> - from common-flags.go
 66:         &newPassphraseFlag, // --newpasswordfile <filename> - from common-flags.go
 67:         &debugFlag,         // --debug Flag1,Flag2,... - from common-flags.go
 68:     },
 69:     Action: ActionChangeKeyfilePassword,
 70: }
 71: 
 72: // ActionChangeKeyfilePassword processes the changepassphrase and changepassword commands on the command line.
 73: func ActionChangeKeyfilePassword(ctx *cli.Context) error {
 74:     keyfilepath := ctx.Args().First()
 75: 
 76:     debugFlags := ctx.String(debugFlag.Name)
 77:     SetDebugFlags(debugFlags)
 78: 
 79:     if !Exists(keyfilepath) {
 80:         Fatalf(2, "input key file missing: %s\n", keyfilepath)
 81:     }
 82: 
 83:     // Read key from file.
 84:     keyjson, err := ioutil.ReadFile(keyfilepath)
 85:     if err != nil {
 86:         Fatalf(2, "Failed to read the keyfile at '%s': %v", keyfilepath, err)
 87:     }
 88: 
 89:     // Decrypt key with passphrase.
 90:     passphrase := getPassphrase(ctx, true)
 91:     key, err := keystore.DecryptKey(keyjson, passphrase)
 92:     if err != nil {
 93:         Fatalf(1, "Error decrypting key: %v", err)
 94:     }
 95: 
 96:     // dump the keyfile to stdout - non-encrypted.
 97:     if DbMap["db01"] {
 98:         fmt.Printf("Dump of keyfile - unencrypted: %s\n", FormatAsJSON(key))
 99:     }
100: 
101:     address := key.Address.Hex()
102: 
103:     newKeyFileName := keyfilepath
104:     newname := ctx.String(newNameFlag.Name)
105:     defaultName := ctx.Bool(defaultNameFlag.Name)
106:     if defaultName && newname != "" {
107:         Fatalf(2, "Can only supply one of --newname FN and --defaultName\n")
108:     } else if defaultName {
109:         newname = fmt.Sprintf("UTC--%s--%s\n", time.Now().UTC().Format("2006-01-02T15:04:05.999999999Z"), address)
110:     } else if newname == "" {
111:         Fatalf(2, "Must supply a new name for the key file or --defaultName option must be set\n")
112:     } else if newname == "-" { // Then overwrite, default set above.
113:     } else {
114:         newKeyFileName = newname
115:         if Exists(newKeyFileName) {
116:             Fatalf(2, "Will not overwrite an existing keyfile - remove existing keyfile first: %s\n", newKeyFileName)
117:         }
118:     }
119: 
120:     // Get the new password
121:     var newPhrase string
122:     if passFile := ctx.String(newPassphraseFlag.Name); passFile != "" {
123:         content, err := ioutil.ReadFile(passFile)
124:         if err != nil {
125:             Fatalf(3, "Failed to read new passphrase file '%s': %v", passFile, err)
126:         }
127:         newPhrase = string(content)
128:         // FIXME - TODO - should check that the password passes muster with remote site at this point
129:     } else {
130:         fmt.Printf("Input a new passphrase (leading and trailing blanks are ignored)\n")
131:         newPhrase = promptPassphrase(true, true)
132:     }
133:     newPhrase = strings.TrimRight(newPhrase, " \r\n\f\t")
134:     newPhrase = strings.TrimLeft(newPhrase, " \r\n\f\t")
135: 
136:     // Encrypt the key with the new passphrase.
137:     newJson, err := keystore.EncryptKey(key, newPhrase, keystore.StandardScryptN, keystore.StandardScryptP)
138:     if err != nil {
139:         Fatalf(2, "Error encrypting with new passphrase: %v", err)
140:     }
141: 
142:     // Then write the new keyfile in place of the old one.
143:     if err := ioutil.WriteFile(newKeyFileName, newJson, 600); err != nil {
144:         Fatalf(2, "Error writing new keyfile to disk: %v", err)
145:     }
146: 
147:     // Don't print anything.  Just return successfully, producing a positive exit code.
148:     return nil
149: }
