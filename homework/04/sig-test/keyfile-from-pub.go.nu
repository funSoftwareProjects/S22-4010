  1: package main
  2: 
  3: // Copyright (C) Philip Schlump, 2018.
  4: 
  5: import (
  6:     "crypto/ecdsa"
  7:     "fmt"
  8:     "io/ioutil"
  9:     "os"
 10:     "path/filepath"
 11:     "time"
 12: 
 13:     "github.com/ethereum/go-ethereum/accounts/keystore" //
 14:     "github.com/ethereum/go-ethereum/crypto"            //
 15:     pbUUID "github.com/pborman/uuid"                    // "github.com/pborman/uuid"
 16:     "github.com/urfave/cli/v2"
 17: )
 18: 
 19: /*
 20:     "www.2c-why.com/Corp-Reg/MidGeth/Signature/crypto"   // "github.com/ethereum/go-ethereum/crypto"            //
 21:     "www.2c-why.com/Corp-Reg/MidGeth/Signature/keystore" // "github.com/ethereum/go-ethereum/accounts/keystore" //
 22: */
 23: /*
 24: type outputGenerate struct {
 25:     Address      string
 26:     AddressEIP55 string
 27: }
 28: */
 29: 
 30: var commandKeyfileFromPub = cli.Command{
 31:     Name: "keyfile-from-pub",
 32:     Usage: `keyfile-from-pub new keyfile
 33:                     ./sig-test keyfile-from-pub --publickey 0xPublicKey --address 0xAddr
 34: `,
 35:     ArgsUsage: "[ <keyfile> ]",
 36:     Description: `
 37: Generate a new keyfile.
 38: 
 39: If you want to encrypt an existing private key, it can be specified by setting
 40: --privatekey with the location of the file containing the private key.
 41: `,
 42:     Flags: []cli.Flag{
 43:         &passphraseFlag,
 44:         &jsonFlag,
 45:         &cli.StringFlag{
 46:             Name:  "publickey",
 47:             Usage: "the Public Key",
 48:         },
 49:         &defaultNameFlag,
 50:         &logFileFlag,
 51:     },
 52:     Action: ActionKeyfileFromPub,
 53: }
 54: 
 55: // ActionGenerate will generate a new key file.
 56: func ActionKeyfileFromPub(ctx *cli.Context) error {
 57:     // Check if keyfile path given and make sure it doesn't already exist.
 58:     keyfilepath := ctx.Args().First()
 59: 
 60:     // fmt.Printf("PJS: batch=%d\n", batch) // batch is 0 if not set.
 61:     // if batch > 0 and --passphrase <file> then read 1 line for each password
 62:     // if batch > 0 and --random-pass then generate random passwrods and print them out.
 63: 
 64:     var privateKey *ecdsa.PrivateKey
 65:     var err error
 66: 
 67:     debugFlags := ctx.String(debugFlag.Name)
 68:     SetDebugFlags(debugFlags)
 69: 
 70:     privateKeyFileName := ctx.String("privatekey")
 71: 
 72:     // ----------------------------------------------------------------------------------------------------------
 73: 
 74:     if file := privateKeyFileName; file != "" {
 75:         // Load private key from file.
 76:         privateKey, err = crypto.LoadECDSA(file)
 77:         if err != nil {
 78:             Fatalf(2, "Can't load private key: %v", err)
 79:         }
 80:     } else {
 81:         // If not loaded, generate random.
 82:         privateKey, err = crypto.GenerateKey()
 83:         if err != nil {
 84:             Fatalf(2, "Failed to generate random private key: %v", err)
 85:         }
 86:     }
 87: 
 88:     // Create the keyfile object with a random UUID.
 89:     // id := uuid.NewRandom()
 90:     xid := pbUUID.NewRandom() // func NewUUID() UUID {
 91: 
 92:     // Some amazingly weird stuff - to work around the Ethereum folks using
 93:     // Go Vendoring wrong.
 94:     buf := fmt.Sprintf(`{
 95:         "address":"6d5a68a5b8060d52981cb4ca3e6797b3b48dda0d",
 96:         "privatekey":"ed80bf3d4bf2dbf5f37601541f376607709f76b10ecb69cdd3768250329867d1",
 97:         "id":%q,
 98:         "version":3
 99:     }`, xid)
100:     fmt.Printf("buf ->%s<-\n", buf)
101:     var k keystore.Key
102:     err = k.UnmarshalJSON([]byte(buf))
103:     id := k.Id
104:     // End Weird Sutff. - have an ID to use.
105: 
106:     key := &keystore.Key{
107:         Id:         id,
108:         Address:    crypto.PubkeyToAddress(privateKey.PublicKey),
109:         PrivateKey: privateKey,
110:     }
111: 
112:     // Encrypt key with passphrase.
113:     // passphrase := promptPassphrase(true, false)
114:     passphrase := getPassphrase(ctx, false)
115:     keyjson, err := keystore.EncryptKey(key, passphrase, keystore.StandardScryptN, keystore.StandardScryptP)
116:     if err != nil {
117:         Fatalf(2, "Error encrypting key: %v", err)
118:     }
119: 
120:     if DbMap["db03"] {
121:         fmt.Printf("PJS: Key file will be stored in: %s\n", filepath.Dir(keyfilepath))
122:     }
123: 
124:     address := key.Address.Hex()
125: 
126:     newKeyFileDir := filepath.Dir(keyfilepath)
127:     newname := filepath.Base(keyfilepath)
128:     defaultName := ctx.Bool(defaultNameFlag.Name)
129:     if defaultName && newname != "." {
130:         Fatalf(2, "Can not supply both a --default-name flag and a name for the file. defaultName=true newname=[%s]\n", newname)
131:     } else if defaultName {
132:         newname = fmt.Sprintf("UTC--%s--%s", time.Now().UTC().Format("2006-01-02T15-04-05.9999999999Z"), address[2:])
133:     }
134: 
135:     // Store the file to disk.
136:     if err := os.MkdirAll(newKeyFileDir, 0700); err != nil {
137:         Fatalf(2, "Could not create directory %s", newKeyFileDir)
138:     }
139: 
140:     path := filepath.Join(newKeyFileDir, newname)
141: 
142:     // check if file already exists - if so then cowerdly refuse to ovewrite it.
143:     if Exists(path) {
144:         Fatalf(2, "File [%s] already exists - will not overwrite\n", path)
145:     }
146: 
147:     // Output the file.
148:     if err := ioutil.WriteFile(path, keyjson, 0600); err != nil {
149:         Fatalf(2, "Failed to write keyfile to %s: %v", path, err)
150:     }
151: 
152:     // Output some information.
153:     out := outputGenerate{
154:         Address: address,
155:     }
156:     if ctx.Bool(jsonFlag.Name) {
157:         mustPrintJSON(out)
158:     } else {
159:         genRandom := ctx.Bool(randomPassFlag.Name)
160:         if genRandom {
161:             fmt.Printf("Password: %s\n", passphrase)
162:         }
163:         fmt.Println("Address:", out.Address)
164:         fmt.Println("File Name:", path)
165:         lf := ctx.String(logFileFlag.Name)
166:         if lf != "" {
167:             AppendToLog(lf, fmt.Sprintf("Password: %s\nAddress: %s\nFile Name:%s\n\n", passphrase, out.Address, path))
168:         }
169:     }
170:     return nil
171: }
