package main

import (
	"bufio"
	"fmt"
	"os"
)

//	password, err := readLIneFromStdin("Password: " )

func readLIneFromStdin(s string) (rv string, err error) {

	fmt.Printf("%s", s)
	scanner := bufio.NewScanner(os.Stdin)
	if scanner.Scan() {
		rv = scanner.Text()
	}

	err = scanner.Err()
	return
}
