// Code generated - DO NOT EDIT.
// This file is a generated binding and any manual changes will be lost.

package KVPair

import (
	"errors"
	"math/big"
	"strings"

	ethereum "github.com/ethereum/go-ethereum"
	"github.com/ethereum/go-ethereum/accounts/abi"
	"github.com/ethereum/go-ethereum/accounts/abi/bind"
	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/core/types"
	"github.com/ethereum/go-ethereum/event"
)

// Reference imports to suppress errors if they are not otherwise used.
var (
	_ = errors.New
	_ = big.NewInt
	_ = strings.NewReader
	_ = ethereum.NotFound
	_ = bind.Bind
	_ = common.Big1
	_ = types.BloomLookup
	_ = event.NewSubscription
)

// KVPairMetaData contains all meta data concerning the KVPair contract.
var KVPairMetaData = &bind.MetaData{
	ABI: "[{\"inputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"constructor\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":false,\"internalType\":\"bytes32\",\"name\":\"key\",\"type\":\"bytes32\"},{\"indexed\":false,\"internalType\":\"bytes32\",\"name\":\"value\",\"type\":\"bytes32\"}],\"name\":\"SetKVEvent\",\"type\":\"event\"},{\"inputs\":[{\"internalType\":\"bytes32\",\"name\":\"key\",\"type\":\"bytes32\"},{\"internalType\":\"bytes32\",\"name\":\"value\",\"type\":\"bytes32\"}],\"name\":\"setKVPari\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"bytes32\",\"name\":\"\",\"type\":\"bytes32\"}],\"name\":\"theData\",\"outputs\":[{\"internalType\":\"bytes32\",\"name\":\"\",\"type\":\"bytes32\"}],\"stateMutability\":\"view\",\"type\":\"function\"}]",
	Bin: "0x608060405234801561001057600080fd5b50610224806100206000396000f3fe608060405234801561001057600080fd5b50600436106100365760003560e01c80639867b5cc1461003b5780639e1f9e481461006b575b600080fd5b6100556004803603810190610050919061012e565b610087565b604051610062919061016a565b60405180910390f35b61008560048036038101906100809190610185565b61009f565b005b60006020528060005260406000206000915090505481565b80600080848152602001908152602001600020819055507f4bc1daeb3fe3368b8a1eadeaa84715cd83301811695688bbf566fba1034bbc7882826040516100e79291906101c5565b60405180910390a15050565b600080fd5b6000819050919050565b61010b816100f8565b811461011657600080fd5b50565b60008135905061012881610102565b92915050565b600060208284031215610144576101436100f3565b5b600061015284828501610119565b91505092915050565b610164816100f8565b82525050565b600060208201905061017f600083018461015b565b92915050565b6000806040838503121561019c5761019b6100f3565b5b60006101aa85828601610119565b92505060206101bb85828601610119565b9150509250929050565b60006040820190506101da600083018561015b565b6101e7602083018461015b565b939250505056fea2646970667358221220eb0289b4918623253a517d1213e3b98f493fd2d29ab5d0187fb94bad337c2ba964736f6c634300080c0033",
}

// KVPairABI is the input ABI used to generate the binding from.
// Deprecated: Use KVPairMetaData.ABI instead.
var KVPairABI = KVPairMetaData.ABI

// KVPairBin is the compiled bytecode used for deploying new contracts.
// Deprecated: Use KVPairMetaData.Bin instead.
var KVPairBin = KVPairMetaData.Bin

// DeployKVPair deploys a new Ethereum contract, binding an instance of KVPair to it.
func DeployKVPair(auth *bind.TransactOpts, backend bind.ContractBackend) (common.Address, *types.Transaction, *KVPair, error) {
	parsed, err := KVPairMetaData.GetAbi()
	if err != nil {
		return common.Address{}, nil, nil, err
	}
	if parsed == nil {
		return common.Address{}, nil, nil, errors.New("GetABI returned nil")
	}

	address, tx, contract, err := bind.DeployContract(auth, *parsed, common.FromHex(KVPairBin), backend)
	if err != nil {
		return common.Address{}, nil, nil, err
	}
	return address, tx, &KVPair{KVPairCaller: KVPairCaller{contract: contract}, KVPairTransactor: KVPairTransactor{contract: contract}, KVPairFilterer: KVPairFilterer{contract: contract}}, nil
}

// KVPair is an auto generated Go binding around an Ethereum contract.
type KVPair struct {
	KVPairCaller     // Read-only binding to the contract
	KVPairTransactor // Write-only binding to the contract
	KVPairFilterer   // Log filterer for contract events
}

// KVPairCaller is an auto generated read-only Go binding around an Ethereum contract.
type KVPairCaller struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// KVPairTransactor is an auto generated write-only Go binding around an Ethereum contract.
type KVPairTransactor struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// KVPairFilterer is an auto generated log filtering Go binding around an Ethereum contract events.
type KVPairFilterer struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// KVPairSession is an auto generated Go binding around an Ethereum contract,
// with pre-set call and transact options.
type KVPairSession struct {
	Contract     *KVPair           // Generic contract binding to set the session for
	CallOpts     bind.CallOpts     // Call options to use throughout this session
	TransactOpts bind.TransactOpts // Transaction auth options to use throughout this session
}

// KVPairCallerSession is an auto generated read-only Go binding around an Ethereum contract,
// with pre-set call options.
type KVPairCallerSession struct {
	Contract *KVPairCaller // Generic contract caller binding to set the session for
	CallOpts bind.CallOpts // Call options to use throughout this session
}

// KVPairTransactorSession is an auto generated write-only Go binding around an Ethereum contract,
// with pre-set transact options.
type KVPairTransactorSession struct {
	Contract     *KVPairTransactor // Generic contract transactor binding to set the session for
	TransactOpts bind.TransactOpts // Transaction auth options to use throughout this session
}

// KVPairRaw is an auto generated low-level Go binding around an Ethereum contract.
type KVPairRaw struct {
	Contract *KVPair // Generic contract binding to access the raw methods on
}

// KVPairCallerRaw is an auto generated low-level read-only Go binding around an Ethereum contract.
type KVPairCallerRaw struct {
	Contract *KVPairCaller // Generic read-only contract binding to access the raw methods on
}

// KVPairTransactorRaw is an auto generated low-level write-only Go binding around an Ethereum contract.
type KVPairTransactorRaw struct {
	Contract *KVPairTransactor // Generic write-only contract binding to access the raw methods on
}

// NewKVPair creates a new instance of KVPair, bound to a specific deployed contract.
func NewKVPair(address common.Address, backend bind.ContractBackend) (*KVPair, error) {
	contract, err := bindKVPair(address, backend, backend, backend)
	if err != nil {
		return nil, err
	}
	return &KVPair{KVPairCaller: KVPairCaller{contract: contract}, KVPairTransactor: KVPairTransactor{contract: contract}, KVPairFilterer: KVPairFilterer{contract: contract}}, nil
}

// NewKVPairCaller creates a new read-only instance of KVPair, bound to a specific deployed contract.
func NewKVPairCaller(address common.Address, caller bind.ContractCaller) (*KVPairCaller, error) {
	contract, err := bindKVPair(address, caller, nil, nil)
	if err != nil {
		return nil, err
	}
	return &KVPairCaller{contract: contract}, nil
}

// NewKVPairTransactor creates a new write-only instance of KVPair, bound to a specific deployed contract.
func NewKVPairTransactor(address common.Address, transactor bind.ContractTransactor) (*KVPairTransactor, error) {
	contract, err := bindKVPair(address, nil, transactor, nil)
	if err != nil {
		return nil, err
	}
	return &KVPairTransactor{contract: contract}, nil
}

// NewKVPairFilterer creates a new log filterer instance of KVPair, bound to a specific deployed contract.
func NewKVPairFilterer(address common.Address, filterer bind.ContractFilterer) (*KVPairFilterer, error) {
	contract, err := bindKVPair(address, nil, nil, filterer)
	if err != nil {
		return nil, err
	}
	return &KVPairFilterer{contract: contract}, nil
}

// bindKVPair binds a generic wrapper to an already deployed contract.
func bindKVPair(address common.Address, caller bind.ContractCaller, transactor bind.ContractTransactor, filterer bind.ContractFilterer) (*bind.BoundContract, error) {
	parsed, err := abi.JSON(strings.NewReader(KVPairABI))
	if err != nil {
		return nil, err
	}
	return bind.NewBoundContract(address, parsed, caller, transactor, filterer), nil
}

// Call invokes the (constant) contract method with params as input values and
// sets the output to result. The result type might be a single field for simple
// returns, a slice of interfaces for anonymous returns and a struct for named
// returns.
func (_KVPair *KVPairRaw) Call(opts *bind.CallOpts, result *[]interface{}, method string, params ...interface{}) error {
	return _KVPair.Contract.KVPairCaller.contract.Call(opts, result, method, params...)
}

// Transfer initiates a plain transaction to move funds to the contract, calling
// its default method if one is available.
func (_KVPair *KVPairRaw) Transfer(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _KVPair.Contract.KVPairTransactor.contract.Transfer(opts)
}

// Transact invokes the (paid) contract method with params as input values.
func (_KVPair *KVPairRaw) Transact(opts *bind.TransactOpts, method string, params ...interface{}) (*types.Transaction, error) {
	return _KVPair.Contract.KVPairTransactor.contract.Transact(opts, method, params...)
}

// Call invokes the (constant) contract method with params as input values and
// sets the output to result. The result type might be a single field for simple
// returns, a slice of interfaces for anonymous returns and a struct for named
// returns.
func (_KVPair *KVPairCallerRaw) Call(opts *bind.CallOpts, result *[]interface{}, method string, params ...interface{}) error {
	return _KVPair.Contract.contract.Call(opts, result, method, params...)
}

// Transfer initiates a plain transaction to move funds to the contract, calling
// its default method if one is available.
func (_KVPair *KVPairTransactorRaw) Transfer(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _KVPair.Contract.contract.Transfer(opts)
}

// Transact invokes the (paid) contract method with params as input values.
func (_KVPair *KVPairTransactorRaw) Transact(opts *bind.TransactOpts, method string, params ...interface{}) (*types.Transaction, error) {
	return _KVPair.Contract.contract.Transact(opts, method, params...)
}

// TheData is a free data retrieval call binding the contract method 0x9867b5cc.
//
// Solidity: function theData(bytes32 ) view returns(bytes32)
func (_KVPair *KVPairCaller) TheData(opts *bind.CallOpts, arg0 [32]byte) ([32]byte, error) {
	var out []interface{}
	err := _KVPair.contract.Call(opts, &out, "theData", arg0)

	if err != nil {
		return *new([32]byte), err
	}

	out0 := *abi.ConvertType(out[0], new([32]byte)).(*[32]byte)

	return out0, err

}

// TheData is a free data retrieval call binding the contract method 0x9867b5cc.
//
// Solidity: function theData(bytes32 ) view returns(bytes32)
func (_KVPair *KVPairSession) TheData(arg0 [32]byte) ([32]byte, error) {
	return _KVPair.Contract.TheData(&_KVPair.CallOpts, arg0)
}

// TheData is a free data retrieval call binding the contract method 0x9867b5cc.
//
// Solidity: function theData(bytes32 ) view returns(bytes32)
func (_KVPair *KVPairCallerSession) TheData(arg0 [32]byte) ([32]byte, error) {
	return _KVPair.Contract.TheData(&_KVPair.CallOpts, arg0)
}

// SetKVPari is a paid mutator transaction binding the contract method 0x9e1f9e48.
//
// Solidity: function setKVPari(bytes32 key, bytes32 value) returns()
func (_KVPair *KVPairTransactor) SetKVPari(opts *bind.TransactOpts, key [32]byte, value [32]byte) (*types.Transaction, error) {
	return _KVPair.contract.Transact(opts, "setKVPari", key, value)
}

// SetKVPari is a paid mutator transaction binding the contract method 0x9e1f9e48.
//
// Solidity: function setKVPari(bytes32 key, bytes32 value) returns()
func (_KVPair *KVPairSession) SetKVPari(key [32]byte, value [32]byte) (*types.Transaction, error) {
	return _KVPair.Contract.SetKVPari(&_KVPair.TransactOpts, key, value)
}

// SetKVPari is a paid mutator transaction binding the contract method 0x9e1f9e48.
//
// Solidity: function setKVPari(bytes32 key, bytes32 value) returns()
func (_KVPair *KVPairTransactorSession) SetKVPari(key [32]byte, value [32]byte) (*types.Transaction, error) {
	return _KVPair.Contract.SetKVPari(&_KVPair.TransactOpts, key, value)
}

// KVPairSetKVEventIterator is returned from FilterSetKVEvent and is used to iterate over the raw logs and unpacked data for SetKVEvent events raised by the KVPair contract.
type KVPairSetKVEventIterator struct {
	Event *KVPairSetKVEvent // Event containing the contract specifics and raw log

	contract *bind.BoundContract // Generic contract to use for unpacking event data
	event    string              // Event name to use for unpacking event data

	logs chan types.Log        // Log channel receiving the found contract events
	sub  ethereum.Subscription // Subscription for errors, completion and termination
	done bool                  // Whether the subscription completed delivering logs
	fail error                 // Occurred error to stop iteration
}

// Next advances the iterator to the subsequent event, returning whether there
// are any more events found. In case of a retrieval or parsing error, false is
// returned and Error() can be queried for the exact failure.
func (it *KVPairSetKVEventIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(KVPairSetKVEvent)
			if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
				it.fail = err
				return false
			}
			it.Event.Raw = log
			return true

		default:
			return false
		}
	}
	// Iterator still in progress, wait for either a data or an error event
	select {
	case log := <-it.logs:
		it.Event = new(KVPairSetKVEvent)
		if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
			it.fail = err
			return false
		}
		it.Event.Raw = log
		return true

	case err := <-it.sub.Err():
		it.done = true
		it.fail = err
		return it.Next()
	}
}

// Error returns any retrieval or parsing error occurred during filtering.
func (it *KVPairSetKVEventIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *KVPairSetKVEventIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// KVPairSetKVEvent represents a SetKVEvent event raised by the KVPair contract.
type KVPairSetKVEvent struct {
	Key   [32]byte
	Value [32]byte
	Raw   types.Log // Blockchain specific contextual infos
}

// FilterSetKVEvent is a free log retrieval operation binding the contract event 0x4bc1daeb3fe3368b8a1eadeaa84715cd83301811695688bbf566fba1034bbc78.
//
// Solidity: event SetKVEvent(bytes32 key, bytes32 value)
func (_KVPair *KVPairFilterer) FilterSetKVEvent(opts *bind.FilterOpts) (*KVPairSetKVEventIterator, error) {

	logs, sub, err := _KVPair.contract.FilterLogs(opts, "SetKVEvent")
	if err != nil {
		return nil, err
	}
	return &KVPairSetKVEventIterator{contract: _KVPair.contract, event: "SetKVEvent", logs: logs, sub: sub}, nil
}

// WatchSetKVEvent is a free log subscription operation binding the contract event 0x4bc1daeb3fe3368b8a1eadeaa84715cd83301811695688bbf566fba1034bbc78.
//
// Solidity: event SetKVEvent(bytes32 key, bytes32 value)
func (_KVPair *KVPairFilterer) WatchSetKVEvent(opts *bind.WatchOpts, sink chan<- *KVPairSetKVEvent) (event.Subscription, error) {

	logs, sub, err := _KVPair.contract.WatchLogs(opts, "SetKVEvent")
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(KVPairSetKVEvent)
				if err := _KVPair.contract.UnpackLog(event, "SetKVEvent", log); err != nil {
					return err
				}
				event.Raw = log

				select {
				case sink <- event:
				case err := <-sub.Err():
					return err
				case <-quit:
					return nil
				}
			case err := <-sub.Err():
				return err
			case <-quit:
				return nil
			}
		}
	}), nil
}

// ParseSetKVEvent is a log parse operation binding the contract event 0x4bc1daeb3fe3368b8a1eadeaa84715cd83301811695688bbf566fba1034bbc78.
//
// Solidity: event SetKVEvent(bytes32 key, bytes32 value)
func (_KVPair *KVPairFilterer) ParseSetKVEvent(log types.Log) (*KVPairSetKVEvent, error) {
	event := new(KVPairSetKVEvent)
	if err := _KVPair.contract.UnpackLog(event, "SetKVEvent", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}
