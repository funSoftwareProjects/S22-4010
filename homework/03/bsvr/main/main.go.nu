  1: package main
  2: 
  3: import (
  4:     "flag"
  5:     "fmt"
  6:     "io"
  7:     "io/ioutil"
  8:     "log"
  9:     "net/http"
 10:     "os"
 11:     "path/filepath"
 12:     "strings"
 13:     "sync"
 14: 
 15:     "github.com/Univ-Wyo-Education/S22-4010/homework/03/bsvr/cli"
 16:     "github.com/Univ-Wyo-Education/S22-4010/homework/03/bsvr/config"
 17:     "github.com/Univ-Wyo-Education/S22-4010/homework/03/bsvr/lib"
 18:     "github.com/pschlump/godebug"
 19: )
 20: 
 21: //
 22: // Flags
 23: //    --cfg cfg.json
 24: //  --create-gensisi
 25: //  --test-read-block
 26: //  --test-write-block
 27: //  --test-send-funds From To Amount
 28: //
 29: var Cfg = flag.String("cfg", "cfg.json", "config file for this call")
 30: var CreateGenesisFlag = flag.Bool("create-genesis", false, "init command")
 31: var TestReadBlockFlag = flag.Bool("test-read-block", false, "test read a block")
 32: var TestWriteBlockFlag = flag.Bool("test-write-block", false, "test write a block")
 33: var TestSendFunds = flag.Bool("test-send-funds", false, "test sending funds from one account to another")
 34: var ShowBalance = flag.Bool("show-balance", false, "Show the balance on an account")
 35: var ListAccounts = flag.Bool("list-accounts", false, "List the addresses of known accounts")
 36: 
 37: var ServerHostPort = flag.String("server", "", "http://127.0.0.1:9191 is a good example - if set then a server will be started.   Non server options are ignored.")
 38: var Dir = flag.String("dir", "", "Directory to serve files from if server is enabled.")
 39: var ServerCfgFlag = flag.String("scf", "{}", "Arbitrary server config data in JSON.")
 40: 
 41: func main() {
 42:     flag.Parse() // Parse CLI arguments to this, --cfg <name>.json
 43: 
 44:     fns := flag.Args()
 45: 
 46:     if Cfg == nil {
 47:         fmt.Printf("--cfg is a required parameter\n")
 48:         os.Exit(1)
 49:     }
 50: 
 51:     err := config.ReadConfig(*Cfg)
 52:     if err != nil {
 53:         fmt.Fprintf(os.Stderr, "Unable to read configuration: %s error %s\n", *Cfg, err)
 54:         os.Exit(1)
 55:     }
 56: 
 57:     if len(*Dir) > 1 && (*Dir)[0:1] == "." {
 58:         tDir, _ := os.Getwd()
 59:         tDir = filepath.Join(tDir, (*Dir)[:1])
 60:         Dir = &tDir
 61:     } else if *Dir == "." {
 62:         tDir, _ := os.Getwd()
 63:         Dir = &tDir
 64:     }
 65: 
 66:     gCfg := config.GetGlobalConfig()
 67:     cc := cli.NewCLI(gCfg)
 68: 
 69:     if *ServerHostPort != "" {
 70:         cc.ReadGlobalData([]string{})
 71:         pid := fmt.Sprintf("%v\n", os.Getpid())
 72:         ioutil.WriteFile("./pidfile", []byte(pid), 0600)
 73:         var wg sync.WaitGroup
 74:         wg.Add(1)
 75:         // fmt.Printf(" Start Server: %s\n", godebug.LF())
 76:         go func() {
 77:             // fmt.Printf("1 Start Server: %s\n", godebug.LF())
 78:             RunServer(cc, *ServerHostPort)
 79:             wg.Done()
 80:         }()
 81:         wg.Wait()
 82:     } else {
 83:         // fmt.Printf("1 Start Server: %s\n", godebug.LF())
 84:         if *CreateGenesisFlag {
 85:             cc.CreateGenesis(fns)
 86:         } else if *TestReadBlockFlag {
 87:             cc.TestReadBlock(fns)
 88:         } else if *TestWriteBlockFlag {
 89:             cc.TestWriteBlock(fns)
 90:         } else if *TestSendFunds {
 91:             cc.TestSendFunds(fns)
 92:         } else if *ShowBalance {
 93:             cc.ShowBalance(fns)
 94:         } else if *ListAccounts {
 95:             cc.ListAccounts(fns)
 96:         } else {
 97:             fmt.Printf("1 Start Server: %s\n", godebug.LF())
 98:             cc.Usage()
 99:             os.Exit(1)
100:         }
101:     }
102: 
103: }
104: 
105: func RunServer(cc *cli.CLI, ServerHostPort string) {
106: 
107:     http.HandleFunc("/api/status", respHandlerStatus)
108:     http.HandleFunc("/status", respHandlerStatus)
109:     http.HandleFunc("/api/shutdown", getRespHandlerShutdown(cc))
110: 
111:     http.HandleFunc("/api/acct-list", getRespHandlerAcctList(cc))
112:     http.HandleFunc("/api/acct-value", getRespHandlerAcctValue(cc))
113:     http.HandleFunc("/api/validate-signed-message", getRespHandlerValidateSignedMessage(cc))
114:     http.HandleFunc("/api/send-funds-to", getRespHandlerSendFundsTo(cc))
115: 
116:     http.Handle("/", http.FileServer(http.Dir(*Dir)))
117:     log.Fatal(http.ListenAndServe(ServerHostPort, nil))
118: 
119: }
120: 
121: type HandlerFunc func(www http.ResponseWriter, req *http.Request)
122: 
123: func respHandlerStatus(www http.ResponseWriter, req *http.Request) {
124:     q := req.RequestURI
125: 
126:     var rv string
127:     www.Header().Set("Content-Type", "application/json")
128:     rv = fmt.Sprintf(`{"status":"success","name":"go-server version 1.0.0","URI":%q,"req":%s, "response_header":%s}`,
129:         q, lib.SVarI(req), lib.SVarI(www.Header()))
130: 
131:     io.WriteString(www, rv)
132: }
133: 
134: func getRespHandlerShutdown(cc *cli.CLI) HandlerFunc {
135:     return func(www http.ResponseWriter, req *http.Request) {
136:         www.Header().Set("Content-Type", "application/json")
137:         if !ValidateAcctPin(cc, www, req) {
138:             return
139:         }
140:         signature, fail := GetParam(cc, www, req, "signature")
141:         if fail {
142:             return
143:         }
144:         msg, fail := GetParam(cc, www, req, "msg")
145:         if fail {
146:             return
147:         }
148:         gCfg := config.GetGlobalConfig()
149:         isValid, err := cc.ValidateSignature(gCfg.ControlAcct, signature, msg)
150:         if err != nil {
151:             return
152:         }
153:         if !isValid {
154:             return
155:         }
156:         fmt.Printf("Shutdown Now\n")
157:         fmt.Fprintf(os.Stderr, "Shutdown Now\n")
158:         os.Exit(0)
159:     }
160: }
161: 
162: func ValidateAcctPin(cc *cli.CLI, www http.ResponseWriter, req *http.Request) bool {
163:     gCfg := config.GetGlobalConfig()
164:     un, pw, havePw := req.BasicAuth()
165:     if !havePw {
166:         return false
167:     }
168:     if acct, ok := gCfg.AcctPin[pw]; ok {
169:         if strings.ToUpper(acct) == strings.ToUpper(un) {
170:             return true
171:         }
172:     }
173:     return false
174: }
175: 
176: func GetParam(cc *cli.CLI, www http.ResponseWriter, req *http.Request, name string) (string, bool) {
177:     // fmt.Printf("Request: %s, AT:%s\n", godebug.SVarI(req), godebug.LF())
178:     param1 := req.URL.Query().Get(name)
179:     // fmt.Printf("Param: name ->%s<- value ->%s<-, AT: %s\n", name, param1, godebug.LF())
180:     if param1 != "" {
181:         return param1, false
182:     }
183:     http.Error(www, "Required parameter "+name+" missing.", http.StatusInternalServerError)
184:     return "", true
185: }
186: 
187: func getRespHandlerAcctList(cc *cli.CLI) HandlerFunc {
188:     return func(www http.ResponseWriter, req *http.Request) {
189:         www.Header().Set("Content-Type", "application/json")
190:         if !ValidateAcctPin(cc, www, req) {
191:             return
192:         }
193:         rv := cc.ListAccountsJSON()
194:         www.Header().Set("Content-Type", "application/json")
195:         io.WriteString(www, rv)
196:     }
197: }
198: 
199: func getRespHandlerAcctValue(cc *cli.CLI) HandlerFunc {
200:     return func(www http.ResponseWriter, req *http.Request) {
201:         // fmt.Printf("AT: %s\n", godebug.LF())
202:         if !ValidateAcctPin(cc, www, req) {
203:             fmt.Printf("AT: %s\n", godebug.LF())
204:             return
205:         }
206:         www.Header().Set("Content-Type", "application/json")
207:         acct, fail := GetParam(cc, www, req, "acct")
208:         if fail {
209:             // fmt.Printf("AT: %s\n", godebug.LF())
210:             // fmt.Fprintf(www, "Missing Parameter %s\n", "acct")
211:             return
212:         }
213:         // fmt.Printf("AT: %s\n", godebug.LF())
214:         rv := cc.ShowBalanceJSON(acct)
215:         // fmt.Printf("rv = ->%s<- AT: %s\n", rv, godebug.LF())
216:         // fmt.Printf("AT: %s\n", godebug.LF())
217:         io.WriteString(www, rv)
218:     }
219: }
220: 
221: func getRespHandlerValidateSignedMessage(cc *cli.CLI) HandlerFunc {
222:     return func(www http.ResponseWriter, req *http.Request) {
223:         www.Header().Set("Content-Type", "application/json")
224:         if !ValidateAcctPin(cc, www, req) {
225:             return
226:         }
227:         acct, fail := GetParam(cc, www, req, "acct")
228:         if fail {
229:             return
230:         }
231:         signature, fail := GetParam(cc, www, req, "signature")
232:         if fail {
233:             return
234:         }
235:         msg, fail := GetParam(cc, www, req, "msg")
236:         if fail {
237:             return
238:         }
239:         isValid, err := cc.ValidateSignature(acct, signature, msg)
240:         if err != nil {
241:             fmt.Fprintf(www, "{\"status\":\"error\",\"msg\":%q}\n", err)
242:             return
243:         }
244:         if isValid {
245:             fmt.Fprintf(www, "{\"status\":\"success\",\"msg\":%q}\n", "Signature validated")
246:         } else {
247:             fmt.Fprintf(www, "{\"status\":\"fail\",\"msg\":%q}\n", "Signature is not valid")
248:         }
249:     }
250: }
251: 
252: func getRespHandlerSendFundsTo(cc *cli.CLI) HandlerFunc {
253:     return func(www http.ResponseWriter, req *http.Request) {
254:         www.Header().Set("Content-Type", "application/json")
255:         if !ValidateAcctPin(cc, www, req) {
256:             return
257:         }
258:         from, fail := GetParam(cc, www, req, "from")
259:         if fail {
260:             return
261:         }
262:         to, fail := GetParam(cc, www, req, "to")
263:         if fail {
264:             return
265:         }
266:         amount, fail := GetParam(cc, www, req, "amount")
267:         if fail {
268:             return
269:         }
270:         signature, fail := GetParam(cc, www, req, "signature")
271:         if fail {
272:             return
273:         }
274:         msg, fail := GetParam(cc, www, req, "msg")
275:         if fail {
276:             return
277:         }
278:         memo, fail := GetParam(cc, www, req, "memo")
279:         if fail {
280:             return
281:         }
282:         rv := cc.SendFundsJSON(from, to, amount, signature, msg, memo)
283:         io.WriteString(www, rv)
284:     }
285: }
