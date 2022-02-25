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
 20:     "bytes"
 21:     "crypto/sha1"
 22:     "fmt"
 23:     "io/ioutil"
 24:     "net/http"
 25:     "net/url"
 26:     "strings"
 27: )
 28: 
 29: // CheckPassword if ignore is false will use remote site to validate passwrod.
 30: // ignore should be true for things like the old password when chaning
 31: // passwrods (so you can upgrade a password).
 32: //
 33: // Documented: https://haveibeenpwned.com/API/v2#PwnedPasswords
 34: // GET https://api.pwnedpasswords.com/range/{first 5 hash chars}
 35: func CheckPassword(pw string, ignore bool) bool {
 36:     // If an "old" password on a change - then should ignore this check!  FIXME -- TODO --
 37:     if true || DbMap["ignore-password-check"] {
 38:         return true
 39:     }
 40: 
 41:     hash := fmt.Sprintf("%X", Sha1String(pw))
 42:     if DbMap["db05"] {
 43:         fmt.Printf("hash of ->%s<- [%s]\n", pw, hash)
 44:     }
 45:     status, data := DoGet("https://api.pwnedpasswords.com/range/" + hash[0:5])
 46:     if DbMap["db05"] {
 47:         fmt.Printf("status = %d, results...\n%s\n", status, data)
 48:     }
 49:     rest := strings.Split(data, "\n")
 50:     for _, line := range rest {
 51:         if strings.HasPrefix(line, hash[5:]) {
 52:             if DbMap["db05"] {
 53:                 fmt.Printf("Match %s to %s\n", hash[5:], line)
 54:             }
 55:             return false
 56:         }
 57:     }
 58:     return true // just return true, password is ok for now.
 59: }
 60: 
 61: // Sha1String takes the sha1 has of a string and returns it.
 62: func Sha1String(s string) []byte {
 63:     h := sha1.New()
 64:     h.Write([]byte(s))
 65:     hash := h.Sum(nil)
 66:     return hash
 67: }
 68: 
 69: // DoGet performs a get request.
 70: func DoGet(uri string, args ...string) (status int, rv string) {
 71: 
 72:     sep := "?"
 73:     var qq bytes.Buffer
 74:     qq.WriteString(uri)
 75:     for ii := 0; ii < len(args); ii += 2 {
 76:         // q = q + sep + name + "=" + value;
 77:         qq.WriteString(sep)
 78:         qq.WriteString(url.QueryEscape(args[ii]))
 79:         qq.WriteString("=")
 80:         if ii < len(args) {
 81:             qq.WriteString(url.QueryEscape(args[ii+1]))
 82:         }
 83:         sep = "&"
 84:     }
 85:     url_q := qq.String()
 86: 
 87:     res, err := http.Get(url_q)
 88:     if err != nil {
 89:         return 500, ""
 90:     } else {
 91:         defer res.Body.Close()
 92:         body, err := ioutil.ReadAll(res.Body)
 93:         if err != nil {
 94:             return 500, ""
 95:         }
 96:         status = res.StatusCode
 97:         if status == 200 {
 98:             rv = string(body)
 99:         }
100:         return
101:     }
102: }
