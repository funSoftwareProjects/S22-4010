  1: package cli
  2: 
  3: import (
  4:     "fmt"
  5: 
  6:     "github.com/Univ-Wyo-Education/S22-4010/homework/04/bsvr/addr"
  7:     "github.com/Univ-Wyo-Education/S22-4010/homework/04/bsvr/lib"
  8:     "github.com/Univ-Wyo-Education/S22-4010/homework/04/bsvr/transactions"
  9:     "github.com/pschlump/MiscLib"
 10:     "github.com/pschlump/godebug"
 11: )
 12: 
 13: func (cc *CLI) InstructorSendFundsTransaction(
 14:     from addr.AddressType, // account to transfer from
 15:     sig lib.SignatureType, // not used yet - ditital signature - Assignment 5
 16:     message string, //        not used yet - JSON message - Assignment 5
 17:     to addr.AddressType, //   account to send funds to
 18:     amount int, //            Amount of funds to send
 19:     memo string, //           Memo to add to transaction (Comment)
 20: ) (
 21:     tx *transactions.TransactionType,
 22:     err error,
 23: ) {
 24:     tot := cc.GetTotalValueForAccount(from)
 25:     if tot < amount {
 26:         return nil, fmt.Errorf("Insufficient funds")
 27:     }
 28:     oldOutputs := cc.GetNonZeroForAccount(from)
 29:     if db3 {
 30:         fmt.Printf("%sOld Outputs (Step 1): %s, AT:%s%s\n", MiscLib.ColorYellow, lib.SVarI(oldOutputs), godebug.LF(), MiscLib.ColorReset)
 31:     }
 32:     // remvoe inputs from index.
 33:     fromHashKey := fmt.Sprintf("%s", from)
 34:     tmp1, ok := cc.BlockIndex.FindValue.AddrIndex[fromHashKey]
 35:     if ok {
 36:         delete(cc.BlockIndex.FindValue.AddrIndex, fromHashKey)
 37:     }
 38:     tx = transactions.NewEmptyTx(memo, from)
 39:     // create inputs into tranaction from "oldOutputs"
 40:     txIn, err := transactions.CreateTxInputsFromOldOutputs(oldOutputs)
 41:     if err != nil {
 42:         cc.BlockIndex.FindValue.AddrIndex[fromHashKey] = tmp1
 43:         return nil, err
 44:     }
 45:     if db3 {
 46:         fmt.Printf("%sNew Inputs (Step 2): %s, AT:%s%s\n", MiscLib.ColorYellow, lib.SVarI(txIn), godebug.LF(), MiscLib.ColorReset)
 47:     }
 48:     tx.Input = txIn
 49:     txOut, err := transactions.CreateTxOutputWithFunds(to, amount)
 50:     if err != nil {
 51:         cc.BlockIndex.FindValue.AddrIndex[fromHashKey] = tmp1
 52:         return nil, err
 53:     }
 54:     transactions.AppendTxOutputToTx(tx, txOut)
 55:     change := tot - amount
 56:     if change > 0 {
 57:         txOut, err := transactions.CreateTxOutputWithFunds(from, change)
 58:         if err != nil {
 59:             cc.BlockIndex.FindValue.AddrIndex[fromHashKey] = tmp1
 60:             return nil, err
 61:         }
 62:         transactions.AppendTxOutputToTx(tx, txOut)
 63:     }
 64:     return
 65: }
