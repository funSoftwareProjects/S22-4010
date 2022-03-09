package main

// Get the private key from a keyfile.

import (
	"flag"
	"fmt"
	"io/ioutil"
	"os"
	"os/user"
	"path"
	"strings"

	"github.com/ethereum/go-ethereum/accounts/keystore"
	"github.com/ethereum/go-ethereum/crypto"
	"github.com/pschlump/godebug"
)

var InKeyFile = flag.String("keyfile", "", "Keyfile to read in")
var InKeyFilePassword = flag.String("password", "", "Keyfile Password")

func main() {

	flag.Parse()

	fns := flag.Args()
	if len(fns) != 0 {
		fmt.Printf("Extra arguments are not supported [%s]\n", fns)
		os.Exit(1)
	}

	// fmt.Printf("InKeyFile [%s]\n", *InKeyFile)
	// fmt.Printf("InKeyFilePassword [%s]\n", *InKeyFilePassword)

	if InKeyFile == nil {
		fmt.Printf("Keyfile not supplied (required): %s\n", godebug.LF())
		os.Exit(1)
	}
	if *InKeyFile == "" {
		fmt.Printf("Keyfile not supplied (required): %s\n", godebug.LF())
		os.Exit(1)
	}

	KeyFile := *InKeyFile
	if KeyFile[0:1] == "~" {
		KeyFile = ProcessHome(KeyFile)
	}

	if !Exists(KeyFile) {
		fmt.Printf("Key file missing: %s\n", godebug.LF())
		os.Exit(1)
	}

	AccountKey, err := DecryptKeyFile(KeyFile, *InKeyFilePassword)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Failed to read KeyFile: %s: [%s]\n", KeyFile, err)
		os.Exit(1)
	}
	fmt.Printf("Private Key: 0x%x\n", crypto.FromECDSA(AccountKey.PrivateKey))

	fmt.Printf("To import into truffle:\n")
	fmt.Printf("   At the console, `truffle(develop) >` or attach to truffle with `$ geth attach http://127.0.0.1:9545`, then...\n")
	fmt.Printf("        > web3.personal.importRawKey(\"0x%x\",%q)\n", crypto.FromECDSA(AccountKey.PrivateKey), *InKeyFilePassword)
}

// DecryptKeyFile reads in a key file decrypt it with the password.
func DecryptKeyFile(keyFile, password string) (*keystore.Key, error) {
	data, err := ioutil.ReadFile(keyFile)
	if err != nil {
		return nil, fmt.Errorf("Faield to read KeyFile %s [%v]", keyFile, err)
	}
	key, err := keystore.DecryptKey(data, password)
	if err != nil {
		return nil, fmt.Errorf("Decryption error %s [%v]", keyFile, err)
	}
	return key, nil
}

var home string

func init() {
	if os.PathSeparator == '\\' {
		home = "C:/"
	} else {
		home = os.Getenv("HOME")
	}
}

func ProcessHome(fn string) (outFn string) {
	outFn = fn
	if len(fn) > 1 && fn[0:1] == "~" {
		if len(fn) > 2 && fn[0:2] == "~/" {
			outFn = path.Join(home, fn[2:])
			return
		} else {
			s1 := strings.Split(fn[1:], "/")
			username := s1[0]
			uu, err := user.Lookup(username)
			if err != nil {
				fmt.Fprintf(os.Stderr, "Unable to lookup [%s] user and get home directory.\n", username)
				return
			}
			outFn = path.Join(uu.HomeDir, strings.Join(s1[1:], "/"))
			return
		}
	}
	return
}

// Exists reports whether the named file or directory exists.
func Exists(name string) bool {
	if _, err := os.Stat(name); err != nil {
		if os.IsNotExist(err) {
			return false
		}
	}
	return true
}
