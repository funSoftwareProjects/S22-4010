// +build windows

package main

import (
	"bufio"
	"fmt"
	"os"
)

func GetPassphrase(p string) (string, error) {
	reader := bufio.NewReader(os.Stdin)
	fmt.Println("%s", p)

	text, err := reader.ReadString('\n')
	return text, err
}
