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
 20:     "crypto/rand"
 21:     "errors"
 22:     "fmt"
 23:     "io/ioutil"
 24:     "math/big"
 25:     "os"
 26:     "path/filepath"
 27:     "reflect"
 28:     "regexp"
 29:     "runtime"
 30:     "strconv"
 31:     "strings"
 32: 
 33:     "github.com/pschlump/jsonSyntaxErrorLib"
 34: )
 35: 
 36: // -------------------------------------------------------------------------------------------------
 37: func Exists(name string) bool {
 38:     if _, err := os.Stat(name); err != nil {
 39:         if os.IsNotExist(err) {
 40:             return false
 41:         }
 42:     }
 43:     return true
 44: }
 45: 
 46: // -------------------------------------------------------------------------------------------------
 47: func ExistsIsDir(name string) bool {
 48:     fi, err := os.Stat(name)
 49:     if err != nil {
 50:         if os.IsNotExist(err) {
 51:             return false
 52:         }
 53:     }
 54:     if fi.IsDir() {
 55:         return true
 56:     }
 57:     return false
 58: }
 59: 
 60: // -------------------------------------------------------------------------------------------------
 61: // Get a list of filenames and directorys.
 62: // -------------------------------------------------------------------------------------------------
 63: func GetFilenames(dir string) (filenames, dirs []string) {
 64:     files, err := ioutil.ReadDir(dir)
 65:     if err != nil {
 66:         return nil, nil
 67:     }
 68:     for _, fstat := range files {
 69:         if !strings.HasPrefix(string(fstat.Name()), ".") {
 70:             if fstat.IsDir() {
 71:                 dirs = append(dirs, fstat.Name())
 72:             } else {
 73:                 filenames = append(filenames, fstat.Name())
 74:             }
 75:         }
 76:     }
 77:     return
 78: }
 79: 
 80: // -------------------------------------------------------------------------------------------------
 81: func RmExt(filename string) string {
 82:     var extension = filepath.Ext(filename)
 83:     var name = filename[0 : len(filename)-len(extension)]
 84:     return name
 85: }
 86: 
 87: // RmExtIfHasExt will remove an extension from name if it exists.
 88: // TODO: make ext an list of extensions and have it remove any that exists.
 89: //
 90: // name - example abc.xyz
 91: // ext - example .xyz
 92: //
 93: // If extension is not on the end of name, then just return name.
 94: func RmExtIfHasExt(name, ext string) (rv string) {
 95:     rv = name
 96:     if strings.HasSuffix(name, ext) {
 97:         rv = name[0 : len(name)-len(ext)]
 98:     }
 99:     return
100: }
101: 
102: // -------------------------------------------------------------------------------------------------
103: var invalidMode = errors.New("Invalid Mode")
104: 
105: func Fopen(fn string, mode string) (file *os.File, err error) {
106:     file = nil
107:     if mode == "r" {
108:         file, err = os.Open(fn) // For read access.
109:     } else if mode == "w" {
110:         file, err = os.OpenFile(fn, os.O_WRONLY|os.O_CREATE|os.O_TRUNC, 0666)
111:     } else if mode == "a" {
112:         file, err = os.OpenFile(fn, os.O_RDWR|os.O_APPEND, 0660)
113:         if err != nil {
114:             file, err = os.OpenFile(fn, os.O_WRONLY|os.O_CREATE|os.O_TRUNC, 0666)
115:         }
116:     } else {
117:         err = invalidMode
118:     }
119:     return
120: }
121: 
122: // -------------------------------------------------------------------------------------------------
123: // This is to be used/implemented when we add
124: // 1. ability to chagne the prompt - using templates
125: // 2. ability to use templates in commands
126: func SetValue(name, val string) {
127:     // TODO
128: }
129: 
130: // ===============================================================================================================================================================================================
131: var isIntStringRe *regexp.Regexp
132: var isHexStringRe *regexp.Regexp
133: var trueValues map[string]bool
134: var boolValues map[string]bool
135: 
136: func init() {
137:     isIntStringRe = regexp.MustCompile("([+-])?[0-9][0-9]*")
138:     isHexStringRe = regexp.MustCompile("(0x)?[0-9a-fA-F][0-9a-fA-F]*")
139: 
140:     trueValues = make(map[string]bool)
141:     trueValues["t"] = true
142:     trueValues["T"] = true
143:     trueValues["yes"] = true
144:     trueValues["Yes"] = true
145:     trueValues["YES"] = true
146:     trueValues["1"] = true
147:     trueValues["true"] = true
148:     trueValues["True"] = true
149:     trueValues["TRUE"] = true
150:     trueValues["on"] = true
151:     trueValues["On"] = true
152:     trueValues["ON"] = true
153: 
154:     boolValues = make(map[string]bool)
155:     boolValues["t"] = true
156:     boolValues["T"] = true
157:     boolValues["yes"] = true
158:     boolValues["Yes"] = true
159:     boolValues["YES"] = true
160:     boolValues["1"] = true
161:     boolValues["true"] = true
162:     boolValues["True"] = true
163:     boolValues["TRUE"] = true
164:     boolValues["on"] = true
165:     boolValues["On"] = true
166:     boolValues["ON"] = true
167: 
168:     boolValues["f"] = true
169:     boolValues["F"] = true
170:     boolValues["no"] = true
171:     boolValues["No"] = true
172:     boolValues["NO"] = true
173:     boolValues["0"] = true
174:     boolValues["false"] = true
175:     boolValues["False"] = true
176:     boolValues["FALSE"] = true
177:     boolValues["off"] = true
178:     boolValues["Off"] = true
179:     boolValues["OFF"] = true
180: }
181: 
182: func IsIntString(s string) bool {
183:     return isIntStringRe.MatchString(s)
184: }
185: 
186: func ParseBool(s string) (b bool) {
187:     _, b = trueValues[s]
188:     return
189: }
190: 
191: // -------------------------------------------------------------------------------------------------
192: func ConvToHexBigInt(s string) (rv *big.Int) {
193:     s = StripQuote(s)
194:     rv = big.NewInt(0)
195:     if strings.HasPrefix(s, "0x") {
196:         s = s[2:]
197:     }
198:     rv.SetString(s, 16)
199:     return
200: }
201: 
202: func ConvToDecBigInt(s string) (rv *big.Int) {
203:     s = StripQuote(s)
204:     rv = big.NewInt(0)
205:     rv.SetString(s, 10)
206:     return
207: }
208: 
209: func ConvToInt64(s string) (rv int64) {
210:     rv, _ = strconv.ParseInt(s, 10, 64)
211:     return
212: }
213: 
214: func ConvToUInt64(s string) (rv uint64) {
215:     t, _ := strconv.ParseInt(s, 10, 64)
216:     rv = uint64(t)
217:     return
218: }
219: 
220: func ConvToBool(s string) bool {
221:     return ParseBool(s)
222: }
223: 
224: func IsBool(s string) (ok bool) {
225:     _, ok = boolValues[s]
226:     return
227: }
228: 
229: func IsHexNumber(s string) (ok bool) {
230:     ok = isHexStringRe.MatchString(s)
231:     return
232: }
233: 
234: func IsNumber(s string) (ok bool) {
235:     ok = isIntStringRe.MatchString(s)
236:     return
237: }
238: 
239: func IsString(pp string) (rv bool) {
240:     return true
241: }
242: 
243: func HexOf(ss string, base int) (rv byte) { // still working on this
244:     t, err := strconv.ParseInt(ss, base, 64)
245:     if err != nil {
246:         fmt.Printf("Warning: HexOf: error with >%s< as input, %s\n", ss, err)
247:         return 0
248:     }
249:     rv = byte(t)
250:     return
251: }
252: 
253: func ConvNumberToByte32(pp string) (rv [32]byte) {
254:     // TBD xyzzy503
255:     pp = StripQuote(pp)
256:     base := 10
257:     if strings.HasPrefix(pp, "0x") {
258:         pp = pp[2:]
259:         base = 16
260:     }
261:     for ii := 0; ii < 32; ii++ {
262:         rv[ii] = 0
263:     }
264:     // xyzzy - if base == 16, then we do the hex thing, if == 10 then use a big.Int() -- TODO - not implemented yet.
265:     for ii := 0; ii < len(pp) && ii < 64; ii += 2 {
266:         if ii+2 <= len(pp) {
267:             rv[ii/2] = HexOf(pp[ii:ii+2], base)
268:         } else {
269:             rv[ii/2] = HexOf(pp[ii:ii+1]+"0", base)
270:         }
271:     }
272:     return
273: }
274: 
275: func ConvHexNumberToByte32(pp string) (rv [32]byte) {
276:     rv = ConvNumberToByte32(pp)
277:     return
278: }
279: 
280: func ConvStringToByte32(pp string) (rv [32]byte) {
281:     for ii := 0; ii < 32; ii++ {
282:         rv[ii] = 0
283:     }
284:     for ii := 0; ii < len(pp) && ii < 64; ii++ {
285:         rv[ii] = pp[ii]
286:     }
287:     return
288: }
289: 
290: // -------------------------------------------------------------------------------------------------
291: func StripQuote(s string) string {
292:     if len(s) > 0 && s[0] == '"' { // only double quotes around prompt with blanks in it.
293:         s = s[1:]
294:         if len(s) > 0 && s[len(s)-1] == '"' {
295:             s = s[:len(s)-1]
296:         }
297:     } else if len(s) > 0 && s[0] == '\'' { // only double quotes around prompt with blanks in it.
298:         s = s[1:]
299:         if len(s) > 0 && s[len(s)-1] == '\'' {
300:             s = s[:len(s)-1]
301:         }
302:     }
303:     return s
304: }
305: 
306: func PrintErrorJson(js string, err error) (rv string) {
307:     rv = jsonSyntaxErrorLib.GenerateSyntaxError(js, err)
308:     fmt.Printf("%s\n", rv)
309:     return
310: }
311: 
312: // KeysFromMap returns an array of keys from a map.
313: func KeysFromMap(a interface{}) (keys []string) {
314:     xkeys := reflect.ValueOf(a).MapKeys()
315:     keys = make([]string, len(xkeys))
316:     for ii, vv := range xkeys {
317:         keys[ii] = vv.String()
318:     }
319:     return
320: }
321: 
322: // GenRandBytes will generate nRandBytes of random data using the random reader.
323: func GenRandBytes(nRandBytes int) (buf []byte, err error) {
324:     buf = make([]byte, nRandBytes)
325:     _, err = rand.Read(buf)
326:     if err != nil {
327:         return nil, err
328:     }
329:     return
330: }
331: 
332: // LF Returns the File name and Line no as a string.
333: func LF(d ...int) string {
334:     depth := 1
335:     if len(d) > 0 {
336:         depth = d[0]
337:     }
338:     _, file, line, ok := runtime.Caller(depth)
339:     if ok {
340:         return fmt.Sprintf("File: %s LineNo:%d", file, line)
341:     } else {
342:         return fmt.Sprintf("File: Unk LineNo:Unk")
343:     }
344: }
345: 
346: // AppendToLog appends text to a log file.
347: func AppendToLog(filename, text string) {
348:     f, err := Fopen(filename, "a")
349:     if err != nil {
350:         fmt.Printf("Failed to open to log file:%s, error:%s\n", filename, err)
351:         return
352:     }
353:     defer f.Close()
354: 
355:     if _, err = f.WriteString(text); err != nil {
356:         fmt.Printf("Failed to write to log file:%s error:%s\n", filename, err)
357:         return
358:     }
359: }
