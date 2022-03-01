  1: package cli
  2: 
  3: import (
  4:     "fmt"
  5:     "os"
  6:     "path/filepath"
  7:     "strconv"
  8: 
  9:     "github.com/Univ-Wyo-Education/S22-4010/homework/03/bsvr/addr"
 10:     "github.com/Univ-Wyo-Education/S22-4010/homework/03/bsvr/block"
 11:     "github.com/Univ-Wyo-Education/S22-4010/homework/03/bsvr/config"
 12:     "github.com/Univ-Wyo-Education/S22-4010/homework/03/bsvr/hash"
 13:     "github.com/Univ-Wyo-Education/S22-4010/homework/03/bsvr/index"
 14:     "github.com/Univ-Wyo-Education/S22-4010/homework/03/bsvr/lib"
 15:     "github.com/Univ-Wyo-Education/S22-4010/homework/03/bsvr/mine"
 16:     "github.com/Univ-Wyo-Education/S22-4010/homework/03/bsvr/transactions"
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
199:     fmt.Printf("ATAT: %s\n", godebug.LF())
200: 
201:     //    if isValid, err := cc.InstructorValidateSignature(from, sig, message); !isValid { // addr, sig, msg string) (isValid bool, err error) {
202:     if !lib.ValidSignature(sig, message, from) { // Assignment 5 implements, just true for now.
203:         // return nil, fmt.Errorf("Signature not valid")
204:         return nil, err
205:     }
206: 
207:     // fmt.Printf("ATAT: %s\n", godebug.LF())
208: 
209:     // --- Homework Section for Assignment 4 ----------------------------
210:     // Replace the line below with code that performs a transaction
211:     // return cc.InstructorSendFundsTransaction(from, sig, message, to, amount, memo)
212:     // return cc.StudentSendFundsTransaction(from, sig, message, to, amount, memo)
213: 
214:     //
215:     // Pseudo Code:
216:     // 1. Calcualte the total value of the account 'from'.  Call this 'tot'.
217:     //    You can do this by calling `cc.GetTotalValueForAccount(from)`.
218:     // 2. If the total, `tot` is less than the amount that is to be transfered,
219:     //      `amount` then fail.  Return an error "Insufficient funds".  The person
220:     //    is trying to bounce a check.
221:     // 3. Get the list of output tranactions ( ../transactions/tx.go TxOutputType ).
222:     //    Call this 'oldOutputs'.
223:     // 4. Find the set of (may be empty - check for that) values that are pointed
224:     //    to in the index - from the 'from' account.  Delete this from the
225:     //    index.
226:     // 5. Create a new empty transaction.  Call `transctions.NewEmptyTx` to create.
227:     //      Pass in the 'memo' and the 'from' for this tranaction.
228:     // 6. Convert the 'oldOutputs' into a set of new inputs.  The type is
229:     //    ../transctions/tx.go TxInputType.  Call `transactions.CreateTxInputsFromOldOutputs`
230:     //      to do this.
231:     // 7. Save the new inputs in the tx.Input.
232:     // 8. Create the new output for the 'to' address.  Call `transactions.CreateTxOutputWithFunds`.
233:     //    Call this `txOut`.    Take `txOut` and append it to the tranaction by calling
234:     //    `transactions.AppendTxOutputToTx`.
235:     // 9. Calcualte the amount of "change" - if it is larger than 0 then we owe 'from'
236:     //    change.  Create a 2nd tranaction with the change.  Append to the tranaction the
237:     //    TxOutputType.
238:     // 10. Return
239:     //
240:     tot := cc.GetTotalValueForAccount(from)
241:     if tot < amount {
242:         return nil, fmt.Errorf("Insufficient funds")
243:     }
244:     oldOutputs := cc.GetNonZeroForAccount(from)
245:     if db3 {
246:         fmt.Printf("%sOld Outputs (Step 1): %s, AT:%s%s\n", MiscLib.ColorYellow, lib.SVarI(oldOutputs), godebug.LF(), MiscLib.ColorReset)
247:     }
248:     // remvoe inputs from index.
249:     fromHashKey := fmt.Sprintf("%s", from)
250:     tmp1, ok := cc.BlockIndex.FindValue.AddrIndex[fromHashKey]
251:     if ok {
252:         delete(cc.BlockIndex.FindValue.AddrIndex, fromHashKey)
253:     }
254:     tx = transactions.NewEmptyTx(memo, from)
255:     // create inputs into tranaction from "oldOutputs"
256:     txIn, err := transactions.CreateTxInputsFromOldOutputs(oldOutputs)
257:     if err != nil {
258:         cc.BlockIndex.FindValue.AddrIndex[fromHashKey] = tmp1
259:         return nil, err
260:     }
261:     if db3 {
262:         fmt.Printf("%sNew Inputs (Step 2): %s, AT:%s%s\n", MiscLib.ColorYellow, lib.SVarI(txIn), godebug.LF(), MiscLib.ColorReset)
263:     }
264:     tx.Input = txIn
265:     txOut, err := transactions.CreateTxOutputWithFunds(to, amount)
266:     if err != nil {
267:         cc.BlockIndex.FindValue.AddrIndex[fromHashKey] = tmp1
268:         return nil, err
269:     }
270:     transactions.AppendTxOutputToTx(tx, txOut)
271:     change := tot - amount
272:     if change > 0 {
273:         txOut, err := transactions.CreateTxOutputWithFunds(from, change)
274:         if err != nil {
275:             cc.BlockIndex.FindValue.AddrIndex[fromHashKey] = tmp1
276:             return nil, err
277:         }
278:         transactions.AppendTxOutputToTx(tx, txOut)
279:     }
280:     return
281: }
282: 
283: func (cc *CLI) NewEmptyBlock() (bk *block.BlockType) {
284:     lastBlock := len(cc.AllBlocks) - 1
285:     prev := cc.AllBlocks[lastBlock].ThisBlockHash
286:     bk = block.InitBlock(len(cc.AllBlocks), "" /*block-comment-TODO*/, prev)
287:     return
288: }
289: 
290: // ListAccounts will walk through the index and find all the accounts, construct a non-dup
291: // list the accounts and print it out.
292: //
293: // Improvement - this could be split into a library function to get the accoutns and
294: // then just print.
295: func (cc *CLI) ListAccounts(args []string) {
296:     cc.ReadGlobalConfig()
297:     // Go through index - and list out the accounts.
298:     accts := make(map[string]bool)
299:     for key := range cc.BlockIndex.FindValue.AddrIndex {
300:         // fmt.Printf("Search Tx for Addr: %s\n", key)
301:         accts[key] = true
302:     }
303:     for key := range cc.BlockIndex.AddrData.AddrIndex {
304:         // fmt.Printf("Search SC for Addr: %s\n", key)
305:         accts[key] = true
306:     }
307:     fmt.Printf("\nList of Addresses\n")
308:     for key := range accts { // TODO : Should this be sorted?  If so why?
309:         fmt.Printf("\t%s\n", key)
310:     }
311: }
312: 
313: // ShowBalance will use the index to find an account, then walk through all the
314: // unused outputs (the balance) and add that up.  Then it will print out the
315: // balance for that account.
316: func (cc *CLI) ShowBalance(args []string) {
317:     cc.ReadGlobalConfig()
318: 
319:     if len(args) != 1 {
320:         fmt.Fprintf(os.Stderr, "Should have 1 argumetn after the flag.  AcctToList\n")
321:         os.Exit(1)
322:         return
323:     }
324: 
325:     acct := addr.MustParseAddr(args[0])
326: 
327:     fmt.Printf("Acct: %s Value: %d\n", acct, cc.GetTotalValueForAccount(acct))
328: }
329: 
330: // GetTotalValueForAccount walks the index finding all the non-zero tranactions for an
331: // account and adds up the total value for the account.
332: func (cc *CLI) GetTotalValueForAccount(acct addr.AddressType) (sum int) {
333: 
334:     unusedOutput := cc.BlockIndex.FindValue.AddrIndex[fmt.Sprintf("%s", acct)]
335:     // fmt.Fprintf(os.Stderr, "Acct: [%s] cc=%s AT:%s\n", acct, lib.SVarI(cc), godebug.LF())
336: 
337:     sum = 0
338:     for _, blockLoc := range unusedOutput.Value {
339:         if db4 {
340:             fmt.Fprintf(os.Stderr, "blocLoc: [%s] acct[%s] AT:%s\n", lib.SVarI(blockLoc), acct, godebug.LF())
341:         }
342: 
343:         lib.Assert(blockLoc.BlockIndex >= 0 && blockLoc.BlockIndex < len(cc.AllBlocks))
344:         bk := cc.AllBlocks[blockLoc.BlockIndex]
345: 
346:         if bk.Tx != nil {
347: 
348:             lib.Assert(blockLoc.TxOffset >= 0 && blockLoc.TxOffset < len(bk.Tx))
349:             tx := bk.Tx[blockLoc.TxOffset]
350: 
351:             if tx.Output != nil {
352: 
353:                 lib.Assert(blockLoc.TxOutputPos >= 0 && blockLoc.TxOutputPos < len(tx.Output))
354:                 out := tx.Output[blockLoc.TxOutputPos]
355: 
356:                 lib.Assert(out.Amount >= 0)
357:                 sum += out.Amount
358: 
359:                 // fmt.Printf("bottom of loop: sum=[%d] AT:%s\n", sum, godebug.LF())
360:             }
361:         }
362:     }
363: 
364:     lib.Assert(sum >= 0)
365:     return
366: }
367: 
368: // GetNonZeroForAccount returns a slice of tranactions that have a positive (Non-Zero) balance.
369: // This is the set of output tranactions that will need to be turned into input tranactions
370: // to make a funds transfer occure.
371: func (cc *CLI) GetNonZeroForAccount(acct addr.AddressType) (rv []*transactions.TxOutputType) {
372: 
373:     unusedOutput := cc.BlockIndex.FindValue.AddrIndex[fmt.Sprintf("%s", acct)]
374: 
375:     for _, blockLoc := range unusedOutput.Value {
376:         if db6 {
377:             fmt.Fprintf(os.Stderr, "blocLoc: [%s] acct[%s] AT:%s\n", lib.SVarI(blockLoc), acct, godebug.LF())
378:         }
379: 
380:         lib.Assert(blockLoc.BlockIndex >= 0 && blockLoc.BlockIndex < len(cc.AllBlocks))
381:         bk := cc.AllBlocks[blockLoc.BlockIndex]
382: 
383:         if bk.Tx != nil {
384: 
385:             lib.Assert(blockLoc.TxOffset >= 0 && blockLoc.TxOffset < len(bk.Tx))
386:             tx := bk.Tx[blockLoc.TxOffset]
387: 
388:             if tx.Output != nil {
389: 
390:                 lib.Assert(blockLoc.TxOutputPos >= 0 && blockLoc.TxOutputPos < len(tx.Output))
391:                 out := tx.Output[blockLoc.TxOutputPos]
392: 
393:                 if out.Amount > 0 {
394:                     rv = append(rv, &out)
395:                 }
396:             }
397:         }
398:     }
399: 
400:     return
401: }
402: 
403: // AppendTxToBlock takes a transaction and appends it to the set of transactions in the
404: // block.  TxOffset values for transaction outputs have to be set.  The BlockNo is
405: // also set to the current blocks.  If the list of addresses,
406: // cc.BLockIndex.FindValue.AddrIndex is nil then the map is allocated.
407: func (cc *CLI) AppendTxToBlock(bk *block.BlockType, tx *transactions.TransactionType) {
408:     Offset := len(bk.Tx)
409:     tx.TxOffset = Offset
410:     for ii := range tx.Output {
411:         tx.Output[ii].BlockNo = bk.Index
412:         tx.Output[ii].TxOffset = Offset
413:     }
414:     bk.Tx = append(bk.Tx, tx)
415: 
416:     if cc.BlockIndex.FindValue.AddrIndex == nil {
417:         // fmt.Printf("Allocate space for: cc.BlockIndex.FindValue.AddrIndex, AT: %s\n", godebug.LF())
418:         cc.BlockIndex.FindValue.AddrIndex = make(map[string]index.TxWithValue)
419:     }
420: 
421:     // --------------------------------------------------------------------------------
422:     // Check to see if existing value exists in account.
423:     // --------------------------------------------------------------------------------
424:     hashKey := fmt.Sprintf("%s", tx.Account)
425:     _, hasValueNow := cc.BlockIndex.FindValue.AddrIndex[hashKey]
426:     if db2 {
427:         fmt.Printf("Append: hasValueNow = %v, AT:%s\n", hasValueNow, godebug.LF())
428:     }
429: 
430:     // Find all outputs - add them to index
431:     for ii, out := range tx.Output {
432: 
433:         aTxWithValue := index.TxWithValue{
434:             Addr: out.Account, // Address of destination account for output
435:             Value: []index.TxWithAValue{{
436:                 BlockIndex:  bk.Index,
437:                 TxOffset:    Offset, // position of this Tx in the array of Tx in the block, this is in block.Tx[TxOffset]
438:                 TxOutputPos: ii,     // positon of the output with a positive value in the transaction, block.Tx[TxOffset].Output[TxOutputPos]
439:             }}, // List of Values in a set of blocks, may have more than one value per block.
440:         }
441: 
442:         hashKey := fmt.Sprintf("%s", out.Account)
443:         if val, has := cc.BlockIndex.FindValue.AddrIndex[hashKey]; has {
444:             for _, av := range aTxWithValue.Value {
445:                 val.Value = append(val.Value, av)
446:                 cc.BlockIndex.FindValue.AddrIndex[hashKey] = val
447:             }
448:         } else {
449:             cc.BlockIndex.FindValue.AddrIndex[hashKey] = aTxWithValue
450:         }
451:     }
452: }
453: 
454: // ReadGlobalConfig reads in the index and all of the blocks.
455: func (cc *CLI) ReadGlobalConfig() {
456: 
457:     // -------------------------------------------------------------------------------
458:     // Read in index and blocks.
459:     // -------------------------------------------------------------------------------
460: 
461:     // Read in index so that we know what all the hashs for the blocks are.
462:     fnIndexPath := cc.BuildIndexFileName()          //
463:     BlockIndex, err := index.ReadIndex(fnIndexPath) //
464:     if err != nil {
465:         fmt.Fprintf(os.Stderr, "Error reading index [%s] error [%s]\n", fnIndexPath, err)
466:         os.Exit(1)
467:     }
468:     cc.BlockIndex = *BlockIndex
469: 
470:     if db5 {
471:         fmt.Fprintf(os.Stderr, "dbg: AT: %s ->%s<-\n", godebug.LF(), cc.BlockIndex.Index)
472:     }
473:     for ii, key := range cc.BlockIndex.Index {
474:         // fmt.Printf("dbg: AT: %s ->%s<-\n", godebug.LF(), key)
475:         fnBlock := cc.BuildBlockFileName(key) // take the key, hash of block as a string, and generate file name.
476:         aBk, err := block.ReadBlock(fnBlock)
477:         if err != nil {
478:             fmt.Fprintf(os.Stderr, "Error reading block [%s] error [%s]\n", fnBlock, err)
479:             os.Exit(1)
480:         }
481:         lib.Assert(aBk.Index == ii)
482:         cc.AllBlocks = append(cc.AllBlocks, aBk)
483:         if db5 {
484:             fmt.Fprintf(os.Stderr, "Read In ii=%d Block[%d] Hash[%x]\n", ii, aBk.Index, aBk.ThisBlockHash)
485:         }
486:     }
487: }
488: 
489: // AppendBlock appends a new block to the set of blocks in the blockchain.
490: // The block mining reward will be added as the last transaction in the block.
491: // Mining will be performed to seal the block.  The block will be written
492: // out to the file system and the index of blocks is updated.  Verification
493: // occures that the block has produced a unique hash.  (Hash Collisions
494: // are possible but very rare - It would be simple to add a fix so that if
495: // you get a collision it fixes it.  This has not been done).
496: func (cc *CLI) AppendBlock(bk *block.BlockType) {
497:     bk.Index = len(cc.AllBlocks)
498: 
499:     // -------------------------------------------------------------------------------
500:     // add in Tx for mining reward
501:     // -------------------------------------------------------------------------------
502:     tx := transactions.NewEmptyTx("Mining Reward", cc.GCfg.AcctCoinbase)
503:     txOut, err := transactions.CreateTxOutputWithFunds(cc.GCfg.AcctCoinbase, cc.GCfg.MiningReward)
504:     if err != nil {
505:         fmt.Fprintf(os.Stderr, "Unable to supply mining reward error [%s]\n", err)
506:         os.Exit(1)
507:         return
508:     }
509:     transactions.AppendTxOutputToTx(tx, txOut)
510:     cc.AppendTxToBlock(bk, tx)
511: 
512:     // -------------------------------------------------------------------------------
513:     // Calculate hash for block now that the transactions are complete.
514:     // -------------------------------------------------------------------------------
515:     if db1 {
516:         hd := block.SerializeBlock(bk)
517:         fmt.Printf("Searilized Block: %x\n", hd)
518:     }
519:     bk.ThisBlockHash = hash.HashOf(block.SerializeBlock(bk))
520: 
521:     if db6 {
522:         fmt.Printf("%sbk.ThisBlockHash = %x, AT:%s%s\n", MiscLib.ColorCyan, bk.ThisBlockHash,
523:             godebug.LF(), MiscLib.ColorReset)
524:     }
525: 
526:     // Verify hash is unique - never seen before.
527:     if _, ok := cc.BlockIndex.BlockHashToIndex[fmt.Sprintf("%x", bk.ThisBlockHash)]; ok {
528:         lib.Assert(false)
529:     }
530: 
531:     // -------------------------------------------------------------------------------
532:     // Mine the block
533:     // -------------------------------------------------------------------------------
534:     mine.MineBlock(bk, cc.GCfg.MiningDifficulty)
535: 
536:     // -------------------------------------------------------------------------------
537:     // Update the block index - this is the hard part.
538:     // -------------------------------------------------------------------------------
539:     cc.BlockIndex.Index = append(cc.BlockIndex.Index, fmt.Sprintf("%x", bk.ThisBlockHash))
540:     if cc.BlockIndex.BlockHashToIndex == nil {
541:         cc.BlockIndex.BlockHashToIndex = make(map[string]int)
542:     }
543:     cc.BlockIndex.BlockHashToIndex[fmt.Sprintf("%x", bk.ThisBlockHash)] = bk.Index
544:     cc.AllBlocks = append(cc.AllBlocks, bk) // put in set of global blocks:
545: 
546:     // -------------------------------------------------------------------------------
547:     // Write out both the block and the updated index.
548:     // -------------------------------------------------------------------------------
549:     fnPath := cc.BuildBlockFileName(fmt.Sprintf("%x", bk.ThisBlockHash))
550:     fnIndexPath := cc.BuildIndexFileName()
551:     err = index.WriteIndex(fnIndexPath, &cc.BlockIndex) // write index
552:     if err != nil {
553:         fmt.Fprintf(os.Stderr, "Unable to write index to [%s] error [%s]\n", fnIndexPath, err)
554:         os.Exit(1)
555:         return
556:     }
557:     err = block.WriteBlock(fnPath, bk)
558:     if err != nil {
559:         fmt.Fprintf(os.Stderr, "Unable to write block to [%s] error [%s]\n", fnPath, err)
560:         os.Exit(1)
561:         return
562:     }
563: }
564: 
565: // Debug flags to turn on output in sections of the code.
566: const db1 = false
567: const db2 = true
568: const db3 = false
569: const db4 = false
570: const db5 = false
571: const db6 = false
