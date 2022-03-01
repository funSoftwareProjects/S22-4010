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
 19: // List of all of the flags that are commonly used in this program
 20: 
 21: import (
 22:     "github.com/urfave/cli/v2"
 23: )
 24: 
 25: var passphraseFlag = cli.StringFlag{
 26:     Name:  "passwordfile",
 27:     Usage: "the file that contains the passphrase for the keyfile",
 28: }
 29: 
 30: var jsonFlag = cli.BoolFlag{
 31:     Name:  "json",
 32:     Usage: "output JSON instead of human-text format",
 33: }
 34: 
 35: var newPassphraseFlag = cli.StringFlag{
 36:     Name:  "newpasswordfile",
 37:     Usage: "the file that contains the new passphrase for the keyfile",
 38: }
 39: 
 40: var debugFlag = cli.StringFlag{
 41:     Name:  "debug",
 42:     Usage: "turn on debug flags",
 43: }
 44: 
 45: var msgfileFlag = cli.StringFlag{
 46:     Name:  "msgfile",
 47:     Usage: "file containing the message to sign/verify",
 48: }
 49: 
 50: var defaultNameFlag = cli.BoolFlag{
 51:     Name:  "default-name",
 52:     Usage: "Use a default name for the output file, `DateTime--AccountNo`.",
 53: }
 54: 
 55: var genMsgFlag = cli.BoolFlag{
 56:     Name:  "gen-msg",
 57:     Usage: "randomly generate a message to sign",
 58: }
 59: 
 60: var randomPassFlag = cli.BoolFlag{
 61:     Name:  "random-pass",
 62:     Usage: "randomly generate passwords",
 63: }
 64: 
 65: var logFileFlag = cli.StringFlag{
 66:     Name:  "log-file",
 67:     Usage: "file where info will be logged",
 68: }
 69: 
 70: var newNameFlag = cli.StringFlag{
 71:     Name:  "newname",
 72:     Usage: "new name of keyfile, set to '-' to overwrite the existing file.",
 73: }
