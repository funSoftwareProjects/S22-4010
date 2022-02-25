// +build darwin freebsd netbsd openbsd linux darwin

package main

import (
	"bufio"
	"fmt"
	"os"
)

//import "github.com/ethereum/go-ethereum/console"

func GetPassphrase(p string) (string, error) {

	//	passphrase, err := console.Stdin.PromptPassword("Passphrase: ")
	//	return passphrase, err

	reader := bufio.NewReader(os.Stdin)
	fmt.Println("%s", p)

	text, err := reader.ReadString('\n')
	return text, err
}
