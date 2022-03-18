  1: package main
  2: 
  3: // Copyright (c) Philip Schlump 2014.
  4: // MIT Licensed.
  5: 
  6: // The MIT License (MIT)
  7: //
  8: // Copyright (C) 2014 Philip Schlump, 2014-Present
  9: //
 10: // Permission is hereby granted, free of charge, to any person obtaining a copy
 11: // of this software and associated documentation files (the "Software"), to deal
 12: // in the Software without restriction, including without limitation the rights
 13: // to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 14: // copies of the Software, and to permit persons to whom the Software is
 15: // furnished to do so, subject to the following conditions:
 16: //
 17: // The above copyright notice and this permission notice shall be included in all
 18: // copies or substantial portions of the Software.
 19: //
 20: // THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 21: // IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 22: // FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 23: // AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 24: // LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 25: // OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 26: // SOFTWARE.
 27: 
 28: // Simple HTTP server
 29: 
 30: import (
 31:     "encoding/json"
 32:     "flag"
 33:     "fmt"
 34:     "io"
 35:     "log"
 36:     "net/http"
 37:     "os"
 38: )
 39: 
 40: var Dir string
 41: var Port string
 42: 
 43: var optDir = flag.String("dir", "./www", "Directory to serve files from.")
 44: var optPort = flag.String("port", ":8765", "host:port or just :port for localhost:port")
 45: 
 46: func init() {
 47:     flag.StringVar(optPort, "p", ":8765", "host:port or just :port for localhost:port")
 48:     flag.StringVar(optDir, "d", "./www", "Directory to serve files from.")
 49: }
 50: 
 51: // SVar will convert the passed data to JSON
 52: func SVar(v interface{}) string {
 53:     s, err := json.Marshal(v)
 54:     // s, err := json.MarshalIndent ( v, "", "\t" )
 55:     if err != nil {
 56:         return fmt.Sprintf("Error:%s", err)
 57:     } else {
 58:         return string(s)
 59:     }
 60: }
 61: 
 62: // SVarI will convert the passed data to JSON and pretty print the JSON.
 63: func SVarI(v interface{}) string {
 64:     // s, err := json.Marshal ( v )
 65:     s, err := json.MarshalIndent(v, "", "\t")
 66:     if err != nil {
 67:         return fmt.Sprintf("Error:%s", err)
 68:     } else {
 69:         return string(s)
 70:     }
 71: }
 72: 
 73: // RespHandlerStatus reports a JSON status.
 74: func RespHandlerStatus(www http.ResponseWriter, req *http.Request) {
 75:     q := req.RequestURI
 76: 
 77:     var rv string
 78:     www.Header().Set("Content-Type", "application/json; charset=utf-8")
 79:     rv = fmt.Sprintf(`{"status":"success","name":"go-server version 1.0.0","URI":%q,"req":%s, "response_header":%s}`, q, SVarI(req), SVarI(www.Header()))
 80: 
 81:     io.WriteString(www, rv)
 82: }
 83: 
 84: // main - entry point.
 85: func main() {
 86:     flag.Parse()
 87: 
 88:     fns := flag.Args()
 89: 
 90:     _ = fns // Discard.
 91:     Dir = *optDir
 92:     Port = *optPort
 93:     if Dir == "." {
 94:         Dir, _ = os.Getwd()
 95:     }
 96: 
 97:     http.HandleFunc("/api/status", RespHandlerStatus)
 98:     http.Handle("/", http.FileServer(http.Dir(Dir)))
 99:     log.Fatal(http.ListenAndServe(Port, nil))
100: }
