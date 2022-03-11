  1: // Code generated - DO NOT EDIT.
  2: // This file is a generated binding and any manual changes will be lost.
  3: 
  4: package gen_event
  5: 
  6: import (
  7:     "errors"
  8:     "math/big"
  9:     "strings"
 10: 
 11:     ethereum "github.com/ethereum/go-ethereum"
 12:     "github.com/ethereum/go-ethereum/accounts/abi"
 13:     "github.com/ethereum/go-ethereum/accounts/abi/bind"
 14:     "github.com/ethereum/go-ethereum/common"
 15:     "github.com/ethereum/go-ethereum/core/types"
 16:     "github.com/ethereum/go-ethereum/event"
 17: )
 18: 
 19: // Reference imports to suppress errors if they are not otherwise used.
 20: var (
 21:     _ = errors.New
 22:     _ = big.NewInt
 23:     _ = strings.NewReader
 24:     _ = ethereum.NotFound
 25:     _ = bind.Bind
 26:     _ = common.Big1
 27:     _ = types.BloomLookup
 28:     _ = event.NewSubscription
 29: )
 30: 
 31: // GenEventMetaData contains all meta data concerning the GenEvent contract.
 32: var GenEventMetaData = &bind.MetaData{
 33:     ABI: "[{\"inputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"constructor\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":false,\"internalType\":\"bytes32\",\"name\":\"key\",\"type\":\"bytes32\"},{\"indexed\":false,\"internalType\":\"bytes32\",\"name\":\"value\",\"type\":\"bytes32\"}],\"name\":\"DataChanged\",\"type\":\"event\"},{\"inputs\":[{\"internalType\":\"bytes32\",\"name\":\"\",\"type\":\"bytes32\"}],\"name\":\"savedData\",\"outputs\":[{\"internalType\":\"bytes32\",\"name\":\"\",\"type\":\"bytes32\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"bytes32\",\"name\":\"key\",\"type\":\"bytes32\"},{\"internalType\":\"bytes32\",\"name\":\"value\",\"type\":\"bytes32\"}],\"name\":\"setData\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"}]",
 34:     Bin: "0x608060405234801561001057600080fd5b50610224806100206000396000f3fe608060405234801561001057600080fd5b50600436106100365760003560e01c80633a9400881461003b578063749ebfb81461006b575b600080fd5b6100556004803603810190610050919061012e565b610087565b604051610062919061016a565b60405180910390f35b61008560048036038101906100809190610185565b61009f565b005b60006020528060005260406000206000915090505481565b80600080848152602001908152602001600020819055507f35553580e4553c909abeb5764e842ce1f93c45f9f614bde2a2ca5f5b7b7dc0fb82826040516100e79291906101c5565b60405180910390a15050565b600080fd5b6000819050919050565b61010b816100f8565b811461011657600080fd5b50565b60008135905061012881610102565b92915050565b600060208284031215610144576101436100f3565b5b600061015284828501610119565b91505092915050565b610164816100f8565b82525050565b600060208201905061017f600083018461015b565b92915050565b6000806040838503121561019c5761019b6100f3565b5b60006101aa85828601610119565b92505060206101bb85828601610119565b9150509250929050565b60006040820190506101da600083018561015b565b6101e7602083018461015b565b939250505056fea264697066735822122090ad7bdd9c774243a88b26f779fa23b3afb54170d5f250d82eb60525e507f01664736f6c634300080c0033",
 35: }
 36: 
 37: // GenEventABI is the input ABI used to generate the binding from.
 38: // Deprecated: Use GenEventMetaData.ABI instead.
 39: var GenEventABI = GenEventMetaData.ABI
 40: 
 41: // GenEventBin is the compiled bytecode used for deploying new contracts.
 42: // Deprecated: Use GenEventMetaData.Bin instead.
 43: var GenEventBin = GenEventMetaData.Bin
 44: 
 45: // DeployGenEvent deploys a new Ethereum contract, binding an instance of GenEvent to it.
 46: func DeployGenEvent(auth *bind.TransactOpts, backend bind.ContractBackend) (common.Address, *types.Transaction, *GenEvent, error) {
 47:     parsed, err := GenEventMetaData.GetAbi()
 48:     if err != nil {
 49:         return common.Address{}, nil, nil, err
 50:     }
 51:     if parsed == nil {
 52:         return common.Address{}, nil, nil, errors.New("GetABI returned nil")
 53:     }
 54: 
 55:     address, tx, contract, err := bind.DeployContract(auth, *parsed, common.FromHex(GenEventBin), backend)
 56:     if err != nil {
 57:         return common.Address{}, nil, nil, err
 58:     }
 59:     return address, tx, &GenEvent{GenEventCaller: GenEventCaller{contract: contract}, GenEventTransactor: GenEventTransactor{contract: contract}, GenEventFilterer: GenEventFilterer{contract: contract}}, nil
 60: }
 61: 
 62: // GenEvent is an auto generated Go binding around an Ethereum contract.
 63: type GenEvent struct {
 64:     GenEventCaller     // Read-only binding to the contract
 65:     GenEventTransactor // Write-only binding to the contract
 66:     GenEventFilterer   // Log filterer for contract events
 67: }
 68: 
 69: // GenEventCaller is an auto generated read-only Go binding around an Ethereum contract.
 70: type GenEventCaller struct {
 71:     contract *bind.BoundContract // Generic contract wrapper for the low level calls
 72: }
 73: 
 74: // GenEventTransactor is an auto generated write-only Go binding around an Ethereum contract.
 75: type GenEventTransactor struct {
 76:     contract *bind.BoundContract // Generic contract wrapper for the low level calls
 77: }
 78: 
 79: // GenEventFilterer is an auto generated log filtering Go binding around an Ethereum contract events.
 80: type GenEventFilterer struct {
 81:     contract *bind.BoundContract // Generic contract wrapper for the low level calls
 82: }
 83: 
 84: // GenEventSession is an auto generated Go binding around an Ethereum contract,
 85: // with pre-set call and transact options.
 86: type GenEventSession struct {
 87:     Contract     *GenEvent         // Generic contract binding to set the session for
 88:     CallOpts     bind.CallOpts     // Call options to use throughout this session
 89:     TransactOpts bind.TransactOpts // Transaction auth options to use throughout this session
 90: }
 91: 
 92: // GenEventCallerSession is an auto generated read-only Go binding around an Ethereum contract,
 93: // with pre-set call options.
 94: type GenEventCallerSession struct {
 95:     Contract *GenEventCaller // Generic contract caller binding to set the session for
 96:     CallOpts bind.CallOpts   // Call options to use throughout this session
 97: }
 98: 
 99: // GenEventTransactorSession is an auto generated write-only Go binding around an Ethereum contract,
100: // with pre-set transact options.
101: type GenEventTransactorSession struct {
102:     Contract     *GenEventTransactor // Generic contract transactor binding to set the session for
103:     TransactOpts bind.TransactOpts   // Transaction auth options to use throughout this session
104: }
105: 
106: // GenEventRaw is an auto generated low-level Go binding around an Ethereum contract.
107: type GenEventRaw struct {
108:     Contract *GenEvent // Generic contract binding to access the raw methods on
109: }
110: 
111: // GenEventCallerRaw is an auto generated low-level read-only Go binding around an Ethereum contract.
112: type GenEventCallerRaw struct {
113:     Contract *GenEventCaller // Generic read-only contract binding to access the raw methods on
114: }
115: 
116: // GenEventTransactorRaw is an auto generated low-level write-only Go binding around an Ethereum contract.
117: type GenEventTransactorRaw struct {
118:     Contract *GenEventTransactor // Generic write-only contract binding to access the raw methods on
119: }
120: 
121: // NewGenEvent creates a new instance of GenEvent, bound to a specific deployed contract.
122: func NewGenEvent(address common.Address, backend bind.ContractBackend) (*GenEvent, error) {
123:     contract, err := bindGenEvent(address, backend, backend, backend)
124:     if err != nil {
125:         return nil, err
126:     }
127:     return &GenEvent{GenEventCaller: GenEventCaller{contract: contract}, GenEventTransactor: GenEventTransactor{contract: contract}, GenEventFilterer: GenEventFilterer{contract: contract}}, nil
128: }
129: 
130: // NewGenEventCaller creates a new read-only instance of GenEvent, bound to a specific deployed contract.
131: func NewGenEventCaller(address common.Address, caller bind.ContractCaller) (*GenEventCaller, error) {
132:     contract, err := bindGenEvent(address, caller, nil, nil)
133:     if err != nil {
134:         return nil, err
135:     }
136:     return &GenEventCaller{contract: contract}, nil
137: }
138: 
139: // NewGenEventTransactor creates a new write-only instance of GenEvent, bound to a specific deployed contract.
140: func NewGenEventTransactor(address common.Address, transactor bind.ContractTransactor) (*GenEventTransactor, error) {
141:     contract, err := bindGenEvent(address, nil, transactor, nil)
142:     if err != nil {
143:         return nil, err
144:     }
145:     return &GenEventTransactor{contract: contract}, nil
146: }
147: 
148: // NewGenEventFilterer creates a new log filterer instance of GenEvent, bound to a specific deployed contract.
149: func NewGenEventFilterer(address common.Address, filterer bind.ContractFilterer) (*GenEventFilterer, error) {
150:     contract, err := bindGenEvent(address, nil, nil, filterer)
151:     if err != nil {
152:         return nil, err
153:     }
154:     return &GenEventFilterer{contract: contract}, nil
155: }
156: 
157: // bindGenEvent binds a generic wrapper to an already deployed contract.
158: func bindGenEvent(address common.Address, caller bind.ContractCaller, transactor bind.ContractTransactor, filterer bind.ContractFilterer) (*bind.BoundContract, error) {
159:     parsed, err := abi.JSON(strings.NewReader(GenEventABI))
160:     if err != nil {
161:         return nil, err
162:     }
163:     return bind.NewBoundContract(address, parsed, caller, transactor, filterer), nil
164: }
165: 
166: // Call invokes the (constant) contract method with params as input values and
167: // sets the output to result. The result type might be a single field for simple
168: // returns, a slice of interfaces for anonymous returns and a struct for named
169: // returns.
170: func (_GenEvent *GenEventRaw) Call(opts *bind.CallOpts, result *[]interface{}, method string, params ...interface{}) error {
171:     return _GenEvent.Contract.GenEventCaller.contract.Call(opts, result, method, params...)
172: }
173: 
174: // Transfer initiates a plain transaction to move funds to the contract, calling
175: // its default method if one is available.
176: func (_GenEvent *GenEventRaw) Transfer(opts *bind.TransactOpts) (*types.Transaction, error) {
177:     return _GenEvent.Contract.GenEventTransactor.contract.Transfer(opts)
178: }
179: 
180: // Transact invokes the (paid) contract method with params as input values.
181: func (_GenEvent *GenEventRaw) Transact(opts *bind.TransactOpts, method string, params ...interface{}) (*types.Transaction, error) {
182:     return _GenEvent.Contract.GenEventTransactor.contract.Transact(opts, method, params...)
183: }
184: 
185: // Call invokes the (constant) contract method with params as input values and
186: // sets the output to result. The result type might be a single field for simple
187: // returns, a slice of interfaces for anonymous returns and a struct for named
188: // returns.
189: func (_GenEvent *GenEventCallerRaw) Call(opts *bind.CallOpts, result *[]interface{}, method string, params ...interface{}) error {
190:     return _GenEvent.Contract.contract.Call(opts, result, method, params...)
191: }
192: 
193: // Transfer initiates a plain transaction to move funds to the contract, calling
194: // its default method if one is available.
195: func (_GenEvent *GenEventTransactorRaw) Transfer(opts *bind.TransactOpts) (*types.Transaction, error) {
196:     return _GenEvent.Contract.contract.Transfer(opts)
197: }
198: 
199: // Transact invokes the (paid) contract method with params as input values.
200: func (_GenEvent *GenEventTransactorRaw) Transact(opts *bind.TransactOpts, method string, params ...interface{}) (*types.Transaction, error) {
201:     return _GenEvent.Contract.contract.Transact(opts, method, params...)
202: }
203: 
204: // SavedData is a free data retrieval call binding the contract method 0x3a940088.
205: //
206: // Solidity: function savedData(bytes32 ) view returns(bytes32)
207: func (_GenEvent *GenEventCaller) SavedData(opts *bind.CallOpts, arg0 [32]byte) ([32]byte, error) {
208:     var out []interface{}
209:     err := _GenEvent.contract.Call(opts, &out, "savedData", arg0)
210: 
211:     if err != nil {
212:         return *new([32]byte), err
213:     }
214: 
215:     out0 := *abi.ConvertType(out[0], new([32]byte)).(*[32]byte)
216: 
217:     return out0, err
218: 
219: }
220: 
221: // SavedData is a free data retrieval call binding the contract method 0x3a940088.
222: //
223: // Solidity: function savedData(bytes32 ) view returns(bytes32)
224: func (_GenEvent *GenEventSession) SavedData(arg0 [32]byte) ([32]byte, error) {
225:     return _GenEvent.Contract.SavedData(&_GenEvent.CallOpts, arg0)
226: }
227: 
228: // SavedData is a free data retrieval call binding the contract method 0x3a940088.
229: //
230: // Solidity: function savedData(bytes32 ) view returns(bytes32)
231: func (_GenEvent *GenEventCallerSession) SavedData(arg0 [32]byte) ([32]byte, error) {
232:     return _GenEvent.Contract.SavedData(&_GenEvent.CallOpts, arg0)
233: }
234: 
235: // SetData is a paid mutator transaction binding the contract method 0x749ebfb8.
236: //
237: // Solidity: function setData(bytes32 key, bytes32 value) returns()
238: func (_GenEvent *GenEventTransactor) SetData(opts *bind.TransactOpts, key [32]byte, value [32]byte) (*types.Transaction, error) {
239:     return _GenEvent.contract.Transact(opts, "setData", key, value)
240: }
241: 
242: // SetData is a paid mutator transaction binding the contract method 0x749ebfb8.
243: //
244: // Solidity: function setData(bytes32 key, bytes32 value) returns()
245: func (_GenEvent *GenEventSession) SetData(key [32]byte, value [32]byte) (*types.Transaction, error) {
246:     return _GenEvent.Contract.SetData(&_GenEvent.TransactOpts, key, value)
247: }
248: 
249: // SetData is a paid mutator transaction binding the contract method 0x749ebfb8.
250: //
251: // Solidity: function setData(bytes32 key, bytes32 value) returns()
252: func (_GenEvent *GenEventTransactorSession) SetData(key [32]byte, value [32]byte) (*types.Transaction, error) {
253:     return _GenEvent.Contract.SetData(&_GenEvent.TransactOpts, key, value)
254: }
255: 
256: // GenEventDataChangedIterator is returned from FilterDataChanged and is used to iterate over the raw logs and unpacked data for DataChanged events raised by the GenEvent contract.
257: type GenEventDataChangedIterator struct {
258:     Event *GenEventDataChanged // Event containing the contract specifics and raw log
259: 
260:     contract *bind.BoundContract // Generic contract to use for unpacking event data
261:     event    string              // Event name to use for unpacking event data
262: 
263:     logs chan types.Log        // Log channel receiving the found contract events
264:     sub  ethereum.Subscription // Subscription for errors, completion and termination
265:     done bool                  // Whether the subscription completed delivering logs
266:     fail error                 // Occurred error to stop iteration
267: }
268: 
269: // Next advances the iterator to the subsequent event, returning whether there
270: // are any more events found. In case of a retrieval or parsing error, false is
271: // returned and Error() can be queried for the exact failure.
272: func (it *GenEventDataChangedIterator) Next() bool {
273:     // If the iterator failed, stop iterating
274:     if it.fail != nil {
275:         return false
276:     }
277:     // If the iterator completed, deliver directly whatever's available
278:     if it.done {
279:         select {
280:         case log := <-it.logs:
281:             it.Event = new(GenEventDataChanged)
282:             if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
283:                 it.fail = err
284:                 return false
285:             }
286:             it.Event.Raw = log
287:             return true
288: 
289:         default:
290:             return false
291:         }
292:     }
293:     // Iterator still in progress, wait for either a data or an error event
294:     select {
295:     case log := <-it.logs:
296:         it.Event = new(GenEventDataChanged)
297:         if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
298:             it.fail = err
299:             return false
300:         }
301:         it.Event.Raw = log
302:         return true
303: 
304:     case err := <-it.sub.Err():
305:         it.done = true
306:         it.fail = err
307:         return it.Next()
308:     }
309: }
310: 
311: // Error returns any retrieval or parsing error occurred during filtering.
312: func (it *GenEventDataChangedIterator) Error() error {
313:     return it.fail
314: }
315: 
316: // Close terminates the iteration process, releasing any pending underlying
317: // resources.
318: func (it *GenEventDataChangedIterator) Close() error {
319:     it.sub.Unsubscribe()
320:     return nil
321: }
322: 
323: // GenEventDataChanged represents a DataChanged event raised by the GenEvent contract.
324: type GenEventDataChanged struct {
325:     Key   [32]byte
326:     Value [32]byte
327:     Raw   types.Log // Blockchain specific contextual infos
328: }
329: 
330: // FilterDataChanged is a free log retrieval operation binding the contract event 0x35553580e4553c909abeb5764e842ce1f93c45f9f614bde2a2ca5f5b7b7dc0fb.
331: //
332: // Solidity: event DataChanged(bytes32 key, bytes32 value)
333: func (_GenEvent *GenEventFilterer) FilterDataChanged(opts *bind.FilterOpts) (*GenEventDataChangedIterator, error) {
334: 
335:     logs, sub, err := _GenEvent.contract.FilterLogs(opts, "DataChanged")
336:     if err != nil {
337:         return nil, err
338:     }
339:     return &GenEventDataChangedIterator{contract: _GenEvent.contract, event: "DataChanged", logs: logs, sub: sub}, nil
340: }
341: 
342: // WatchDataChanged is a free log subscription operation binding the contract event 0x35553580e4553c909abeb5764e842ce1f93c45f9f614bde2a2ca5f5b7b7dc0fb.
343: //
344: // Solidity: event DataChanged(bytes32 key, bytes32 value)
345: func (_GenEvent *GenEventFilterer) WatchDataChanged(opts *bind.WatchOpts, sink chan<- *GenEventDataChanged) (event.Subscription, error) {
346: 
347:     logs, sub, err := _GenEvent.contract.WatchLogs(opts, "DataChanged")
348:     if err != nil {
349:         return nil, err
350:     }
351:     return event.NewSubscription(func(quit <-chan struct{}) error {
352:         defer sub.Unsubscribe()
353:         for {
354:             select {
355:             case log := <-logs:
356:                 // New log arrived, parse the event and forward to the user
357:                 event := new(GenEventDataChanged)
358:                 if err := _GenEvent.contract.UnpackLog(event, "DataChanged", log); err != nil {
359:                     return err
360:                 }
361:                 event.Raw = log
362: 
363:                 select {
364:                 case sink <- event:
365:                 case err := <-sub.Err():
366:                     return err
367:                 case <-quit:
368:                     return nil
369:                 }
370:             case err := <-sub.Err():
371:                 return err
372:             case <-quit:
373:                 return nil
374:             }
375:         }
376:     }), nil
377: }
378: 
379: // ParseDataChanged is a log parse operation binding the contract event 0x35553580e4553c909abeb5764e842ce1f93c45f9f614bde2a2ca5f5b7b7dc0fb.
380: //
381: // Solidity: event DataChanged(bytes32 key, bytes32 value)
382: func (_GenEvent *GenEventFilterer) ParseDataChanged(log types.Log) (*GenEventDataChanged, error) {
383:     event := new(GenEventDataChanged)
384:     if err := _GenEvent.contract.UnpackLog(event, "DataChanged", log); err != nil {
385:         return nil, err
386:     }
387:     event.Raw = log
388:     return event, nil
389: }
