// Assignment 4
// Assignment 4

package main

// Client Program
//
// Options
//		--host http://127.0.0.1:9022
//		--cmd send-funds-to --from MyAcct --to AcctTo --amount ####
//		--cmd list-accts
//		--cmd list-my-accts
//		--cmd acct-value --acct AnAcct
//		--cmd new-key-file --password <PW>
//		--help
//

import (
	"bytes"
	"crypto/rand"
	"encoding/json"
	"flag"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"net/url"
	"os"
	"path/filepath"
	"regexp"
	"strings"

	"github.com/pschlump/godebug"
)

type ConfigData struct {
	Host       string
	WalletPath string
	LoginAcct  string
	LoginPin   string
}

var GCfg ConfigData

var Cfg = flag.String("cfg", "cfg.json", "config file for this program.")
var Cmd = flag.String("cmd", "", "command to run.")
var From = flag.String("from", "", "from account.")
var To = flag.String("to", "", "to account.")
var Acct = flag.String("acct", "", "account to specify.")
var Amount = flag.Int("amount", 0, "amount of money to use in tranaction.")
var Password = flag.String("password", "", "password ot use if creating a key file.")
var Memo = flag.String("memo", "", "Memo for send funds tranaction.")

var HostWithUnPw string

func main() {
	flag.Parse() // Parse CLI arguments to this, --cfg <name>.json

	fns := flag.Args()
	if len(fns) > 0 {
		usage()
	}

	GCfg = ReadCfg(*Cfg)

	os.MkdirAll(GCfg.WalletPath, 0755)

	uP, err := url.Parse(GCfg.Host)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Unable to parse the host, error:%s\n", err)
		os.Exit(1)
	}
	uP.User = url.UserPassword(GCfg.LoginAcct, GCfg.LoginPin) // Note RFC 2396 - this is very bad security!
	HostWithUnPw = fmt.Sprintf("%s", uP)
	// fmt.Printf("HostWithUnPw= ->%s<-\n", HostWithUnPw)

	switch *Cmd {
	case "echo":
		fmt.Printf("Echo was called\n")

	case "list-accts":
		urlStr := fmt.Sprintf("%s/api/acct-list", HostWithUnPw)
		// fmt.Printf("urlStr= ->%s<-\n", urlStr)
		status, body := DoGet(urlStr)
		if status == 200 {
			fmt.Printf("Body: %s\n", body)
		} else {
			fmt.Printf("Error: %d\n", status)
		}

	case "shutdown-server":
		urlStr := fmt.Sprintf("%s/api/shutdown", HostWithUnPw)
		status, body := DoGet(urlStr)
		if status == 200 {
			fmt.Printf("Body: %s\n", body)
		} else {
			fmt.Printf("Error: %d\n", status)
		}

	case "server-status":
		urlStr := fmt.Sprintf("%s/api/status", HostWithUnPw)
		status, body := DoGet(urlStr)
		if status == 200 {
			fmt.Printf("Body: %s\n", body)
		} else {
			fmt.Printf("Error: %d\n", status)
		}

	case "acct-value":
		RequiredOption("acct", *Acct)
		urlStr := fmt.Sprintf("%s/api/acct-value", HostWithUnPw)
		// fmt.Printf("Client-AT: %s acct ->%s<-\n", godebug.LF(), *Acct)
		status, body := DoGet(urlStr, "acct", *Acct)
		if status == 200 {
			fmt.Printf("Body: %s\n", body)
		} else {
			fmt.Printf("Error: %d\n", status)
		}

	case "new-key-file":
		password := getPassphrase(*Password)
		if err := GenerateNewKeyFile(password); err != nil {
			fmt.Fprintf(os.Stderr, "Error generating KeyFile, Error:%s\n", err)
			os.Exit(1)
		}

	case "list-my-accts", "list-wallet":
		fns, _ := GetFilenames(GCfg.WalletPath)
		for _, fn := range fns {
			fmt.Printf("%s\n", fn) // TODO - clean up file name into just the "account" part.
		}

	case "validate-signed-message": // call the server with a signed message.  Verify if the message is properly signed.
		// Replace the call below with your code - call your own function.
		// InstructorValidateSignedMessage(*Acct, *Password) //SCR: Does VerifySignature play a role here, and if so, how? //Use DoGet()
		keyFile := getKeyFileFromAcct(*Acct)
		fmt.Printf("keyFile ->%s<-\n", keyFile)
		password := getPassphrase(*Password)
		buf, err := GenRandBytes(20)
		if err != nil {
			fmt.Fprintf(os.Stderr, "Error generating random data: %s\n", err)
			os.Exit(1)
		}
		msg, sig, err := GenerateSignature(keyFile, password, buf)
		if err != nil {
			fmt.Fprintf(os.Stderr, "Unable to sign message. Error:%s\n", err)
			os.Exit(1)
		}

		urlStr := fmt.Sprintf("%s/api/validate-signed-message", HostWithUnPw)
		status, body := DoGet(urlStr, "acct", *Acct, "signature", sig, "msg", msg)
		if status == 200 {
			fmt.Printf("Body: %s\n", body)
		} else {
			fmt.Printf("Error: %d\n", status)
		}

	case "send-funds-to":
		// Replace the call below with your code - call your own function.
		// InstructorSendFundsTo(*From, *To, *Password, *Memo, *Amount)
		// TODO - If the Memo parameter is "" then put in a constant memo //SCR: Is the memo parameter already passed in when this .go file triggers? If so, how do I access this? //Use DoGet()
		memo := *Memo
		if memo == "" {
			memo = "constant"
		}
		// TODO - Use 'RequiredOption' function to get from, to, amount, from command line
		RequiredOption("from", *From)
		RequiredOption("to", *To)
		RequiredOptionInt("amount", *Amount)

		// TODO - Format a JSON message to sign msg =: fmt.Sprintf(`{"from":%q, "to":%q, "amount":%d}`, From, To, Amount) //SCR: Would ReadCfg be used here?
		msg := fmt.Sprintf(`{"from":%q, "to":%q, "amount":%d}`, From, To, Amount)
		// TODO - Read in the key file for the From account using getKeyFileFromAcct
		keyFile := getKeyFileFromAcct(*From)
		// TODO - Read in a password for this using getPassphrase
		password := getPassphrase(*From)
		// TODO - Call GenerateSignature to sign the message, note the 'msg' returned is the hex version of the original message.
		msg, signature, err := GenerateSignature(keyFile, password, []byte(msg))
		// TODO - check for errros - if you can't generate a signature report an error and exit.
		if err != nil {
			log.Printf("Error generated by GenerateSignature")
		}
		// TODO - Generate the URL to send - the communication end point is /api/send-funds-to. It requires "from", "to", "amount", "signature", "msg", and "memo" parameters to be passed.
		urlStr := fmt.Sprintf(*From, *To, *Amount)
		// TODO - Call DoGet with the set of parameters
		amountStr := fmt.Sprintf("%d", Amount)
		status, body := DoGet(urlStr, "from", *From, "to", *To, "amount", amountStr, "signature", signature, "msg", msg, "memo", memo)
		if status == 200 {
			fmt.Printf("Body: %s\n", body)
		} else {
			fmt.Printf("Error: %d\n", status)
		}
		// convert Amount to a string
		//		Example: amountStr := fmt.Sprintf("%d", Amount)
		// TODO make the call using DoGet to access the server.
		//		Example: status, body := DoGet(urlStr, "from", *From, "to", *To, "amount", amountStr, "signature", signature, "msg", msg, "memo", *Memo)
		// TODO - Check the return states of the "GET" call, 200 indicates success, all other codes indicate an error
		//		if status == 200 {

	default:
		usage()
	}
}

func getKeyFileFromAcct(acct string) (keyFile string) {

	if acct[0:2] == "0x" || acct[0:2] == "0X" {
		acct = acct[2:]
	}

	fns, _ := GetFilenames(GCfg.WalletPath) // List of Files, discard any directories.
	for _, fn := range fns {
		if MatchAcctToFilename(acct, fn) {
			fmt.Printf("Match of Acct [%s] to fn [%s]\n", acct, fn)
			return filepath.Join(GCfg.WalletPath, fn)
		}
	}

	return
}

func MatchAcctToFilename(acct, fn string) bool {
	re, err := regexp.Compile(fmt.Sprintf("(?i)%s", acct)) // compare, ignore case.
	if err != nil {
		fmt.Printf("Unable to process matching of account to file name, acct [%s], fn [%s] error [%s]\n", acct, fn, err)
		os.Exit(1)
	}
	return re.MatchString(fn)
}

func RequiredOption(name, value string) {
	if value == "" {
		fmt.Fprintf(os.Stderr, "%s is a required option\n", name)
		os.Exit(1)
	}
}

func RequiredOptionInt(name string, value int) {
	if value <= 0 {
		fmt.Fprintf(os.Stderr, "%s is a required option\n", name)
		os.Exit(1)
	}
}

func ReadCfg(fn string) (rv ConfigData) {
	// Set defaults.
	rv.Host = "http://127.0.0.1:9191"
	rv.WalletPath = "./wallet-data"

	buf, err := ioutil.ReadFile(fn)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Unable to read %s Error:%s\n", fn, err)
		os.Exit(1)
	}
	err = json.Unmarshal(buf, &rv)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Invalid initialization - Unable to parse JSON file, %s\n", err)
		os.Exit(1)
	}
	return
}

// usage will print a usage message and exit.
func usage() {
	fmt.Printf("Usage: wallet-client [ --cfg file ] [ --host URL ] [ --cmd A-Command ] [ --from Acct ] [ --to Acct ] [ --amount ## ] [ --password Word ]\n")
	os.Exit(1)
}

// DoGet performs a GET operation over HTTP.
func DoGet(uri string, args ...string) (status int, rv string) {

	sep := "?"
	var qq bytes.Buffer
	qq.WriteString(uri)
	for ii := 0; ii < len(args); ii += 2 {
		// q = q + sep + name + "=" + value;
		qq.WriteString(sep)
		qq.WriteString(url.QueryEscape(args[ii]))
		qq.WriteString("=")
		if ii < len(args) {
			qq.WriteString(url.QueryEscape(args[ii+1]))
		}
		sep = "&"
	}
	url_q := qq.String()

	if db18 {
		fmt.Printf("Client-AT: %s, url=%s\n", godebug.LF(), url_q)
	}

	res, err := http.Get(url_q)
	if err != nil {
		return 500, ""
	} else {
		defer res.Body.Close()
		body, err := ioutil.ReadAll(res.Body)
		if err != nil {
			fmt.Printf("Error returnd: %s\n", err)
			return 500, ""
		}
		status = res.StatusCode
		if status == 200 {
			rv = string(body)
		}
		return
	}
}

// GenRandBytes will generate nRandBytes of random data using the random reader.
func GenRandBytes(nRandBytes int) (buf []byte, err error) {
	buf = make([]byte, nRandBytes)
	_, err = rand.Read(buf)
	if err != nil {
		return nil, err
	}
	return
}

func Exists(name string) bool {
	if _, err := os.Stat(name); err != nil {
		if os.IsNotExist(err) {
			return false
		}
	}
	return true
}

func GetFilenames(dir string) (filenames, dirs []string) {
	files, err := ioutil.ReadDir(dir)
	if err != nil {
		return nil, nil
	}
	for _, fstat := range files {
		if !strings.HasPrefix(string(fstat.Name()), ".") {
			if fstat.IsDir() {
				dirs = append(dirs, fstat.Name())
			} else {
				filenames = append(filenames, fstat.Name())
			}
		}
	}
	return
}

var db18 = true
