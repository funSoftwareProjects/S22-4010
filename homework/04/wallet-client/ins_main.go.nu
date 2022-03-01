  1: package main
  2: 
  3: import (
  4:     "fmt"
  5:     "os"
  6: 
  7:     "github.com/pschlump/godebug"
  8: )
  9: 
 10: func InstructorValidateSignedMessage(Acct, Password string) {
 11:     keyFile := getKeyFileFromAcct(Acct)
 12:     fmt.Printf("keyFile ->%s<-\n", keyFile)
 13:     password := getPassphrase(Password)
 14:     buf, err := GenRandBytes(20)
 15:     if err != nil {
 16:         fmt.Fprintf(os.Stderr, "Error generating random data: %s\n", err)
 17:         os.Exit(1)
 18:     }
 19:     msg, sig, err := GenerateSignature(keyFile, password, buf)
 20:     if err != nil {
 21:         fmt.Fprintf(os.Stderr, "Unable to sign message. Error:%s\n", err)
 22:         os.Exit(1)
 23:     }
 24: 
 25:     urlStr := fmt.Sprintf("%s/api/validate-signed-message", HostWithUnPw)
 26:     status, body := DoGet(urlStr, "acct", Acct, "signature", sig, "msg", msg)
 27:     if status == 200 {
 28:         fmt.Printf("Body: %s\n", body)
 29:     } else {
 30:         fmt.Printf("Error: %d\n", status)
 31:     }
 32: }
 33: 
 34: func InstructorSendFundsTo(From, To, Password, Memo string, Amount int) {
 35:     if Memo == "" {
 36:         Memo = "none"
 37:     }
 38: 
 39:     RequiredOption("from", From)
 40:     RequiredOption("to", To)
 41:     RequiredOptionInt("amount", Amount)
 42: 
 43:     msg := fmt.Sprintf(`{"from":%q, "to":%q, "amount":%d}`, From, To, Amount)
 44:     fmt.Printf("AT: %s raw msg ->%s<-\n", godebug.LF(), msg)
 45:     keyFile := getKeyFileFromAcct(From)
 46:     password := getPassphrase(Password)
 47:     msg, sig, err := GenerateSignature(keyFile, password, []byte(msg))
 48:     if err != nil {
 49:         fmt.Fprintf(os.Stderr, "Unable to sign message. Error:%s\n", err)
 50:         os.Exit(1)
 51:     }
 52: 
 53:     fmt.Printf("AT:%s msg ->%s<- keyFile ->%s<- password ->%s<- sig ->%s<- acct ->%s<- \n",
 54:         godebug.LF(), msg, keyFile, password, sig, From)
 55: 
 56:     // call the server with a signed message.
 57:     urlStr := fmt.Sprintf("%s/api/send-funds-to", HostWithUnPw)
 58:     amountStr := fmt.Sprintf("%d", Amount)
 59:     status, body := DoGet(urlStr, "from", From, "to", To, "amount", amountStr, "signature", sig, "msg", msg, "memo", Memo)
 60:     if status == 200 {
 61:         fmt.Printf("Body: %s\n", body)
 62:     } else {
 63:         fmt.Printf("Error: %d\n", status)
 64:     }
 65: }
