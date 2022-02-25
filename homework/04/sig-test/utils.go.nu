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
 20:     "bufio"
 21:     "encoding/base64"
 22:     "encoding/json"
 23:     "fmt"
 24:     "io/ioutil"
 25:     "os"
 26:     "strings"
 27: 
 28:     "github.com/ethereum/go-ethereum/crypto"
 29:     "github.com/urfave/cli/v2"
 30: )
 31: 
 32: // "github.com/ethereum/go-ethereum/console"
 33: 
 34: // promptPassphrase prompts the user for a passphrase.  Set confirmation to true
 35: // to require the user to confirm the passphrase.
 36: func promptPassphrase(confirmation, isOldPassword bool) string {
 37:     // passphrase, err := console.Stdin.PromptPassword("Passphrase: ")
 38:     passphrase, err := GetPassphrase("Passphrase: ")
 39:     if err != nil {
 40:         Fatalf(2, "Failed to read passphrase: %v", err)
 41:     }
 42: 
 43:     if confirmation {
 44:         // confirm, err := console.Stdin.PromptPassword("Repeat passphrase: ")
 45:         confirm, err := GetPassphrase("Repeat passphrase: ")
 46:         if err != nil {
 47:             Fatalf(2, "Failed to read passphrase confirmation: %v", err)
 48:         }
 49:         if passphrase != confirm {
 50:             Fatalf(2, "Passphrases do not match")
 51:         }
 52:     }
 53:     passphrase = strings.TrimRight(passphrase, " \r\n\f\t")
 54:     passphrase = strings.TrimLeft(passphrase, " \r\n\f\t")
 55: 
 56:     if CheckPassword(passphrase, isOldPassword) == false {
 57:         Fatalf(3, "Password is a known to be leeked (pwned) password - you will need to use a different password\n")
 58:     }
 59: 
 60:     return passphrase
 61: }
 62: 
 63: func ReadFileAsLines(filePath string) (lines []string, err error) {
 64: 
 65:     fp, err := os.Open(filePath)
 66:     if err != nil {
 67:         return lines, err
 68:     }
 69:     defer fp.Close()
 70: 
 71:     // ... for each line ...
 72:     line_no := 0
 73:     scanner := bufio.NewScanner(fp)
 74:     for scanner.Scan() {
 75:         line := scanner.Text() // no \n or \r\n on line - already chomped - os independent:w
 76:         line_no++
 77: 
 78:         lines = append(lines, line)
 79:     }
 80:     if err := scanner.Err(); err != nil {
 81:         return lines, fmt.Errorf("error scanning file: %s", err)
 82:     }
 83:     return
 84: }
 85: 
 86: var getPassphraseInit = false
 87: var getPassphraseLines []string
 88: var getPassphraseNthLine = 0
 89: var getPassphraseFile string
 90: 
 91: func getNextLine() (rv string) {
 92:     if getPassphraseNthLine < len(getPassphraseLines) {
 93:         rv = getPassphraseLines[getPassphraseNthLine]
 94:         getPassphraseNthLine++
 95:         return
 96:     }
 97:     Fatalf(2, "Ran out of lines in passphrase file '%s': %d", getPassphraseFile, getPassphraseNthLine)
 98:     return ""
 99: }
100: 
101: // getPassphrase obtains a passphrase given by the user.  It first checks the
102: // --passfile command line flag and ultimately prompts the user for a
103: // passphrase.
104: func getPassphrase(ctx *cli.Context, isOldPassword bool) string {
105:     var err error
106:     pwFn := ctx.String(passphraseFlag.Name)
107:     genRandom := ctx.Bool(randomPassFlag.Name)
108:     if genRandom {
109:         b, err := GenRandBytes(12)
110:         if err != nil {
111:             fmt.Printf("Error: %s\n", err)
112:         }
113:         // newPhrase := hex.EncodeToString(b)             // could do better!!!!!!!!!!!!!!!!!!!!!!!!!!! PJS xyzzy FIXME
114:         str := base64.StdEncoding.EncodeToString(b) // could still do better
115:         // fmt.Printf("Password: %s\n", newPhrase)
116:         // See: https://tyler.io/generating-strong-user-friendly-passwords-in-php/
117:         // Also: https://sourceforge.net/projects/pwgen/ , pwgen-2.0.8.tar.gz
118:         str = strings.Replace(str, "0", "2", -1)
119:         str = strings.Replace(str, "1", "d", -1)
120:         str = strings.Replace(str, "Z", "v", -1)
121:         str = strings.Replace(str, "l", "3", -1)
122:         str = strings.Replace(str, "1", "h", -1)
123:         str = strings.Replace(str, "=", "u", -1)
124:         newPhrase := str
125:         return newPhrase
126:     } else if pwFn != "" {
127:         if !getPassphraseInit {
128:             getPassphraseInit = true
129:             getPassphraseFile = pwFn
130:             getPassphraseLines, err = ReadFileAsLines(pwFn)
131:             if err != nil {
132:                 fmt.Printf("Error: %s\n", err)
133:             }
134:         }
135:         //data, err := ioutil.ReadFile(pwFn)
136:         //if err != nil {
137:         //    Fatalf(2, "Failed to read passphrase file '%s': %v", pwFn, err)
138:         //}
139:         //newPhrase := string(data)
140:         newPhrase := getNextLine()
141:         newPhrase = strings.TrimRight(newPhrase, " \r\n\f\t")
142:         newPhrase = strings.TrimLeft(newPhrase, " \r\n\f\t")
143:         if CheckPassword(newPhrase, isOldPassword) == false {
144:             Fatalf(3, "Password is a known to be leeked (pwned) password - you will need to use a different password\n")
145:         }
146:         return newPhrase
147:     }
148: 
149:     // Otherwise prompt the user for the passphrase.
150:     return promptPassphrase(false, isOldPassword)
151: }
152: 
153: // signHash is a helper function that calculates a hash for the given message
154: // that can be safely used to calculate a signature from.
155: //
156: // The hash is calulcated as
157: //   keccak256("\x19Ethereum Signed Message:\n"${message length}${message}).
158: //
159: // This gives context to the signed message and prevents signing of transactions.
160: func signHash(data []byte) []byte {
161:     msg := fmt.Sprintf("\x19Ethereum Signed Message:\n%d%s", len(data), data)
162:     return crypto.Keccak256([]byte(msg))
163: }
164: 
165: // mustPrintJSON prints the JSON encoding of the given object and
166: // exits the program with an error message when the marshaling fails.
167: func mustPrintJSON(jsonObject interface{}) {
168:     jj, err := json.MarshalIndent(jsonObject, "", "  ")
169:     if err != nil {
170:         Fatalf(2, "Failed to marshal JSON object: %v", err)
171:     }
172:     fmt.Printf("%s", jj)
173: }
174: 
175: // db01     dump keyfile
176: // db02     early exit
177: // db03     print public/private keys as items, X, Y, D -- TODO - xyzzy
178: var DbMap = make(map[string]bool)
179: 
180: // SetDebugFlags sets a map with debug flags.  Extra flags are ignored.  Valid ones are listed above.
181: func SetDebugFlags(debugFlags string) {
182:     if debugFlags == "" {
183:         return
184:     }
185:     flags := strings.Split(debugFlags, ",")
186:     fmt.Printf("Debug Flags Are: %s\n", FormatAsJSON(flags))
187:     for _, f := range flags {
188:         DbMap[f] = true
189:     }
190: }
191: 
192: func getMessage(ctx *cli.Context, atpos, msgarg int) []byte {
193:     if file := ctx.String("msgfile"); file != "" {
194:         if ctx.Args().Len() > atpos {
195:             Fatalf(2, "Can't use --msgfile and message argument at the same time.")
196:         }
197:         msg, err := ioutil.ReadFile(file)
198:         if err != nil {
199:             Fatalf(2, "Can't read message file: %v", err)
200:         }
201:         return msg
202:     } else if ctx.Args().Len() == msgarg+1 {
203:         return []byte(ctx.Args().Get(atpos))
204:     }
205:     Fatalf(2, "Invalid number of arguments: want %d, got %d", msgarg+1, ctx.Args().Len())
206:     return nil
207: }
208: 
209: // FormatAsJSON return the JSON encoded version of the data with tab indentation.
210: func FormatAsJSON(v interface{}) string {
211:     // s, err := json.Marshal ( v )
212:     s, err := json.MarshalIndent(v, "", "\t")
213:     if err != nil {
214:         return fmt.Sprintf("Error:%s", err)
215:     } else {
216:         return string(s)
217:     }
218: }
