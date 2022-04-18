  1: package main
  2: 
  3: import (
  4:     "fmt"
  5:     "math/big"
  6:     "math/rand"
  7:     "time"
  8: 
  9:     "github.com/pschlump/MiscLib"
 10: )
 11: 
 12: // From: https://arrow.dit.ie/cgi/viewcontent.cgi?article=1031&context=itbj
 13: // IdProtocalsInCrypto.pdf
 14: 
 15: type DBRecord struct {
 16:     v *big.Int
 17:     e *big.Int
 18:     y *big.Int
 19:     x *big.Int
 20: }
 21: 
 22: var database map[string]*DBRecord
 23: 
 24: func init() {
 25:     database = make(map[string]*DBRecord)
 26: }
 27: 
 28: func main() {
 29: 
 30:     rand.Seed(time.Now().UnixNano())
 31: 
 32:     // ----------------------------------------------------------
 33:     // Registration and Setup
 34:     // ----------------------------------------------------------
 35: 
 36:     // From p40
 37:     p := big.NewInt(88667) // password or hash of password to convert pw to number
 38: 
 39:     q := big.NewInt(1031)      // value 1 = 'q', Pre Chosen : large prime
 40:     alpha := big.NewInt(70322) // value 2 == 'alpha', devisor of (p-1)
 41:     a := big.NewInt(755)       // value 3 == 'a', alpha = (beta**((p-1)/q))mod p
 42:     {
 43: 
 44:         // v = (alpha ^ ( q-a )) % p
 45:         t1 := big.NewInt(0)
 46:         t1.Sub(q, a)
 47:         v := big.NewInt(0)
 48:         v.Exp(alpha, t1, p) // note the 'p' is the "mod"
 49: 
 50:         fmt.Printf("Setup Complete: v=%s\n", v)
 51:         fmt.Printf(`"Save 'v' for user "alice"` + "\n")
 52: 
 53:         fmt.Printf(`%s/api/register-user%s, send-data=%s{"user":"alice","v":%d}%s`+"\n",
 54:             MiscLib.ColorYellow, MiscLib.ColorReset, MiscLib.ColorYellow, v, MiscLib.ColorReset)
 55:         // Save the validation value 'v' for "alice" in the database.
 56:         database["alice"] = &DBRecord{v: v}
 57:         fmt.Printf(`%sResponse: {"status":"success", "username":"alice", "msg":"is registered."}%s`+"\n",
 58:             MiscLib.ColorCyan, MiscLib.ColorReset)
 59:     }
 60: 
 61:     // Alice is the Client:
 62: 
 63:     // ----------------------------------------------------------
 64:     // Message 1 - Client to Server
 65:     // ----------------------------------------------------------
 66: 
 67:     // Alice Chooses, and send to Bob
 68:     // r := big.NewInt(543) // Should be random, but for this example
 69:     randNum := genRan(999)
 70:     fmt.Printf("random genrated: %d\n", randNum)
 71:     r := big.NewInt(randNum)
 72:     x := big.NewInt(0)
 73:     x.Exp(alpha, r, p) // x=(alpha^r) % p
 74: 
 75:     fmt.Printf("Send To Bob : x=%s\n", x)
 76:     fmt.Printf(`%s/api/login%s, send-data=%s{"username":"alice","x":%d}%s`+"\n",
 77:         MiscLib.ColorYellow, MiscLib.ColorReset, MiscLib.ColorYellow, x, MiscLib.ColorReset)
 78:     dbr := database["alice"]
 79: 
 80:     //
 81: 
 82:     v := dbr.v
 83:     fmt.Printf(`Server looks up in the database 'v' for "alice", v=%d`+"\n", v)
 84: 
 85:     // ------------------------------------------------------------------------
 86:     // Response to Message 1, Server back to client
 87:     // ------------------------------------------------------------------------
 88:     {
 89:         dbr := database["alice"]
 90:         dbr.x = x
 91:         database["alice"] = dbr
 92:     }
 93: 
 94:     y := big.NewInt(0)
 95:     // Bob is the Server:
 96:     // Bob sends the challenge 'e' back to Alice e to do the computation
 97:     // e := big.NewInt(1000) // how chose (random?)
 98:     randNum = genRan(999)
 99:     e := big.NewInt(randNum)
100:     {
101:         dbr := database["alice"]
102:         dbr.e = e
103:         database["alice"] = dbr
104:     }
105:     fmt.Printf(`%sResponse: {"status":"success", "e":%d}%s`+"\n", MiscLib.ColorCyan, e, MiscLib.ColorReset)
106:     {
107: 
108:         // Alice(client) now computes: y = a*e % q
109:         t2 := big.NewInt(0)
110:         t2.Mul(a, e)
111:         t2.Mod(t2, q) // 45664
112:         t2.Add(t2, r) // 851 is correct
113: 
114:         y = t2
115:         fmt.Printf("y=%s\n", y) // Prints 851
116:         fmt.Printf(`%s/api/login-pt1%s, send-data: %s{"username":%q,"y":%d}%s`+"\n",
117:             MiscLib.ColorYellow, MiscLib.ColorReset, MiscLib.ColorYellow, "alice", y, MiscLib.ColorReset)
118:         fmt.Printf(`response: %s{"status":"success","y":%d}%s`+"\n",
119:             MiscLib.ColorCyan, y, MiscLib.ColorReset)
120:     }
121:     {
122:         dbr := database["alice"]
123:         dbr.y = y
124:         database["alice"] = dbr
125:     }
126: 
127:     // At this point.
128:     // Alice has 'y' - by calculating it from 'e'
129:     // Bob has 'y' saved in database.
130: 
131:     // ------------------------------------------------------------------------
132:     // Message 2 - Client (Alice) with response to challenge.
133:     // ------------------------------------------------------------------------
134: 
135:     z := big.NewInt(0)
136:     {
137:         // Bob (server) verifies: x == z == (a^y) * (v^e) % p
138:         // or a Better version of the same calulation
139:         // Bob (server) verifies: x == z == ((a^y)%p)*((v^e)%p) % p
140: 
141:         dbr := database["alice"]
142:         v := dbr.v // Validation value
143:         e := dbr.e // random saved from earlier
144:         y := dbr.y // calculated on server and saved.
145:         fmt.Printf(`Server looks up in the database 'v','e','y' for "alice", v=%d`+"\n", v)
146: 
147:         //
148: 
149:         t3 := big.NewInt(0)
150:         t3.Exp(alpha, y, p)
151:         t4 := big.NewInt(0)
152:         t4.Exp(v, e, p)
153:         t5 := big.NewInt(0)
154:         t5.Mul(t3, t4)
155:         t5.Mod(t5, p)
156:         z = t5
157:     }
158: 
159:     fmt.Printf("z=%s\n", z)
160:     fmt.Printf(`%s/api/login-pt2%s, send-data: %s{"username":"alice"}%s`+"\n",
161:         MiscLib.ColorYellow, MiscLib.ColorReset, MiscLib.ColorYellow, MiscLib.ColorReset)
162: 
163:     // ------------------------------------------------------------------------
164:     // Response 2 - Success/Fail message from server back to client
165:     // ------------------------------------------------------------------------
166: 
167:     {
168:         // fetch 'x' from earlier
169:         dbr := database["alice"]
170:         x = dbr.x
171: 
172:         if x.Cmp(z) == 0 {
173:             fmt.Printf("%sAuthoized! Yea, 'alice' is a valid user%s\n", MiscLib.ColorGreen, MiscLib.ColorReset)
174:             fmt.Printf(`%sResponse: {"status":"success","msg":"'alice' is logged in"}%s`+"\n",
175:                 MiscLib.ColorCyan, MiscLib.ColorReset)
176:         } else {
177:             fmt.Printf("%sNope nope nope%s\n", MiscLib.ColorRed, MiscLib.ColorReset)
178:             fmt.Printf(`%sResponse: {"status":"error","msg":"'alice' is not a valid user"}%s`+"\n",
179:                 MiscLib.ColorRed, MiscLib.ColorReset)
180:         }
181:     }
182: 
183: }
184: 
185: // Not! Not a cryptographic random number generation!
186: func genRan(m int) int64 {
187:     return int64(rand.Intn(m))
188: }
