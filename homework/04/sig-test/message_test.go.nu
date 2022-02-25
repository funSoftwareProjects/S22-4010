  1: // Copyright 2018 The go-ethereum Authors
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
 20:     "io/ioutil"
 21:     "os"
 22:     "path/filepath"
 23:     "testing"
 24: )
 25: 
 26: func TestMessageSignVerify(t *testing.T) {
 27:     tmpdir, err := ioutil.TempDir("", "sig-test")
 28:     if err != nil {
 29:         t.Fatal("Can't create temporary directory:", err)
 30:     }
 31:     defer os.RemoveAll(tmpdir)
 32: 
 33:     keyfile := filepath.Join(tmpdir, "the-keyfile")
 34:     message := "test message"
 35: 
 36:     // Create the key.
 37:     generate := runEthkey(t, "generate", keyfile)
 38:     generate.Expect(`
 39: !! Unsupported terminal, password will be echoed.
 40: Passphrase: {{.InputLine "foobar"}}
 41: Repeat passphrase: {{.InputLine "foobar"}}
 42: `)
 43:     _, matches := generate.ExpectRegexp(`Address: (0x[0-9a-fA-F]{40})\n`)
 44:     address := matches[1]
 45:     generate.ExpectExit()
 46: 
 47:     // Sign a message.
 48:     sign := runEthkey(t, "signmessage", keyfile, message)
 49:     sign.Expect(`
 50: !! Unsupported terminal, password will be echoed.
 51: Passphrase: {{.InputLine "foobar"}}
 52: `)
 53:     _, matches = sign.ExpectRegexp(`Signature: ([0-9a-f]+)\n`)
 54:     signature := matches[1]
 55:     sign.ExpectExit()
 56: 
 57:     // Verify the message.
 58:     verify := runEthkey(t, "verifymessage", address, signature, message)
 59:     _, matches = verify.ExpectRegexp(`
 60: Signature verification successful!
 61: Recovered public key: [0-9a-f]+
 62: Recovered address: (0x[0-9a-fA-F]{40})
 63: `)
 64:     recovered := matches[1]
 65:     verify.ExpectExit()
 66: 
 67:     if recovered != address {
 68:         t.Error("recovered address doesn't match generated key")
 69:     }
 70: }
