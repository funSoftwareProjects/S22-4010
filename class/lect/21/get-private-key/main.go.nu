  1: package main
  2: 
  3: // Get the private key from a keyfile.
  4: 
  5: import (
  6:     "flag"
  7:     "fmt"
  8:     "io/ioutil"
  9:     "os"
 10:     "os/user"
 11:     "path"
 12:     "strings"
 13: 
 14:     "github.com/ethereum/go-ethereum/accounts/keystore"
 15:     "github.com/ethereum/go-ethereum/crypto"
 16:     "github.com/pschlump/godebug"
 17: )
 18: 
 19: var InKeyFile = flag.String("keyfile", "", "Keyfile to read in")
 20: var InKeyFilePassword = flag.String("password", "", "Keyfile Password")
 21: 
 22: func main() {
 23: 
 24:     flag.Parse()
 25: 
 26:     fns := flag.Args()
 27:     if len(fns) != 0 {
 28:         fmt.Printf("Extra arguments are not supported [%s]\n", fns)
 29:         os.Exit(1)
 30:     }
 31: 
 32:     // fmt.Printf("InKeyFile [%s]\n", *InKeyFile)
 33:     // fmt.Printf("InKeyFilePassword [%s]\n", *InKeyFilePassword)
 34: 
 35:     if InKeyFile == nil {
 36:         fmt.Printf("Keyfile not supplied (required): %s\n", godebug.LF())
 37:         os.Exit(1)
 38:     }
 39:     if *InKeyFile == "" {
 40:         fmt.Printf("Keyfile not supplied (required): %s\n", godebug.LF())
 41:         os.Exit(1)
 42:     }
 43: 
 44:     KeyFile := *InKeyFile
 45:     if KeyFile[0:1] == "~" {
 46:         KeyFile = ProcessHome(KeyFile)
 47:     }
 48: 
 49:     if !Exists(KeyFile) {
 50:         fmt.Printf("Key file missing: %s\n", godebug.LF())
 51:         os.Exit(1)
 52:     }
 53: 
 54:     AccountKey, err := DecryptKeyFile(KeyFile, *InKeyFilePassword)
 55:     if err != nil {
 56:         fmt.Fprintf(os.Stderr, "Failed to read KeyFile: %s: [%s]\n", KeyFile, err)
 57:         os.Exit(1)
 58:     }
 59:     fmt.Printf("Private Key: 0x%x\n", crypto.FromECDSA(AccountKey.PrivateKey))
 60: 
 61:     fmt.Printf("To import into truffle:\n")
 62:     fmt.Printf("   At the console, `truffle(develop) >` or attach to truffle with `$ geth attach http://127.0.0.1:9545`, then...\n")
 63:     fmt.Printf("        > web3.personal.importRawKey(\"0x%x\",%q)\n", crypto.FromECDSA(AccountKey.PrivateKey), *InKeyFilePassword)
 64: }
 65: 
 66: // DecryptKeyFile reads in a key file decrypt it with the password.
 67: func DecryptKeyFile(keyFile, password string) (*keystore.Key, error) {
 68:     data, err := ioutil.ReadFile(keyFile)
 69:     if err != nil {
 70:         return nil, fmt.Errorf("Faield to read KeyFile %s [%v]", keyFile, err)
 71:     }
 72:     key, err := keystore.DecryptKey(data, password)
 73:     if err != nil {
 74:         return nil, fmt.Errorf("Decryption error %s [%v]", keyFile, err)
 75:     }
 76:     return key, nil
 77: }
 78: 
 79: var home string
 80: 
 81: func init() {
 82:     if os.PathSeparator == '\\' {
 83:         home = "C:/"
 84:     } else {
 85:         home = os.Getenv("HOME")
 86:     }
 87: }
 88: 
 89: func ProcessHome(fn string) (outFn string) {
 90:     outFn = fn
 91:     if len(fn) > 1 && fn[0:1] == "~" {
 92:         if len(fn) > 2 && fn[0:2] == "~/" {
 93:             outFn = path.Join(home, fn[2:])
 94:             return
 95:         } else {
 96:             s1 := strings.Split(fn[1:], "/")
 97:             username := s1[0]
 98:             uu, err := user.Lookup(username)
 99:             if err != nil {
100:                 fmt.Fprintf(os.Stderr, "Unable to lookup [%s] user and get home directory.\n", username)
101:                 return
102:             }
103:             outFn = path.Join(uu.HomeDir, strings.Join(s1[1:], "/"))
104:             return
105:         }
106:     }
107:     return
108: }
109: 
110: // Exists reports whether the named file or directory exists.
111: func Exists(name string) bool {
112:     if _, err := os.Stat(name); err != nil {
113:         if os.IsNotExist(err) {
114:             return false
115:         }
116:     }
117:     return true
118: }
