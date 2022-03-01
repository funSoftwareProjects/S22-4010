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
 20:     "fmt"
 21:     "os"
 22:     "testing"
 23: 
 24:     "github.com/docker/docker/pkg/reexec"
 25:     "github.com/ethereum/go-ethereum/internal/cmdtest"
 26: )
 27: 
 28: type testEthkey struct {
 29:     *cmdtest.TestCmd
 30: }
 31: 
 32: // spawns ethkey with the given command line args.
 33: func runEthkey(t *testing.T, args ...string) *testEthkey {
 34:     tt := new(testEthkey)
 35:     tt.TestCmd = cmdtest.NewTestCmd(t, tt)
 36:     tt.Run("sig-test", args...)
 37:     return tt
 38: }
 39: 
 40: func TestMain(m *testing.M) {
 41:     // Run the app if we've been exec'd as "sig-test" in runEthkey.
 42:     reexec.Register("sig-test", func() {
 43:         if err := app.Run(os.Args); err != nil {
 44:             fmt.Fprintln(os.Stderr, err)
 45:             os.Exit(1)
 46:         }
 47:         os.Exit(0)
 48:     })
 49:     // check if we have been reexec'd
 50:     if reexec.Init() {
 51:         return
 52:     }
 53:     os.Exit(m.Run())
 54: }
