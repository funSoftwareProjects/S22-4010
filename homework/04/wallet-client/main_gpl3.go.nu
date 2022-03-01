  1: package main
  2: 
  3: // Copyright 2017 The go-ethereum Authors
  4: // Copyright 2018 Philip Schlump.
  5: // This file uses code that was part of go-ethereum.
  6: //
  7: // go-ethereum is free software: you can redistribute it and/or modify
  8: // it under the terms of the GNU General Public License as published by
  9: // the Free Software Foundation, either version 3 of the License, or
 10: // (at your option) any later version.
 11: //
 12: // go-ethereum is distributed in the hope that it will be useful,
 13: // but WITHOUT ANY WARRANTY; without even the implied warranty of
 14: // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 15: // GNU General Public License for more details.
 16: //
 17: // You should have received a copy of the GNU General Public License
 18: // along with go-ethereum. If not, see <http://www.gnu.org/licenses/>.
 19: //
 20: // The LICENSE.main_gpl3 file in this directory applies to this code.
 21: 
 22: import (
 23:     "crypto/ecdsa"
 24:     "encoding/hex"
 25:     "fmt"
 26:     "io/ioutil"
 27:     "os"
 28:     "path/filepath"
 29:     "strings"
 30:     "time"
 31: 
 32:     "github.com/ethereum/go-ethereum/accounts/keystore"
 33:     "github.com/ethereum/go-ethereum/crypto"
 34:     pbUUID "github.com/pborman/uuid" // "github.com/pborman/uuid"
 35: )
 36: 
 37: // GenerateSignature uses a keyfile and password to sign a message.  If the input message is "" then a random message
 38: // will be generated.  The messgae and the signature are returned.
 39: func GenerateSignature(keyFile, password string, inMessage []byte) (message, signature string, err error) {
 40:     data, err := ioutil.ReadFile(keyFile)
 41:     if err != nil {
 42:         return "", "", fmt.Errorf("unable to read keyfile %s Error:%s", keyFile, err)
 43:     }
 44:     key, err := keystore.DecryptKey(data, password)
 45:     if err != nil {
 46:         return "", "", fmt.Errorf("unable to decrypt %s Error:%s", keyFile, err)
 47:     }
 48:     if len(inMessage) == 0 {
 49:         inMessage, err = GenRandBytes(20)
 50:         if err != nil {
 51:             return "", "", fmt.Errorf("unable to generate random message Error:%s", err)
 52:         }
 53:     }
 54:     message = hex.EncodeToString(inMessage)
 55:     rawSignature, err := crypto.Sign(signHash(inMessage), key.PrivateKey) // Sign Raw Bytes, Return hex of Raw Bytes
 56:     if err != nil {
 57:         return "", "", fmt.Errorf("unable to sign message Error:%s", err)
 58:     }
 59:     signature = hex.EncodeToString(rawSignature)
 60:     return message, signature, nil
 61: }
 62: 
 63: // GenerateNewKeyFile will generate a new key file.
 64: func GenerateNewKeyFile(passphrase string) error {
 65:     var privateKey *ecdsa.PrivateKey
 66:     var err error
 67: 
 68:     // Generate random key.
 69:     privateKey, err = crypto.GenerateKey()
 70:     if err != nil {
 71:         fmt.Fprintf(os.Stderr, "Failed to generate random private key: %v", err)
 72:         os.Exit(1)
 73:     }
 74: 
 75:     // Create the keyfile object with a random UUID.
 76:     // id := uuid.NewRandom()
 77:     xid := pbUUID.NewRandom() // func NewUUID() UUID {
 78: 
 79:     // Some amazingly weird stuff - to work around the Ethereum folks using
 80:     // Go Vendoring wrong.
 81:     buf := fmt.Sprintf(`{
 82:         "address":"6d5a68a5b8060d52981cb4ca3e6797b3b48dda0d",
 83:         "privatekey":"ed80bf3d4bf2dbf5f37601541f376607709f76b10ecb69cdd3768250329867d1",
 84:         "id":%q,
 85:         "version":3
 86:     }`, xid)
 87:     fmt.Printf("buf ->%s<-\n", buf)
 88:     var k keystore.Key
 89:     err = k.UnmarshalJSON([]byte(buf))
 90:     id := k.Id
 91:     // End Weird Sutff. - have an ID to use.
 92: 
 93:     key := &keystore.Key{
 94:         Id:         id,
 95:         Address:    crypto.PubkeyToAddress(privateKey.PublicKey),
 96:         PrivateKey: privateKey,
 97:     }
 98: 
 99:     // Encrypt key with passphrase.
100:     keyjson, err := keystore.EncryptKey(key, passphrase, keystore.StandardScryptN, keystore.StandardScryptP)
101:     if err != nil {
102:         fmt.Fprintf(os.Stderr, "Error encrypting key: %v", err)
103:         os.Exit(1)
104:     }
105: 
106:     address := key.Address.Hex()
107: 
108:     newname := fmt.Sprintf("UTC--%s--%s", time.Now().UTC().Format("2006-01-02T15-04-05.9999999999Z"), address[2:])
109: 
110:     path := filepath.Join(GCfg.WalletPath, newname)
111: 
112:     // check if file already exists - if so then cowerdly refuse to ovewrite it.
113:     if Exists(path) {
114:         fmt.Fprintf(os.Stderr, "File [%s] already exists - will not overwrite\n", path)
115:         os.Exit(1)
116:     }
117: 
118:     // Output the file.
119:     if err := ioutil.WriteFile(path, keyjson, 0600); err != nil {
120:         fmt.Fprintf(os.Stderr, "Failed to write keyfile to %s: %v", path, err)
121:         os.Exit(1)
122:     }
123: 
124:     fmt.Println("Address:", address)
125:     fmt.Println("File Name:", path)
126:     return nil
127: }
128: 
129: // signHash is a helper function that calculates a hash for the given message
130: // that can be safely used to calculate a signature from.
131: //
132: // The hash is calulcated as
133: //   keccak256("\x19Ethereum Signed Message:\n"${message length}${message}).
134: //
135: // This gives context to the signed message and prevents signing of transactions.
136: func signHash(data []byte) []byte {
137:     msg := fmt.Sprintf("\x19Ethereum Signed Message:\n%d%s", len(data), data)
138:     return crypto.Keccak256([]byte(msg))
139: }
140: 
141: func getPassphrase(passwordIn string) (password string) {
142:     if passwordIn != "" {
143:         password = passwordIn
144:         return
145:     }
146: 
147:     // password, err := console.Stdin.PromptPassword("Password: ")
148:     password, err := readLIneFromStdin("Password: ")
149:     if err != nil {
150:         fmt.Fprintf(os.Stderr, "Failed to read password: %s", err)
151:         os.Exit(1)
152:     }
153:     password = strings.TrimRight(password, " \r\n\f\t")
154:     password = strings.TrimLeft(password, " \r\n\f\t")
155:     return
156: }
