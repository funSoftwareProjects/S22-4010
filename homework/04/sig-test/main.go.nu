  1: // Copyright 2017 The go-ethereum Authors
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
 22: 
 23:     "github.com/urfave/cli/v2"
 24: )
 25: 
 26: // Git SHA1 commit hash of the release (set via linker flags)
 27: var gitCommit = ""
 28: 
 29: var app *cli.App
 30: 
 31: func init() {
 32:     app = NewApp(gitCommit, "an Ethereum key manager")
 33:     app.Commands = []*cli.Command{
 34:         &commandGenerate,
 35:         &commandInspect,
 36:         &commandChangePassphrase,
 37:         &commandChangePassword,
 38:         &commandSignMessage,
 39:         &commandVerifyMessage,
 40:     }
 41: }
 42: 
 43: func main() {
 44:     if err := app.Run(os.Args); err != nil {
 45:         fmt.Fprintln(os.Stderr, err)
 46:         os.Exit(1)
 47:     }
 48: }
 49: 
 50: // NewApp creates an app with sane defaults.
 51: func NewApp(gitCommit, usage string) *cli.App {
 52:     app := cli.NewApp()
 53:     // app.Name = filepath.Base(os.Args[0])
 54:     // app.Author = ""
 55:     // app.Email = ""
 56:     app.Version = "v1.0.0"
 57:     if len(gitCommit) >= 8 {
 58:         app.Version += "-" + gitCommit[:8]
 59:     }
 60:     app.Usage = usage
 61:     return app
 62: }
