// Code generated - DO NOT EDIT.
// This file is a generated binding and any manual changes will be lost.

package gen_event

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

// GenEventMetaData contains all meta data concerning the GenEvent contract.
var GenEventMetaData = &bind.MetaData{
	ABI: "[{\"inputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"constructor\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":false,\"internalType\":\"bytes32\",\"name\":\"key\",\"type\":\"bytes32\"},{\"indexed\":false,\"internalType\":\"bytes32\",\"name\":\"value\",\"type\":\"bytes32\"}],\"name\":\"DataChanged\",\"type\":\"event\"},{\"inputs\":[{\"internalType\":\"bytes32\",\"name\":\"\",\"type\":\"bytes32\"}],\"name\":\"savedData\",\"outputs\":[{\"internalType\":\"bytes32\",\"name\":\"\",\"type\":\"bytes32\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"bytes32\",\"name\":\"key\",\"type\":\"bytes32\"},{\"internalType\":\"bytes32\",\"name\":\"value\",\"type\":\"bytes32\"}],\"name\":\"setData\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"}]",
	Bin: "0x608060405234801561001057600080fd5b50610224806100206000396000f3fe608060405234801561001057600080fd5b50600436106100365760003560e01c80633a9400881461003b578063749ebfb81461006b575b600080fd5b6100556004803603810190610050919061012e565b610087565b604051610062919061016a565b60405180910390f35b61008560048036038101906100809190610185565b61009f565b005b60006020528060005260406000206000915090505481565b80600080848152602001908152602001600020819055507f35553580e4553c909abeb5764e842ce1f93c45f9f614bde2a2ca5f5b7b7dc0fb82826040516100e79291906101c5565b60405180910390a15050565b600080fd5b6000819050919050565b61010b816100f8565b811461011657600080fd5b50565b60008135905061012881610102565b92915050565b600060208284031215610144576101436100f3565b5b600061015284828501610119565b91505092915050565b610164816100f8565b82525050565b600060208201905061017f600083018461015b565b92915050565b6000806040838503121561019c5761019b6100f3565b5b60006101aa85828601610119565b92505060206101bb85828601610119565b9150509250929050565b60006040820190506101da600083018561015b565b6101e7602083018461015b565b939250505056fea264697066735822122090ad7bdd9c774243a88b26f779fa23b3afb54170d5f250d82eb60525e507f01664736f6c634300080c0033",
}

// GenEventABI is the input ABI used to generate the binding from.
// Deprecated: Use GenEventMetaData.ABI instead.
var GenEventABI = GenEventMetaData.ABI

// GenEventBin is the compiled bytecode used for deploying new contracts.
// Deprecated: Use GenEventMetaData.Bin instead.
var GenEventBin = GenEventMetaData.Bin

// DeployGenEvent deploys a new Ethereum contract, binding an instance of GenEvent to it.
func DeployGenEvent(auth *bind.TransactOpts, backend bind.ContractBackend) (common.Address, *types.Transaction, *GenEvent, error) {
	parsed, err := GenEventMetaData.GetAbi()
	if err != nil {
		return common.Address{}, nil, nil, err
	}
	if parsed == nil {
		return common.Address{}, nil, nil, errors.New("GetABI returned nil")
	}

	address, tx, contract, err := bind.DeployContract(auth, *parsed, common.FromHex(GenEventBin), backend)
	if err != nil {
		return common.Address{}, nil, nil, err
	}
	return address, tx, &GenEvent{GenEventCaller: GenEventCaller{contract: contract}, GenEventTransactor: GenEventTransactor{contract: contract}, GenEventFilterer: GenEventFilterer{contract: contract}}, nil
}

// GenEvent is an auto generated Go binding around an Ethereum contract.
type GenEvent struct {
	GenEventCaller     // Read-only binding to the contract
	GenEventTransactor // Write-only binding to the contract
	GenEventFilterer   // Log filterer for contract events
}

// GenEventCaller is an auto generated read-only Go binding around an Ethereum contract.
type GenEventCaller struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// GenEventTransactor is an auto generated write-only Go binding around an Ethereum contract.
type GenEventTransactor struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// GenEventFilterer is an auto generated log filtering Go binding around an Ethereum contract events.
type GenEventFilterer struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// GenEventSession is an auto generated Go binding around an Ethereum contract,
// with pre-set call and transact options.
type GenEventSession struct {
	Contract     *GenEvent         // Generic contract binding to set the session for
	CallOpts     bind.CallOpts     // Call options to use throughout this session
	TransactOpts bind.TransactOpts // Transaction auth options to use throughout this session
}

// GenEventCallerSession is an auto generated read-only Go binding around an Ethereum contract,
// with pre-set call options.
type GenEventCallerSession struct {
	Contract *GenEventCaller // Generic contract caller binding to set the session for
	CallOpts bind.CallOpts   // Call options to use throughout this session
}

// GenEventTransactorSession is an auto generated write-only Go binding around an Ethereum contract,
// with pre-set transact options.
type GenEventTransactorSession struct {
	Contract     *GenEventTransactor // Generic contract transactor binding to set the session for
	TransactOpts bind.TransactOpts   // Transaction auth options to use throughout this session
}

// GenEventRaw is an auto generated low-level Go binding around an Ethereum contract.
type GenEventRaw struct {
	Contract *GenEvent // Generic contract binding to access the raw methods on
}

// GenEventCallerRaw is an auto generated low-level read-only Go binding around an Ethereum contract.
type GenEventCallerRaw struct {
	Contract *GenEventCaller // Generic read-only contract binding to access the raw methods on
}

// GenEventTransactorRaw is an auto generated low-level write-only Go binding around an Ethereum contract.
type GenEventTransactorRaw struct {
	Contract *GenEventTransactor // Generic write-only contract binding to access the raw methods on
}

// NewGenEvent creates a new instance of GenEvent, bound to a specific deployed contract.
func NewGenEvent(address common.Address, backend bind.ContractBackend) (*GenEvent, error) {
	contract, err := bindGenEvent(address, backend, backend, backend)
	if err != nil {
		return nil, err
	}
	return &GenEvent{GenEventCaller: GenEventCaller{contract: contract}, GenEventTransactor: GenEventTransactor{contract: contract}, GenEventFilterer: GenEventFilterer{contract: contract}}, nil
}

// NewGenEventCaller creates a new read-only instance of GenEvent, bound to a specific deployed contract.
func NewGenEventCaller(address common.Address, caller bind.ContractCaller) (*GenEventCaller, error) {
	contract, err := bindGenEvent(address, caller, nil, nil)
	if err != nil {
		return nil, err
	}
	return &GenEventCaller{contract: contract}, nil
}

// NewGenEventTransactor creates a new write-only instance of GenEvent, bound to a specific deployed contract.
func NewGenEventTransactor(address common.Address, transactor bind.ContractTransactor) (*GenEventTransactor, error) {
	contract, err := bindGenEvent(address, nil, transactor, nil)
	if err != nil {
		return nil, err
	}
	return &GenEventTransactor{contract: contract}, nil
}

// NewGenEventFilterer creates a new log filterer instance of GenEvent, bound to a specific deployed contract.
func NewGenEventFilterer(address common.Address, filterer bind.ContractFilterer) (*GenEventFilterer, error) {
	contract, err := bindGenEvent(address, nil, nil, filterer)
	if err != nil {
		return nil, err
	}
	return &GenEventFilterer{contract: contract}, nil
}

// bindGenEvent binds a generic wrapper to an already deployed contract.
func bindGenEvent(address common.Address, caller bind.ContractCaller, transactor bind.ContractTransactor, filterer bind.ContractFilterer) (*bind.BoundContract, error) {
	parsed, err := abi.JSON(strings.NewReader(GenEventABI))
	if err != nil {
		return nil, err
	}
	return bind.NewBoundContract(address, parsed, caller, transactor, filterer), nil
}

// Call invokes the (constant) contract method with params as input values and
// sets the output to result. The result type might be a single field for simple
// returns, a slice of interfaces for anonymous returns and a struct for named
// returns.
func (_GenEvent *GenEventRaw) Call(opts *bind.CallOpts, result *[]interface{}, method string, params ...interface{}) error {
	return _GenEvent.Contract.GenEventCaller.contract.Call(opts, result, method, params...)
}

// Transfer initiates a plain transaction to move funds to the contract, calling
// its default method if one is available.
func (_GenEvent *GenEventRaw) Transfer(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _GenEvent.Contract.GenEventTransactor.contract.Transfer(opts)
}

// Transact invokes the (paid) contract method with params as input values.
func (_GenEvent *GenEventRaw) Transact(opts *bind.TransactOpts, method string, params ...interface{}) (*types.Transaction, error) {
	return _GenEvent.Contract.GenEventTransactor.contract.Transact(opts, method, params...)
}

// Call invokes the (constant) contract method with params as input values and
// sets the output to result. The result type might be a single field for simple
// returns, a slice of interfaces for anonymous returns and a struct for named
// returns.
func (_GenEvent *GenEventCallerRaw) Call(opts *bind.CallOpts, result *[]interface{}, method string, params ...interface{}) error {
	return _GenEvent.Contract.contract.Call(opts, result, method, params...)
}

// Transfer initiates a plain transaction to move funds to the contract, calling
// its default method if one is available.
func (_GenEvent *GenEventTransactorRaw) Transfer(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _GenEvent.Contract.contract.Transfer(opts)
}

// Transact invokes the (paid) contract method with params as input values.
func (_GenEvent *GenEventTransactorRaw) Transact(opts *bind.TransactOpts, method string, params ...interface{}) (*types.Transaction, error) {
	return _GenEvent.Contract.contract.Transact(opts, method, params...)
}

// SavedData is a free data retrieval call binding the contract method 0x3a940088.
//
// Solidity: function savedData(bytes32 ) view returns(bytes32)
func (_GenEvent *GenEventCaller) SavedData(opts *bind.CallOpts, arg0 [32]byte) ([32]byte, error) {
	var out []interface{}
	err := _GenEvent.contract.Call(opts, &out, "savedData", arg0)

	if err != nil {
		return *new([32]byte), err
	}

	out0 := *abi.ConvertType(out[0], new([32]byte)).(*[32]byte)

	return out0, err

}

// SavedData is a free data retrieval call binding the contract method 0x3a940088.
//
// Solidity: function savedData(bytes32 ) view returns(bytes32)
func (_GenEvent *GenEventSession) SavedData(arg0 [32]byte) ([32]byte, error) {
	return _GenEvent.Contract.SavedData(&_GenEvent.CallOpts, arg0)
}

// SavedData is a free data retrieval call binding the contract method 0x3a940088.
//
// Solidity: function savedData(bytes32 ) view returns(bytes32)
func (_GenEvent *GenEventCallerSession) SavedData(arg0 [32]byte) ([32]byte, error) {
	return _GenEvent.Contract.SavedData(&_GenEvent.CallOpts, arg0)
}

// SetData is a paid mutator transaction binding the contract method 0x749ebfb8.
//
// Solidity: function setData(bytes32 key, bytes32 value) returns()
func (_GenEvent *GenEventTransactor) SetData(opts *bind.TransactOpts, key [32]byte, value [32]byte) (*types.Transaction, error) {
	return _GenEvent.contract.Transact(opts, "setData", key, value)
}

// SetData is a paid mutator transaction binding the contract method 0x749ebfb8.
//
// Solidity: function setData(bytes32 key, bytes32 value) returns()
func (_GenEvent *GenEventSession) SetData(key [32]byte, value [32]byte) (*types.Transaction, error) {
	return _GenEvent.Contract.SetData(&_GenEvent.TransactOpts, key, value)
}

// SetData is a paid mutator transaction binding the contract method 0x749ebfb8.
//
// Solidity: function setData(bytes32 key, bytes32 value) returns()
func (_GenEvent *GenEventTransactorSession) SetData(key [32]byte, value [32]byte) (*types.Transaction, error) {
	return _GenEvent.Contract.SetData(&_GenEvent.TransactOpts, key, value)
}

// GenEventDataChangedIterator is returned from FilterDataChanged and is used to iterate over the raw logs and unpacked data for DataChanged events raised by the GenEvent contract.
type GenEventDataChangedIterator struct {
	Event *GenEventDataChanged // Event containing the contract specifics and raw log

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
func (it *GenEventDataChangedIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(GenEventDataChanged)
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
		it.Event = new(GenEventDataChanged)
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
func (it *GenEventDataChangedIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *GenEventDataChangedIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// GenEventDataChanged represents a DataChanged event raised by the GenEvent contract.
type GenEventDataChanged struct {
	Key   [32]byte
	Value [32]byte
	Raw   types.Log // Blockchain specific contextual infos
}

// FilterDataChanged is a free log retrieval operation binding the contract event 0x35553580e4553c909abeb5764e842ce1f93c45f9f614bde2a2ca5f5b7b7dc0fb.
//
// Solidity: event DataChanged(bytes32 key, bytes32 value)
func (_GenEvent *GenEventFilterer) FilterDataChanged(opts *bind.FilterOpts) (*GenEventDataChangedIterator, error) {

	logs, sub, err := _GenEvent.contract.FilterLogs(opts, "DataChanged")
	if err != nil {
		return nil, err
	}
	return &GenEventDataChangedIterator{contract: _GenEvent.contract, event: "DataChanged", logs: logs, sub: sub}, nil
}

// WatchDataChanged is a free log subscription operation binding the contract event 0x35553580e4553c909abeb5764e842ce1f93c45f9f614bde2a2ca5f5b7b7dc0fb.
//
// Solidity: event DataChanged(bytes32 key, bytes32 value)
func (_GenEvent *GenEventFilterer) WatchDataChanged(opts *bind.WatchOpts, sink chan<- *GenEventDataChanged) (event.Subscription, error) {

	logs, sub, err := _GenEvent.contract.WatchLogs(opts, "DataChanged")
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(GenEventDataChanged)
				if err := _GenEvent.contract.UnpackLog(event, "DataChanged", log); err != nil {
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

// ParseDataChanged is a log parse operation binding the contract event 0x35553580e4553c909abeb5764e842ce1f93c45f9f614bde2a2ca5f5b7b7dc0fb.
//
// Solidity: event DataChanged(bytes32 key, bytes32 value)
func (_GenEvent *GenEventFilterer) ParseDataChanged(log types.Log) (*GenEventDataChanged, error) {
	event := new(GenEventDataChanged)
	if err := _GenEvent.contract.UnpackLog(event, "DataChanged", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}
