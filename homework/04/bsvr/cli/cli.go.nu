  1: package cli
  2: 
  3: import (
  4:     "fmt"
  5:     "os"
  6:     "path/filepath"
  7:     "strconv"
  8: 
  9:     "github.com/Univ-Wyo-Education/S22-4010/homework/04/bsvr/addr"
 10:     "github.com/Univ-Wyo-Education/S22-4010/homework/04/bsvr/block"
 11:     "github.com/Univ-Wyo-Education/S22-4010/homework/04/bsvr/config"
 12:     "github.com/Univ-Wyo-Education/S22-4010/homework/04/bsvr/hash"
 13:     "github.com/Univ-Wyo-Education/S22-4010/homework/04/bsvr/index"
 14:     "github.com/Univ-Wyo-Education/S22-4010/homework/04/bsvr/lib"
 15:     "github.com/Univ-Wyo-Education/S22-4010/homework/04/bsvr/mine"
 16:     "github.com/Univ-Wyo-Education/S22-4010/homework/04/bsvr/transactions"
 17: 
 18:     "github.com/pschlump/MiscLib"
 19:     "github.com/pschlump/godebug"
 20: )
 21: 
 22: type CLI struct {
 23:     GCfg       config.GlobalConfigData
 24:     AllBlocks  []*block.BlockType
 25:     BlockIndex index.BlockIndex
 26: }
 27: 
 28: // NewCLI  returns a new command line config.
 29: func NewCLI(c config.GlobalConfigData) *CLI {
 30:     return &CLI{
 31:         GCfg: c,
 32:     }
 33: }
 34: 
 35: // BuildIndexFileName returns the name of the index.json file
 36: // with the correct path from the configuration.
 37: func (cc *CLI) BuildIndexFileName() (fnIndexPath string) {
 38:     fnIndexPath = filepath.Join(cc.GCfg.DataDir, "index.json") //
 39:     return
 40: }
 41: 
 42: // BuildBlockFileName takes a hashStr that is the name of the JSON
 43: // file withouth the path and `.json` and combines to make a full
 44: // file name.
 45: func (cc *CLI) BuildBlockFileName(hashStr string) (fnBlockPath string) {
 46:     fnBlockPath = filepath.Join(cc.GCfg.DataDir, hashStr+".json") //
 47:     return
 48: }
 49: 
 50: // CreateGenesis creates and writes out the genesis block and the
 51: // initial index.json files.  Theis is the ""genesis"" of the
 52: // blockchain.
 53: func (cc *CLI) CreateGenesis(args []string) {
 54:     gb := block.InitGenesisBlock()
 55:     os.MkdirAll(cc.GCfg.DataDir, 0755)
 56: 
 57:     fnIndexPath := cc.BuildIndexFileName()
 58:     if lib.Exists(fnIndexPath) {
 59:         fmt.Fprintf(os.Stderr,
 60:             "Error: %s already exists - you will need to remove it if you"+
 61:                 " want to re-create a new chain.\n", fnIndexPath)
 62:         os.Exit(1)
 63:         return
 64:     }
 65: 
 66:     cc.BlockIndex = index.BuildIndex(cc.AllBlocks) // Build an initial index.
 67: 
 68:     for _, act := range cc.GCfg.InitialAccounts {
 69:         out := transactions.TxOutputType{
 70:             Account:     act.Acct,
 71:             Amount:      act.Value,
 72:             TxOutputPos: 0, //  Position of the output in this block. In the
 73:             //                     block[this].Tx[TxOffset].Output[TxOutptuPos]
 74:             // TxOffset  - will be set by AppendTxToBlock
 75:         }
 76:         tx := &transactions.TransactionType{
 77:             Output:  []transactions.TxOutputType{out},
 78:             Account: cc.GCfg.AcctCoinbase,
 79:             Comment: "Initial Balance",
 80:         }
 81:         cc.AppendTxToBlock(gb, tx)
 82:     }
 83: 
 84:     gb.ThisBlockHash = hash.HashOf(block.SerializeBlock(gb))
 85:     fn := fmt.Sprintf("%x", gb.ThisBlockHash)
 86:     fnPath := cc.BuildBlockFileName(fn)
 87:     if lib.Exists(fnPath) {
 88:         fmt.Fprintf(os.Stderr, "Error: %s already exists - you will need to remove it "+
 89:             "if you want to re-create a new chain.\n", fnPath)
 90:         os.Exit(1)
 91:         return
 92:     }
 93: 
 94:     cc.AppendBlock(gb) // Append block to list of blocks, set the index postion.  Write block and index.
 95: 
 96: }
 97: 
 98: // TestReadBlock Test code for command line.
 99: func (cc *CLI) TestReadBlock(args []string) {
100:     fnPath := cc.BuildBlockFileName("29e68e530d0718dd01759e8c9a5276d20687bc5ec23e60dce063c2b97ba6b04f")
101:     if !lib.Exists(fnPath) {
102:         fmt.Printf("You must run \"create-genesis\" first before this test.\n")
103:         os.Exit(1)
104:     }
105:     _, err := block.ReadBlock(fnPath)
106:     if err != nil {
107:         fmt.Printf("FAIL\n")
108:         os.Exit(1)
109:     }
110:     fmt.Printf("PASS\n")
111: }
112: 
113: // TestWriteBlock Test code for command line.
114: func (cc *CLI) TestWriteBlock(args []string) {
115:     // Initialize a block
116:     bk := block.InitBlock(12, "Good Morning 4010/5010 class", []byte{1, 2, 3, 4})
117:     // Write out that block
118:     err := block.WriteBlock(cc.BuildBlockFileName("TestWriteBlock"), bk)
119:     if err != nil {
120:         fmt.Printf("FAIL\n")
121:         os.Exit(1)
122:     }
123:     fmt.Printf("PASS\n")
124: }
125: 
126: // TestSendFunds will process command argumetns and walk through the transaction process
127: // of sending funds once.  This is essentially the transaction process - but driven from
128: // the command line.
129: func (cc *CLI) TestSendFunds(args []string) {
130: 
131:     // In Assignment 5: args should be 6 - FromAddress, ToAddress, AmountToSend, Signature, Msg, Memo
132:     //            Last 4 args can just be 'x' for the moment - placeholders - not checked - not used.
133:     if len(args) != 7 {
134:         fmt.Fprintf(os.Stderr, "Should have 6 argumetns after the flag.  FromAddress, ToAddress, AmountToSend, x, x, Memo\n")
135:         os.Exit(1)
136:         return
137:     }
138: 
139:     // -----------------------------------------------------------------------------
140:     // Read in index and all of the blocks.
141:     // -----------------------------------------------------------------------------
142:     cc.ReadGlobalConfig()
143: 
144:     // fmt.Printf("%sSUCCESS #1 - Read in the index and the blocks!%s\n", MiscLib.ColorGreen, MiscLib.ColorReset)
145:     // fmt.Printf("%s        #1 - AT: %s%s\n", MiscLib.ColorGreen, godebug.LF(), MiscLib.ColorReset)
146: 
147:     // -----------------------------------------------------------------------------
148:     // Do the send funds stuff
149:     // -----------------------------------------------------------------------------
150:     from := addr.MustParseAddr(args[0])
151:     to := addr.MustParseAddr(args[1])
152:     amt64, err := strconv.ParseInt(args[2], 10, 64)
153:     if err != nil {
154:         fmt.Fprintf(os.Stderr, "Invalid parse of amout [%s] error [%s]\n", args[2], err)
155:         os.Exit(1)
156:     }
157:     amount := int(amt64) // type cast from int64 to int
158:     if amount <= 0 {     // Validate that no negative amount is used.
159:         fmt.Fprintf(os.Stderr, "Amount is out of range - can not send 0 or negative amounts [%d]\n", amount)
160:         os.Exit(1)
161:     }
162: 
163:     bk := cc.NewEmptyBlock()
164:     lib.Assert(bk.Index == len(cc.AllBlocks))
165: 
166:     tx, err := cc.SendFundsTransaction(from, lib.SignatureType(args[3]), args[4], to, amount, args[5])
167:     if err != nil {
168:         fmt.Fprintf(os.Stderr, "Unable to transfer error [%s]\n", err)
169:         os.Exit(1)
170:         return
171:     }
172:     lib.Assert(tx != nil)
173:     cc.AppendTxToBlock(bk, tx)
174: 
175:     // -----------------------------------------------------------------------------
176:     // Write out updated index and new block at end.
177:     // -----------------------------------------------------------------------------
178:     cc.AppendBlock(bk)
179: 
180: }
181: 
182: // SendFundsTransaction is the core chunk of moving funds from one account to
183: // another.
184: //
185: // This is your homework.  Finish out this function and test.
186: //
187: func (cc *CLI) SendFundsTransaction(
188:     from addr.AddressType, // account to transfer from
189:     sig lib.SignatureType, // not used yet - ditital signature - Assignment 5
190:     message string, //        not used yet - JSON message - Assignment 5
191:     to addr.AddressType, //   account to send funds to
192:     amount int, //            Amount of funds to send
193:     memo string, //           Memo to add to transaction (Comment)
194: ) (
195:     tx *transactions.TransactionType,
196:     err error,
197: ) {
198: 
199:     if db3 {
200:         fmt.Printf("ATAT: %s\n", godebug.LF())
201:     }
202: 
203:     // if isValid, err := cc.InstructorValidateSignature(from, sig, message); !isValid { // addr, sig, msg string) (isValid bool, err error) {
204:     if !lib.ValidSignature(sig, message, from) { // Assignment 4 implements, just true for now.
205: 
206:         // return nil, fmt.Errorf("Signature not valid")
207:         if db8 {
208:             fmt.Printf("%sSignature is not valid - early return NIL pointer: %s, AT:%s%s\n", MiscLib.ColorYellow, godebug.LF(), MiscLib.ColorReset)
209:         }
210:         return nil, err
211:     }
212: 
213:     // fmt.Printf("ATAT: %s\n", godebug.LF())
214: 
215:     // --- Homework Section for Assignment 4 ----------------------------
216:     // Replace the line below with code that performs a transaction
217:     // return cc.InstructorSendFundsTransaction(from, sig, message, to, amount, memo)
218:     // return cc.StudentSendFundsTransaction(from, sig, message, to, amount, memo)
219: 
220:     //
221:     // Pseudo Code:
222:     // 1. Calcualte the total value of the account 'from'.  Call this 'tot'.
223:     //    You can do this by calling `cc.GetTotalValueForAccount(from)`.
224:     // 2. If the total, `tot` is less than the amount that is to be transfered,
225:     //      `amount` then fail.  Return an error "Insufficient funds".  The person
226:     //    is trying to bounce a check.
227:     // 3. Get the list of output tranactions ( ../transactions/tx.go TxOutputType ).
228:     //    Call this 'oldOutputs'.
229:     // 4. Find the set of (may be empty - check for that) values that are pointed
230:     //    to in the index - from the 'from' account.  Delete this from the
231:     //    index.
232:     // 5. Create a new empty transaction.  Call `transctions.NewEmptyTx` to create.
233:     //      Pass in the 'memo' and the 'from' for this tranaction.
234:     // 6. Convert the 'oldOutputs' into a set of new inputs.  The type is
235:     //    ../transctions/tx.go TxInputType.  Call `transactions.CreateTxInputsFromOldOutputs`
236:     //      to do this.
237:     // 7. Save the new inputs in the tx.Input.
238:     // 8. Create the new output for the 'to' address.  Call `transactions.CreateTxOutputWithFunds`.
239:     //    Call this `txOut`.    Take `txOut` and append it to the tranaction by calling
240:     //    `transactions.AppendTxOutputToTx`.
241:     // 9. Calcualte the amount of "change" - if it is larger than 0 then we owe 'from'
242:     //    change.  Create a 2nd tranaction with the change.  Append to the tranaction the
243:     //    TxOutputType.
244:     // 10. Return
245:     //
246:     tot := cc.GetTotalValueForAccount(from)
247:     if tot < amount {
248:         return nil, fmt.Errorf("Insufficient funds")
249:     }
250:     oldOutputs := cc.GetNonZeroForAccount(from)
251:     if db3 {
252:         fmt.Printf("%sOld Outputs (Step 1): %s, AT:%s%s\n", MiscLib.ColorYellow, lib.SVarI(oldOutputs), godebug.LF(), MiscLib.ColorReset)
253:     }
254:     // remvoe inputs from index.
255:     fromHashKey := fmt.Sprintf("%s", from)
256:     tmp1, ok := cc.BlockIndex.FindValue.AddrIndex[fromHashKey]
257:     if ok {
258:         delete(cc.BlockIndex.FindValue.AddrIndex, fromHashKey)
259:     }
260:     tx = transactions.NewEmptyTx(memo, from)
261:     // create inputs into tranaction from "oldOutputs"
262:     txIn, err := transactions.CreateTxInputsFromOldOutputs(oldOutputs)
263:     if err != nil {
264:         cc.BlockIndex.FindValue.AddrIndex[fromHashKey] = tmp1
265:         return nil, err
266:     }
267:     if db3 {
268:         fmt.Printf("%sNew Inputs (Step 2): %s, AT:%s%s\n", MiscLib.ColorYellow, lib.SVarI(txIn), godebug.LF(), MiscLib.ColorReset)
269:     }
270:     tx.Input = txIn
271:     txOut, err := transactions.CreateTxOutputWithFunds(to, amount)
272:     if err != nil {
273:         cc.BlockIndex.FindValue.AddrIndex[fromHashKey] = tmp1
274:         return nil, err
275:     }
276:     transactions.AppendTxOutputToTx(tx, txOut)
277:     change := tot - amount
278:     if change > 0 {
279:         txOut, err := transactions.CreateTxOutputWithFunds(from, change)
280:         if err != nil {
281:             cc.BlockIndex.FindValue.AddrIndex[fromHashKey] = tmp1
282:             return nil, err
283:         }
284:         transactions.AppendTxOutputToTx(tx, txOut)
285:     }
286:     return
287: }
288: 
289: func (cc *CLI) NewEmptyBlock() (bk *block.BlockType) {
290:     lastBlock := len(cc.AllBlocks) - 1
291:     prev := cc.AllBlocks[lastBlock].ThisBlockHash
292:     bk = block.InitBlock(len(cc.AllBlocks), "" /*block-comment-TODO*/, prev)
293:     return
294: }
295: 
296: // ListAccounts will walk through the index and find all the accounts, construct a non-dup
297: // list the accounts and print it out.
298: //
299: // Improvement - this could be split into a library function to get the accoutns and
300: // then just print.
301: func (cc *CLI) ListAccounts(args []string) {
302:     cc.ReadGlobalConfig()
303:     // Go through index - and list out the accounts.
304:     accts := make(map[string]bool)
305:     for key := range cc.BlockIndex.FindValue.AddrIndex {
306:         // fmt.Printf("Search Tx for Addr: %s\n", key)
307:         accts[key] = true
308:     }
309:     for key := range cc.BlockIndex.AddrData.AddrIndex {
310:         // fmt.Printf("Search SC for Addr: %s\n", key)
311:         accts[key] = true
312:     }
313:     fmt.Printf("\nList of Addresses\n")
314:     for key := range accts { // TODO : Should this be sorted?  If so why?
315:         fmt.Printf("\t%s\n", key)
316:     }
317: }
318: 
319: // ShowBalance will use the index to find an account, then walk through all the
320: // unused outputs (the balance) and add that up.  Then it will print out the
321: // balance for that account.
322: func (cc *CLI) ShowBalance(args []string) {
323:     cc.ReadGlobalConfig()
324: 
325:     if len(args) != 1 {
326:         fmt.Fprintf(os.Stderr, "Should have 1 argumetn after the flag.  AcctToList\n")
327:         os.Exit(1)
328:         return
329:     }
330: 
331:     acct := addr.MustParseAddr(args[0])
332: 
333:     fmt.Printf("Acct: %s Value: %d\n", acct, cc.GetTotalValueForAccount(acct))
334: }
335: 
336: // GetTotalValueForAccount walks the index finding all the non-zero tranactions for an
337: // account and adds up the total value for the account.
338: func (cc *CLI) GetTotalValueForAccount(acct addr.AddressType) (sum int) {
339: 
340:     unusedOutput := cc.BlockIndex.FindValue.AddrIndex[fmt.Sprintf("%s", acct)]
341:     // fmt.Fprintf(os.Stderr, "Acct: [%s] cc=%s AT:%s\n", acct, lib.SVarI(cc), godebug.LF())
342: 
343:     sum = 0
344:     for _, blockLoc := range unusedOutput.Value {
345:         if db4 {
346:             fmt.Fprintf(os.Stderr, "blocLoc: [%s] acct[%s] AT:%s\n", lib.SVarI(blockLoc), acct, godebug.LF())
347:         }
348: 
349:         lib.Assert(blockLoc.BlockIndex >= 0 && blockLoc.BlockIndex < len(cc.AllBlocks))
350:         bk := cc.AllBlocks[blockLoc.BlockIndex]
351: 
352:         if bk.Tx != nil {
353: 
354:             lib.Assert(blockLoc.TxOffset >= 0 && blockLoc.TxOffset < len(bk.Tx))
355:             tx := bk.Tx[blockLoc.TxOffset]
356: 
357:             if tx.Output != nil {
358: 
359:                 lib.Assert(blockLoc.TxOutputPos >= 0 && blockLoc.TxOutputPos < len(tx.Output))
360:                 out := tx.Output[blockLoc.TxOutputPos]
361: 
362:                 lib.Assert(out.Amount >= 0)
363:                 sum += out.Amount
364: 
365:                 // fmt.Printf("bottom of loop: sum=[%d] AT:%s\n", sum, godebug.LF())
366:             }
367:         }
368:     }
369: 
370:     lib.Assert(sum >= 0)
371:     return
372: }
373: 
374: // GetNonZeroForAccount returns a slice of tranactions that have a positive (Non-Zero) balance.
375: // This is the set of output tranactions that will need to be turned into input tranactions
376: // to make a funds transfer occure.
377: func (cc *CLI) GetNonZeroForAccount(acct addr.AddressType) (rv []*transactions.TxOutputType) {
378: 
379:     unusedOutput := cc.BlockIndex.FindValue.AddrIndex[fmt.Sprintf("%s", acct)]
380: 
381:     for _, blockLoc := range unusedOutput.Value {
382:         if db6 {
383:             fmt.Fprintf(os.Stderr, "blocLoc: [%s] acct[%s] AT:%s\n", lib.SVarI(blockLoc), acct, godebug.LF())
384:         }
385: 
386:         lib.Assert(blockLoc.BlockIndex >= 0 && blockLoc.BlockIndex < len(cc.AllBlocks))
387:         bk := cc.AllBlocks[blockLoc.BlockIndex]
388: 
389:         if bk.Tx != nil {
390: 
391:             lib.Assert(blockLoc.TxOffset >= 0 && blockLoc.TxOffset < len(bk.Tx))
392:             tx := bk.Tx[blockLoc.TxOffset]
393: 
394:             if tx.Output != nil {
395: 
396:                 lib.Assert(blockLoc.TxOutputPos >= 0 && blockLoc.TxOutputPos < len(tx.Output))
397:                 out := tx.Output[blockLoc.TxOutputPos]
398: 
399:                 if out.Amount > 0 {
400:                     rv = append(rv, &out)
401:                 }
402:             }
403:         }
404:     }
405: 
406:     return
407: }
408: 
409: // AppendTxToBlock takes a transaction and appends it to the set of transactions in the
410: // block.  TxOffset values for transaction outputs have to be set.  The BlockNo is
411: // also set to the current blocks.  If the list of addresses,
412: // cc.BLockIndex.FindValue.AddrIndex is nil then the map is allocated.
413: func (cc *CLI) AppendTxToBlock(bk *block.BlockType, tx *transactions.TransactionType) {
414:     Offset := len(bk.Tx)
415:     tx.TxOffset = Offset
416:     for ii := range tx.Output {
417:         tx.Output[ii].BlockNo = bk.Index
418:         tx.Output[ii].TxOffset = Offset
419:     }
420:     bk.Tx = append(bk.Tx, tx)
421: 
422:     if cc.BlockIndex.FindValue.AddrIndex == nil {
423:         // fmt.Printf("Allocate space for: cc.BlockIndex.FindValue.AddrIndex, AT: %s\n", godebug.LF())
424:         cc.BlockIndex.FindValue.AddrIndex = make(map[string]index.TxWithValue)
425:     }
426: 
427:     // --------------------------------------------------------------------------------
428:     // Check to see if existing value exists in account.
429:     // --------------------------------------------------------------------------------
430:     hashKey := fmt.Sprintf("%s", tx.Account)
431:     _, hasValueNow := cc.BlockIndex.FindValue.AddrIndex[hashKey]
432:     if db2 {
433:         fmt.Printf("Append: hasValueNow = %v, AT:%s\n", hasValueNow, godebug.LF())
434:     }
435: 
436:     // Find all outputs - add them to index
437:     for ii, out := range tx.Output {
438: 
439:         aTxWithValue := index.TxWithValue{
440:             Addr: out.Account, // Address of destination account for output
441:             Value: []index.TxWithAValue{{
442:                 BlockIndex:  bk.Index,
443:                 TxOffset:    Offset, // position of this Tx in the array of Tx in the block, this is in block.Tx[TxOffset]
444:                 TxOutputPos: ii,     // positon of the output with a positive value in the transaction, block.Tx[TxOffset].Output[TxOutputPos]
445:             }}, // List of Values in a set of blocks, may have more than one value per block.
446:         }
447: 
448:         hashKey := fmt.Sprintf("%s", out.Account)
449:         if val, has := cc.BlockIndex.FindValue.AddrIndex[hashKey]; has {
450:             for _, av := range aTxWithValue.Value {
451:                 val.Value = append(val.Value, av)
452:                 cc.BlockIndex.FindValue.AddrIndex[hashKey] = val
453:             }
454:         } else {
455:             cc.BlockIndex.FindValue.AddrIndex[hashKey] = aTxWithValue
456:         }
457:     }
458: }
459: 
460: // ReadGlobalConfig reads in the index and all of the blocks.
461: func (cc *CLI) ReadGlobalConfig() {
462: 
463:     // -------------------------------------------------------------------------------
464:     // Read in index and blocks.
465:     // -------------------------------------------------------------------------------
466: 
467:     // Read in index so that we know what all the hashs for the blocks are.
468:     fnIndexPath := cc.BuildIndexFileName()          //
469:     BlockIndex, err := index.ReadIndex(fnIndexPath) //
470:     if err != nil {
471:         fmt.Fprintf(os.Stderr, "Error reading index [%s] error [%s]\n", fnIndexPath, err)
472:         os.Exit(1)
473:     }
474:     cc.BlockIndex = *BlockIndex
475: 
476:     if db5 {
477:         fmt.Fprintf(os.Stderr, "dbg: AT: %s ->%s<-\n", godebug.LF(), cc.BlockIndex.Index)
478:     }
479:     for ii, key := range cc.BlockIndex.Index {
480:         // fmt.Printf("dbg: AT: %s ->%s<-\n", godebug.LF(), key)
481:         fnBlock := cc.BuildBlockFileName(key) // take the key, hash of block as a string, and generate file name.
482:         aBk, err := block.ReadBlock(fnBlock)
483:         if err != nil {
484:             fmt.Fprintf(os.Stderr, "Error reading block [%s] error [%s]\n", fnBlock, err)
485:             os.Exit(1)
486:         }
487:         lib.Assert(aBk.Index == ii)
488:         cc.AllBlocks = append(cc.AllBlocks, aBk)
489:         if db5 {
490:             fmt.Fprintf(os.Stderr, "Read In ii=%d Block[%d] Hash[%x]\n", ii, aBk.Index, aBk.ThisBlockHash)
491:         }
492:     }
493: }
494: 
495: // AppendBlock appends a new block to the set of blocks in the blockchain.
496: // The block mining reward will be added as the last transaction in the block.
497: // Mining will be performed to seal the block.  The block will be written
498: // out to the file system and the index of blocks is updated.  Verification
499: // occures that the block has produced a unique hash.  (Hash Collisions
500: // are possible but very rare - It would be simple to add a fix so that if
501: // you get a collision it fixes it.  This has not been done).
502: func (cc *CLI) AppendBlock(bk *block.BlockType) {
503:     bk.Index = len(cc.AllBlocks)
504: 
505:     // -------------------------------------------------------------------------------
506:     // add in Tx for mining reward
507:     // -------------------------------------------------------------------------------
508:     tx := transactions.NewEmptyTx("Mining Reward", cc.GCfg.AcctCoinbase)
509:     txOut, err := transactions.CreateTxOutputWithFunds(cc.GCfg.AcctCoinbase, cc.GCfg.MiningReward)
510:     if err != nil {
511:         fmt.Fprintf(os.Stderr, "Unable to supply mining reward error [%s]\n", err)
512:         os.Exit(1)
513:         return
514:     }
515:     transactions.AppendTxOutputToTx(tx, txOut)
516:     cc.AppendTxToBlock(bk, tx)
517: 
518:     // -------------------------------------------------------------------------------
519:     // Calculate hash for block now that the transactions are complete.
520:     // -------------------------------------------------------------------------------
521:     if db1 {
522:         hd := block.SerializeBlock(bk)
523:         fmt.Printf("Searilized Block: %x\n", hd)
524:     }
525:     bk.ThisBlockHash = hash.HashOf(block.SerializeBlock(bk))
526: 
527:     if db6 {
528:         fmt.Printf("%sbk.ThisBlockHash = %x, AT:%s%s\n", MiscLib.ColorCyan, bk.ThisBlockHash,
529:             godebug.LF(), MiscLib.ColorReset)
530:     }
531: 
532:     // Verify hash is unique - never seen before.
533:     if _, ok := cc.BlockIndex.BlockHashToIndex[fmt.Sprintf("%x", bk.ThisBlockHash)]; ok {
534:         lib.Assert(false)
535:     }
536: 
537:     // -------------------------------------------------------------------------------
538:     // Mine the block
539:     // -------------------------------------------------------------------------------
540:     mine.MineBlock(bk, cc.GCfg.MiningDifficulty)
541: 
542:     // -------------------------------------------------------------------------------
543:     // Update the block index - this is the hard part.
544:     // -------------------------------------------------------------------------------
545:     cc.BlockIndex.Index = append(cc.BlockIndex.Index, fmt.Sprintf("%x", bk.ThisBlockHash))
546:     if cc.BlockIndex.BlockHashToIndex == nil {
547:         cc.BlockIndex.BlockHashToIndex = make(map[string]int)
548:     }
549:     cc.BlockIndex.BlockHashToIndex[fmt.Sprintf("%x", bk.ThisBlockHash)] = bk.Index
550:     cc.AllBlocks = append(cc.AllBlocks, bk) // put in set of global blocks:
551: 
552:     // -------------------------------------------------------------------------------
553:     // Write out both the block and the updated index.
554:     // -------------------------------------------------------------------------------
555:     fnPath := cc.BuildBlockFileName(fmt.Sprintf("%x", bk.ThisBlockHash))
556:     fnIndexPath := cc.BuildIndexFileName()
557:     err = index.WriteIndex(fnIndexPath, &cc.BlockIndex) // write index
558:     if err != nil {
559:         fmt.Fprintf(os.Stderr, "Unable to write index to [%s] error [%s]\n", fnIndexPath, err)
560:         os.Exit(1)
561:         return
562:     }
563:     err = block.WriteBlock(fnPath, bk)
564:     if err != nil {
565:         fmt.Fprintf(os.Stderr, "Unable to write block to [%s] error [%s]\n", fnPath, err)
566:         os.Exit(1)
567:         return
568:     }
569: }
570: 
571: // Debug flags to turn on output in sections of the code.
572: const db1 = false
573: const db2 = false
574: const db3 = true // may also want db8 to be true - prints on invalid signature
575: const db4 = false
576: const db5 = false
577: const db6 = false
578: const db8 = true
