  1: // Assignment 4
  2: // Assignment 4
  3: 
  4: package main
  5: 
  6: // Client Program
  7: //
  8: // Options
  9: //        --host http://127.0.0.1:9022
 10: //        --cmd send-funds-to --from MyAcct --to AcctTo --amount ####
 11: //        --cmd list-accts
 12: //        --cmd list-my-accts
 13: //        --cmd acct-value --acct AnAcct
 14: //        --cmd new-key-file --password <PW>
 15: //        --help
 16: //
 17: 
 18: import (
 19:     "bytes"
 20:     "crypto/rand"
 21:     "encoding/json"
 22:     "flag"
 23:     "fmt"
 24:     "io/ioutil"
 25:     "net/http"
 26:     "net/url"
 27:     "os"
 28:     "path/filepath"
 29:     "regexp"
 30:     "strings"
 31: 
 32:     "github.com/pschlump/godebug"
 33: )
 34: 
 35: type ConfigData struct {
 36:     Host       string
 37:     WalletPath string
 38:     LoginAcct  string
 39:     LoginPin   string
 40: }
 41: 
 42: var GCfg ConfigData
 43: 
 44: var Cfg = flag.String("cfg", "cfg.json", "config file for this program.")
 45: var Cmd = flag.String("cmd", "", "command to run.")
 46: var From = flag.String("from", "", "from account.")
 47: var To = flag.String("to", "", "to account.")
 48: var Acct = flag.String("acct", "", "account to specify.")
 49: var Amount = flag.Int("amount", 0, "amount of money to use in tranaction.")
 50: var Password = flag.String("password", "", "password ot use if creating a key file.")
 51: var Memo = flag.String("memo", "", "Memo for send funds tranaction.")
 52: 
 53: var HostWithUnPw string
 54: 
 55: func main() {
 56:     flag.Parse() // Parse CLI arguments to this, --cfg <name>.json
 57: 
 58:     fns := flag.Args()
 59:     if len(fns) > 0 {
 60:         usage()
 61:     }
 62: 
 63:     GCfg = ReadCfg(*Cfg)
 64: 
 65:     os.MkdirAll(GCfg.WalletPath, 0755)
 66: 
 67:     uP, err := url.Parse(GCfg.Host)
 68:     if err != nil {
 69:         fmt.Fprintf(os.Stderr, "Unable to parse the host, error:%s\n", err)
 70:         os.Exit(1)
 71:     }
 72:     uP.User = url.UserPassword(GCfg.LoginAcct, GCfg.LoginPin) // Note RFC 2396 - this is very bad security!
 73:     HostWithUnPw = fmt.Sprintf("%s", uP)
 74:     // fmt.Printf("HostWithUnPw= ->%s<-\n", HostWithUnPw)
 75: 
 76:     switch *Cmd {
 77:     case "echo":
 78:         fmt.Printf("Echo was called\n")
 79: 
 80:     case "list-accts":
 81:         urlStr := fmt.Sprintf("%s/api/acct-list", HostWithUnPw)
 82:         // fmt.Printf("urlStr= ->%s<-\n", urlStr)
 83:         status, body := DoGet(urlStr)
 84:         if status == 200 {
 85:             fmt.Printf("Body: %s\n", body)
 86:         } else {
 87:             fmt.Printf("Error: %d\n", status)
 88:         }
 89: 
 90:     case "shutdown-server":
 91:         urlStr := fmt.Sprintf("%s/api/shutdown", HostWithUnPw)
 92:         status, body := DoGet(urlStr)
 93:         if status == 200 {
 94:             fmt.Printf("Body: %s\n", body)
 95:         } else {
 96:             fmt.Printf("Error: %d\n", status)
 97:         }
 98: 
 99:     case "server-status":
100:         urlStr := fmt.Sprintf("%s/api/status", HostWithUnPw)
101:         status, body := DoGet(urlStr)
102:         if status == 200 {
103:             fmt.Printf("Body: %s\n", body)
104:         } else {
105:             fmt.Printf("Error: %d\n", status)
106:         }
107: 
108:     case "acct-value":
109:         RequiredOption("acct", *Acct)
110:         urlStr := fmt.Sprintf("%s/api/acct-value", HostWithUnPw)
111:         // fmt.Printf("Client-AT: %s acct ->%s<-\n", godebug.LF(), *Acct)
112:         status, body := DoGet(urlStr, "acct", *Acct)
113:         if status == 200 {
114:             fmt.Printf("Body: %s\n", body)
115:         } else {
116:             fmt.Printf("Error: %d\n", status)
117:         }
118: 
119:     case "new-key-file":
120:         password := getPassphrase(*Password)
121:         if err := GenerateNewKeyFile(password); err != nil {
122:             fmt.Fprintf(os.Stderr, "Error generating KeyFile, Error:%s\n", err)
123:             os.Exit(1)
124:         }
125: 
126:     case "list-my-accts", "list-wallet":
127:         fns, _ := GetFilenames(GCfg.WalletPath)
128:         for _, fn := range fns {
129:             fmt.Printf("%s\n", fn) // TODO - clean up file name into just the "account" part.
130:         }
131: 
132:     case "validate-signed-message": // call the server with a signed message.  Verify if the message is properly signed.
133:         // Replace the call below with your code - call your own function.
134:         // InstructorValidateSignedMessage(*Acct, *Password) //SCR: Does VerifySignature play a role here, and if so, how? //Use DoGet()
135:         keyFile := getKeyFileFromAcct(*Acct)
136:         fmt.Printf("keyFile ->%s<-\n", keyFile)
137:         password := getPassphrase(*Password)
138:         buf, err := GenRandBytes(20)
139:         if err != nil {
140:             fmt.Fprintf(os.Stderr, "Error generating random data: %s\n", err)
141:             os.Exit(1)
142:         }
143:         msg, sig, err := GenerateSignature(keyFile, password, buf)
144:         if err != nil {
145:             fmt.Fprintf(os.Stderr, "Unable to sign message. Error:%s\n", err)
146:             os.Exit(1)
147:         }
148: 
149:         urlStr := fmt.Sprintf("%s/api/validate-signed-message", HostWithUnPw)
150:         status, body := DoGet(urlStr, "acct", *Acct, "signature", sig, "msg", msg)
151:         if status == 200 {
152:             fmt.Printf("Body: %s\n", body)
153:         } else {
154:             fmt.Printf("Error: %d\n", status)
155:         }
156: 
157:     case "send-funds-to":
158:         // Replace the call below with your code - call your own function.
159:         // InstructorSendFundsTo(*From, *To, *Password, *Memo, *Amount)
160:         // TODO - If the Memo parameter is "" then put in a constant memo //SCR: Is the memo parameter already passed in when this .go file triggers? If so, how do I access this? //Use DoGet()
161:         memo := *Memo
162:         if memo == "" {
163:             memo = "constant"
164:         }
165:         // TODO - Use 'RequiredOption' function to get from, to, amount, from command line
166:         RequiredOption("from", *From)
167:         RequiredOption("to", *To)
168:         RequiredOptionInt("amount", *Amount)
169: 
170:         // TODO - Format a JSON message to sign msg =: fmt.Sprintf(`{"from":%q, "to":%q, "amount":%d}`, From, To, Amount) //SCR: Would ReadCfg be used here?
171:         // TODO - Read in the key file for the From account using getKeyFileFromAcct
172:         // TODO - Read in a password for this using getPassphrase
173:         // TODO - Call GenerateSignature to sign the message, note the 'msg' returned is the hex version of the original message.
174:         // TODO - check for errros - if you can't generate a signature report an error and exit.
175:         // TODO - Generate the URL to send - the communication end point is /api/send-funds-to. It requires "from", "to", "amount", "signature", "msg", and "memo" parameters to be passed.
176:         //        Example: urlStr := fmt.Sprintf("%s/api/send-funds-to", HostWithUnPw)
177:         // TODO - Call DoGet with the set of parameters
178:         // convert Amount to a string
179:         //        Example: amountStr := fmt.Sprintf("%d", Amount)
180:         // TODO make the call using DoGet to access the server.
181:         //        Example: status, body := DoGet(urlStr, "from", *From, "to", *To, "amount", amountStr, "signature", signature, "msg", msg, "memo", *Memo)
182:         // TODO - Check the return states of the "GET" call, 200 indicates success, all other codes indicate an error
183:         //        if status == 200 {
184: 
185:     default:
186:         usage()
187:     }
188: }
189: 
190: func getKeyFileFromAcct(acct string) (keyFile string) {
191: 
192:     if acct[0:2] == "0x" || acct[0:2] == "0X" {
193:         acct = acct[2:]
194:     }
195: 
196:     fns, _ := GetFilenames(GCfg.WalletPath) // List of Files, discard any directories.
197:     for _, fn := range fns {
198:         if MatchAcctToFilename(acct, fn) {
199:             fmt.Printf("Match of Acct [%s] to fn [%s]\n", acct, fn)
200:             return filepath.Join(GCfg.WalletPath, fn)
201:         }
202:     }
203: 
204:     return
205: }
206: 
207: func MatchAcctToFilename(acct, fn string) bool {
208:     re, err := regexp.Compile(fmt.Sprintf("(?i)%s", acct)) // compare, ignore case.
209:     if err != nil {
210:         fmt.Printf("Unable to process matching of account to file name, acct [%s], fn [%s] error [%s]\n", acct, fn, err)
211:         os.Exit(1)
212:     }
213:     return re.MatchString(fn)
214: }
215: 
216: func RequiredOption(name, value string) {
217:     if value == "" {
218:         fmt.Fprintf(os.Stderr, "%s is a required option\n", name)
219:         os.Exit(1)
220:     }
221: }
222: 
223: func RequiredOptionInt(name string, value int) {
224:     if value <= 0 {
225:         fmt.Fprintf(os.Stderr, "%s is a required option\n", name)
226:         os.Exit(1)
227:     }
228: }
229: 
230: func ReadCfg(fn string) (rv ConfigData) {
231:     // Set defaults.
232:     rv.Host = "http://127.0.0.1:9191"
233:     rv.WalletPath = "./wallet-data"
234: 
235:     buf, err := ioutil.ReadFile(fn)
236:     if err != nil {
237:         fmt.Fprintf(os.Stderr, "Unable to read %s Error:%s\n", fn, err)
238:         os.Exit(1)
239:     }
240:     err = json.Unmarshal(buf, &rv)
241:     if err != nil {
242:         fmt.Fprintf(os.Stderr, "Invalid initialization - Unable to parse JSON file, %s\n", err)
243:         os.Exit(1)
244:     }
245:     return
246: }
247: 
248: // usage will print a usage message and exit.
249: func usage() {
250:     fmt.Printf("Usage: wallet-client [ --cfg file ] [ --host URL ] [ --cmd A-Command ] [ --from Acct ] [ --to Acct ] [ --amount ## ] [ --password Word ]\n")
251:     os.Exit(1)
252: }
253: 
254: // DoGet performs a GET operation over HTTP.
255: func DoGet(uri string, args ...string) (status int, rv string) {
256: 
257:     sep := "?"
258:     var qq bytes.Buffer
259:     qq.WriteString(uri)
260:     for ii := 0; ii < len(args); ii += 2 {
261:         // q = q + sep + name + "=" + value;
262:         qq.WriteString(sep)
263:         qq.WriteString(url.QueryEscape(args[ii]))
264:         qq.WriteString("=")
265:         if ii < len(args) {
266:             qq.WriteString(url.QueryEscape(args[ii+1]))
267:         }
268:         sep = "&"
269:     }
270:     url_q := qq.String()
271: 
272:     if db18 {
273:         fmt.Printf("Client-AT: %s, url=%s\n", godebug.LF(), url_q)
274:     }
275: 
276:     res, err := http.Get(url_q)
277:     if err != nil {
278:         return 500, ""
279:     } else {
280:         defer res.Body.Close()
281:         body, err := ioutil.ReadAll(res.Body)
282:         if err != nil {
283:             fmt.Printf("Error returnd: %s\n", err)
284:             return 500, ""
285:         }
286:         status = res.StatusCode
287:         if status == 200 {
288:             rv = string(body)
289:         }
290:         return
291:     }
292: }
293: 
294: // GenRandBytes will generate nRandBytes of random data using the random reader.
295: func GenRandBytes(nRandBytes int) (buf []byte, err error) {
296:     buf = make([]byte, nRandBytes)
297:     _, err = rand.Read(buf)
298:     if err != nil {
299:         return nil, err
300:     }
301:     return
302: }
303: 
304: func Exists(name string) bool {
305:     if _, err := os.Stat(name); err != nil {
306:         if os.IsNotExist(err) {
307:             return false
308:         }
309:     }
310:     return true
311: }
312: 
313: func GetFilenames(dir string) (filenames, dirs []string) {
314:     files, err := ioutil.ReadDir(dir)
315:     if err != nil {
316:         return nil, nil
317:     }
318:     for _, fstat := range files {
319:         if !strings.HasPrefix(string(fstat.Name()), ".") {
320:             if fstat.IsDir() {
321:                 dirs = append(dirs, fstat.Name())
322:             } else {
323:                 filenames = append(filenames, fstat.Name())
324:             }
325:         }
326:     }
327:     return
328: }
329: 
330: var db18 = true
