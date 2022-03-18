package main

// Copyright (c) Philip Schlump 2014.
// MIT Licensed.

// The MIT License (MIT)
//
// Copyright (C) 2014 Philip Schlump, 2014-Present
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

// Simple HTTP server

import (
	"encoding/json"
	"flag"
	"fmt"
	"io"
	"log"
	"net/http"
	"os"
)

var Dir string
var Port string

var optDir = flag.String("dir", "./www", "Directory to serve files from.")
var optPort = flag.String("port", ":8765", "host:port or just :port for localhost:port")

func init() {
	flag.StringVar(optPort, "p", ":8765", "host:port or just :port for localhost:port")
	flag.StringVar(optDir, "d", "./www", "Directory to serve files from.")
}

// SVar will convert the passed data to JSON
func SVar(v interface{}) string {
	s, err := json.Marshal(v)
	// s, err := json.MarshalIndent ( v, "", "\t" )
	if err != nil {
		return fmt.Sprintf("Error:%s", err)
	} else {
		return string(s)
	}
}

// SVarI will convert the passed data to JSON and pretty print the JSON.
func SVarI(v interface{}) string {
	// s, err := json.Marshal ( v )
	s, err := json.MarshalIndent(v, "", "\t")
	if err != nil {
		return fmt.Sprintf("Error:%s", err)
	} else {
		return string(s)
	}
}

// RespHandlerStatus reports a JSON status.
func RespHandlerStatus(www http.ResponseWriter, req *http.Request) {
	q := req.RequestURI

	var rv string
	www.Header().Set("Content-Type", "application/json; charset=utf-8")
	rv = fmt.Sprintf(`{"status":"success","name":"go-server version 1.0.0","URI":%q,"req":%s, "response_header":%s}`, q, SVarI(req), SVarI(www.Header()))

	io.WriteString(www, rv)
}

// main - entry point.
func main() {
	flag.Parse()

	fns := flag.Args()

	_ = fns // Discard.
	Dir = *optDir
	Port = *optPort
	if Dir == "." {
		Dir, _ = os.Getwd()
	}

	http.HandleFunc("/api/status", RespHandlerStatus)
	http.Handle("/", http.FileServer(http.Dir(Dir)))
	log.Fatal(http.ListenAndServe(Port, nil))
}
