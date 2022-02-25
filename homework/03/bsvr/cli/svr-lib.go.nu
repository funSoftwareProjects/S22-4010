  1: package cli
  2: 
  3: import (
  4:     "fmt"
  5:     "os"
  6:     "strconv"
  7: 
  8:     "github.com/Univ-Wyo-Education/S22-4010/homework/03/bsvr/addr"
  9:     "github.com/Univ-Wyo-Education/S22-4010/homework/03/bsvr/lib"
 10: 
 11:     "github.com/pschlump/MiscLib"
 12:     "github.com/pschlump/godebug"
 13: )
 14: 
 15: // ReadGlobalData is an intialization function to read the locally stored
 16: // set of blocks and index from ./data.
 17: func (cc *CLI) ReadGlobalData(args []string) {
 18:     cc.ReadGlobalConfig()
 19: }
 20: 
 21: // ShowBalanceJSON will use the index to find an account, then walk through all the
 22: // unused outputs (the balance) and add that up.  Then it will convert this to a
 23: // JSON responce and return it.
 24: func (cc *CLI) ShowBalanceJSON(acctStr string) string {
 25:     acct, err := addr.ParseAddr(acctStr)
 26:     if err != nil {
 27:         return fmt.Sprintf("{\"status\":\"error\",\"msg\":%q}\n", err)
 28:     }
 29: 
 30:     return fmt.Sprintf("{ \"status\":\"success\", \"acct\": %q,\n  \"value\": %d }\n", acct, cc.GetTotalValueForAccount(acct))
 31: }
 32: 
 33: // ListAccounts will walk through the index and find all the accounts, construct a non-dup
 34: // list the accounts and print it out.
 35: //
 36: // Improvement - this could be split into a library function to get the accoutns and
 37: // then just print.
 38: func (cc *CLI) ListAccountsJSON() string {
 39:     // Go through index - and list out the accounts.
 40:     accts := make(map[string]bool)
 41:     for key := range cc.BlockIndex.FindValue.AddrIndex {
 42:         // fmt.Printf("Search Tx for Addr: %s\n", key)
 43:         accts[key] = true
 44:     }
 45:     for key := range cc.BlockIndex.AddrData.AddrIndex {
 46:         // fmt.Printf("Search SC for Addr: %s\n", key)
 47:         accts[key] = true
 48:     }
 49:     acctList := make([]string, 0, len(accts))
 50:     for key := range accts {
 51:         acctList = append(acctList, key)
 52:     }
 53:     return lib.SVarI(acctList)
 54: }
 55: 
 56: // SendFundsJSON will process command argumetns and walk through the transaction process
 57: // of sending funds once.  This is essentially the transaction process - but driven from
 58: // the command line.
 59: func (cc *CLI) SendFundsJSON(fromStr, toStr, amountStr, signature, msg, memo string) (jsonData string) {
 60: 
 61:     // In Assignment 5: args should be 6 - FromAddress, ToAddress, AmountToSend, Signature, MsgHash, Msg, Memo
 62:     isValid, err := cc.ValidateSignature(fromStr, signature, msg)
 63:     if err != nil {
 64:         return fmt.Sprintf("{\"status\":\"error\",\"msg\":%q}\n", err)
 65:     }
 66:     if !isValid {
 67:         return fmt.Sprintf("{\"status\":\"error\",\"msg\":%q}\n", "Signature is not valid for this account.")
 68:     }
 69: 
 70:     // -----------------------------------------------------------------------------
 71:     // Do the send funds stuff
 72:     // -----------------------------------------------------------------------------
 73:     from, err := addr.ParseAddr(fromStr)
 74:     if err != nil {
 75:         return fmt.Sprintf("{\"status\":\"error\",\"msg\":%q}\n", err)
 76:     }
 77:     to, err := addr.ParseAddr(toStr)
 78:     if err != nil {
 79:         return fmt.Sprintf("{\"status\":\"error\",\"msg\":%q}\n", err)
 80:     }
 81:     amt64, err := strconv.ParseInt(amountStr, 10, 64)
 82:     if err != nil {
 83:         fmt.Fprintf(os.Stderr, "Invalid parse of amout [%s] error [%s]\n", toStr, err)
 84:         return fmt.Sprintf("{\"status\":\"error\",\"msg\":%q}", fmt.Sprintf("Invalid parse of amout [%s] error [%s]\n", toStr, err))
 85:     }
 86:     amount := int(amt64) // type cast from int64 to int
 87:     if amount <= 0 {     // Validate that no negative amount is used.
 88:         fmt.Fprintf(os.Stderr, "Amount is out of range - can not send 0 or negative amounts [%d]\n", amount)
 89:         return fmt.Sprintf("{\"status\":\"error\",\"msg\":%q}", fmt.Sprintf("Amount is out of range - can not send 0 or negative amounts [%d]\n", amount))
 90:     }
 91: 
 92:     bk := cc.NewEmptyBlock()
 93:     lib.Assert(bk.Index == len(cc.AllBlocks))
 94: 
 95:     tx, err := cc.SendFundsTransaction(from, lib.SignatureType(signature), msg, to, amount, msg)
 96:     if err != nil {
 97:         fmt.Fprintf(os.Stderr, "Unable to transfer error [%s]\n", err)
 98:         return fmt.Sprintf("{\"status\":\"error\",\"msg\":%q}", fmt.Sprintf("Unable to transfer error [%s]\n", err))
 99:     }
100:     cc.AppendTxToBlock(bk, tx)
101: 
102:     // -----------------------------------------------------------------------------
103:     // Write out updated index and new block at end.
104:     // -----------------------------------------------------------------------------
105:     cc.AppendBlock(bk)
106: 
107:     return fmt.Sprintf("{\"status\":\"success\", \"blockNo\":%d }", bk.Index) // xyzzy other items in block, Hash, Tranaction Hash, etc.
108: }
109: 
110: func (cc *CLI) ValidateSignature(addrStr, signature, msg string) (isValid bool, err error) {
111:     addr, err := lib.ConvAddrStrToAddressType(addrStr)
112:     if err != nil {
113:         fmt.Printf("%sAT: %s - failed to convert from >%s< to address%s\n", MiscLib.ColorYellow, godebug.LF(), addrStr, MiscLib.ColorReset)
114:         return false, err
115:     }
116:     if !lib.ValidSignature(lib.SignatureType(signature), msg, addr) { // Assignment 5 implements, just true for now.
117:         fmt.Printf("%sAT: %s - signature not valid sig >%s< msg >%s<- addr %x to address%s\n", MiscLib.ColorRed, godebug.LF(), signature, msg, addr, MiscLib.ColorReset)
118:         // return nil, fmt.Errorf("Signature not valid")
119:         return false, err
120:     }
121: 
122:     isValid = true
123:     return
124: }
