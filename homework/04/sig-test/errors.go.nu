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
 21:     "io"
 22:     "os"
 23:     "runtime"
 24: )
 25: 
 26: var errorOutput = io.MultiWriter(os.Stdout, os.Stderr)
 27: 
 28: func init() {
 29:     if runtime.GOOS == "windows" {
 30:         // The SameFile check below doesn't work on Windows.
 31:         // stdout is unlikely to get redirected though, so just print there.
 32:         errorOutput = os.Stdout
 33:     } else {
 34:         outf, _ := os.Stdout.Stat()
 35:         errf, _ := os.Stderr.Stat()
 36:         if outf != nil && errf != nil && os.SameFile(outf, errf) {
 37:             errorOutput = os.Stderr
 38:         }
 39:     }
 40: }
 41: 
 42: // Fatalf formats a message to standard error and exits the program.
 43: // On Linux/Mac the message is also printed to standard output if standard error
 44: // is redirected to a different file.
 45: func Fatalf(rc int, format string, args ...interface{}) {
 46:     fmt.Fprintf(errorOutput, "Fatal: "+format+"\n", args...)
 47:     fmt.Fprintf(errorOutput, " From: %s\n", LF(2))
 48:     os.Exit(rc)
 49: }
