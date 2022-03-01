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
 20:     "crypto/ecdsa"
 21:     "fmt"
 22:     "io/ioutil"
 23:     "os"
 24:     "path/filepath"
 25:     "time"
 26: 
 27:     "github.com/ethereum/go-ethereum/accounts/keystore" //
 28:     "github.com/ethereum/go-ethereum/crypto"            //
 29:     pbUUID "github.com/pborman/uuid"                    // "github.com/pborman/uuid"
 30:     "github.com/urfave/cli/v2"
 31: )
 32: 
 33: /*
 34:     "www.2c-why.com/Corp-Reg/MidGeth/Signature/crypto"   // "github.com/ethereum/go-ethereum/crypto"            //
 35:     "www.2c-why.com/Corp-Reg/MidGeth/Signature/keystore" // "github.com/ethereum/go-ethereum/accounts/keystore" //
 36: */
 37: 
 38: type outputGenerate struct {
 39:     Address      string
 40:     AddressEIP55 string
 41: }
 42: 
 43: var commandGenerate = cli.Command{
 44:     Name: "generate",
 45:     Usage: `generate new keyfile
 46:                     ./sig-test generate --default-name --random-pass
 47:             or
 48:                     ./sig-test generate --privatekey File --default-name
 49: `,
 50:     ArgsUsage: "[ <keyfile> ]",
 51:     Description: `
 52: Generate a new keyfile.
 53: 
 54: If you want to encrypt an existing private key, it can be specified by setting
 55: --privatekey with the location of the file containing the private key.
 56: `,
 57:     Flags: []cli.Flag{
 58:         &passphraseFlag,
 59:         &jsonFlag,
 60:         &cli.StringFlag{
 61:             Name:  "privatekey",
 62:             Usage: "file containing a raw private key to encrypt",
 63:         },
 64:         &cli.StringFlag{
 65:             Name:  "address",
 66:             Usage: "account address",
 67:         },
 68:         &defaultNameFlag,
 69:         &randomPassFlag,
 70:         &logFileFlag,
 71:     },
 72:     Action: ActionGenerate,
 73: }
 74: 
 75: // ActionGenerate will generate a new key file.
 76: func ActionGenerate(ctx *cli.Context) error {
 77:     // Check if keyfile path given and make sure it doesn't already exist.
 78:     keyfilepath := ctx.Args().First()
 79: 
 80:     // fmt.Printf("PJS: batch=%d\n", batch) // batch is 0 if not set.
 81:     // if batch > 0 and --passphrase <file> then read 1 line for each password
 82:     // if batch > 0 and --random-pass then generate random passwrods and print them out.
 83: 
 84:     var privateKey *ecdsa.PrivateKey
 85:     var err error
 86: 
 87:     debugFlags := ctx.String(debugFlag.Name)
 88:     SetDebugFlags(debugFlags)
 89: 
 90:     privateKeyFileName := ctx.String("privatekey")
 91: 
 92:     // ----------------------------------------------------------------------------------------------------------
 93: 
 94:     if file := privateKeyFileName; file != "" {
 95:         // Load private key from file.
 96:         privateKey, err = crypto.LoadECDSA(file)
 97:         if err != nil {
 98:             Fatalf(2, "Can't load private key: %v", err)
 99:         }
100:     } else {
101:         // If not loaded, generate random.
102:         privateKey, err = crypto.GenerateKey()
103:         if err != nil {
104:             Fatalf(2, "Failed to generate random private key: %v", err)
105:         }
106:     }
107: 
108:     // Create the keyfile object with a random UUID.
109:     // id := uuid.NewRandom()
110:     xid := pbUUID.NewRandom() // func NewUUID() UUID {
111: 
112:     // Some amazingly weird stuff - to work around the Ethereum folks using
113:     // Go Vendoring wrong.
114:     buf := fmt.Sprintf(`{
115:         "address":"6d5a68a5b8060d52981cb4ca3e6797b3b48dda0d",
116:         "privatekey":"ed80bf3d4bf2dbf5f37601541f376607709f76b10ecb69cdd3768250329867d1",
117:         "id":%q,
118:         "version":3
119:     }`, xid)
120:     if DbMap["dump-JSON-buffer"] {
121:         fmt.Printf("buf ->%s<-\n", buf)
122:     }
123:     var k keystore.Key
124:     err = k.UnmarshalJSON([]byte(buf))
125:     id := k.Id
126:     // End Weird Sutff. - have an ID to use.
127: 
128:     key := &keystore.Key{
129:         Id:         id,
130:         Address:    crypto.PubkeyToAddress(privateKey.PublicKey),
131:         PrivateKey: privateKey,
132:     }
133: 
134:     // Encrypt key with passphrase.
135:     // passphrase := promptPassphrase(true, false)
136:     passphrase := getPassphrase(ctx, false)
137:     keyjson, err := keystore.EncryptKey(key, passphrase, keystore.StandardScryptN, keystore.StandardScryptP)
138:     if err != nil {
139:         Fatalf(2, "Error encrypting key: %v", err)
140:     }
141: 
142:     if DbMap["db03"] {
143:         fmt.Printf("PJS: Key file will be stored in: %s\n", filepath.Dir(keyfilepath))
144:     }
145: 
146:     address := key.Address.Hex()
147: 
148:     newKeyFileDir := filepath.Dir(keyfilepath)
149:     newname := filepath.Base(keyfilepath)
150:     defaultName := ctx.Bool(defaultNameFlag.Name)
151:     if defaultName && newname != "." {
152:         Fatalf(2, "Can not supply both a --default-name flag and a name for the file. defaultName=true newname=[%s]\n", newname)
153:     } else if defaultName {
154:         newname = fmt.Sprintf("UTC--%s--%s", time.Now().UTC().Format("2006-01-02T15-04-05.9999999999Z"), address[2:])
155:     }
156: 
157:     // Store the file to disk.
158:     if err := os.MkdirAll(newKeyFileDir, 0700); err != nil {
159:         Fatalf(2, "Could not create directory %s", newKeyFileDir)
160:     }
161: 
162:     path := filepath.Join(newKeyFileDir, newname)
163: 
164:     // check if file already exists - if so then cowerdly refuse to ovewrite it.
165:     if Exists(path) {
166:         Fatalf(2, "File [%s] already exists - will not overwrite\n", path)
167:     }
168: 
169:     // Output the file.
170:     if err := ioutil.WriteFile(path, keyjson, 0600); err != nil {
171:         Fatalf(2, "Failed to write keyfile to %s: %v", path, err)
172:     }
173: 
174:     // Output some information.
175:     out := outputGenerate{
176:         Address: address,
177:     }
178:     if ctx.Bool(jsonFlag.Name) {
179:         mustPrintJSON(out)
180:     } else {
181:         genRandom := ctx.Bool(randomPassFlag.Name)
182:         if genRandom {
183:             fmt.Printf("Password: %s\n", passphrase)
184:         }
185:         fmt.Println("Address:", out.Address)
186:         fmt.Println("File Name:", path)
187:         lf := ctx.String(logFileFlag.Name)
188:         if lf != "" {
189:             AppendToLog(lf, fmt.Sprintf("Password: %s\nAddress: %s\nFile Name:%s\n\n", passphrase, out.Address, path))
190:         }
191:     }
192:     return nil
193: }
