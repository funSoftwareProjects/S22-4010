// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "zeppelin-solidity/contracts/ownership/Ownable.sol";

contract SignData is Ownable {

    address payable owner_address;
	uint256 private minPayment;

	mapping(uint256 => mapping(uint256 => bytes32)) dData;
	mapping(uint256 => mapping(uint256 => address)) dOowner;
	mapping(uint256 => mapping(uint256 => bool)) dMayChange;
	event DataChange(uint256 App, uint256 Name, bytes32 Value, address By);

	event ReceivedFunds(address sender, uint256 value, uint256 application, uint256 payFor);
	event Withdrawn(address to, uint256 amount);

	constructor() public {
        owner_address = msg.sender;
		minPayment = 1000;
	}

	modifier needMinPayment {
		require(msg.value >= minPayment, "Insufficient payment.  Must send more than minPayment.");
		_;
	}

	function init() public {
		minPayment = 1000;
	}

	function setMinPayment( uint256 _minPayment ) public onlyOwner {
		minPayment = _minPayment;
	}

	function getMinPayment() public onlyOwner view returns ( uint256 ) {
		return ( minPayment );
	}

	// ----------------------------------------------------------------------------------------------------------------------

	/**
	 * @dev TODO if the data is empty, or if the msg.sender is the original createor of the data:
	 *      then : save the msg.sender into dOwner, save the data into dData
     *             create a DataChange event.
     *      else : revert an error.
	 */
	function setData ( uint256 _app, uint256 _name, bytes32 _data ) public needMinPayment payable {
		address tmp = dOowner[_app][_name];
		bool mayChange = dMayChange[_app][_name];
		if ( tmp == msg.sender && !mayChange ) {
			revert("Data is not changable");
		}
		if ( tmp != msg.sender ) {
			revert("Not owner of data.");
		}
		dData[_app][_name] = _data;
		emit DataChange(_app, _name, _data, msg.sender);
		emit ReceivedFunds(msg.sender, msg.value, _app, _name);
	}

	/**
	 * @dev TODO if the data is empty, or if the msg.sender is the original createor of the data:
	 *      then : save the msg.sender into dOwner, save the data into dData
     *             create a DataChange event.
     *      else : revert an error.
	 */
	function createSignature ( uint256 _app, uint256 _name, bytes32 _data, bool _mayChange ) public needMinPayment payable {
		if ( _name == 0 ) {
			revert("Invalid _name with value of 0");
		}
		if ( _app == 0 ) {
			revert("Invalid _app with value of 0");
		}
		if ( msg.sender == address(0) ) {
			revert("Invalid msg sender");
		}
		address tmp = dOowner[_app][_name];
		if ( tmp != address(0) ) {	// Check that it has not already been created, 0 retuned if not exists
			dOowner[_app][_name] = msg.sender;
			dData[_app][_name] = _data;
			dMayChange[_app][_name] = _mayChange;
			emit DataChange(_app, _name, _data, msg.sender);
			emit ReceivedFunds(msg.sender, msg.value, _app, _name);
		} else {
			revert("Not owner of data.");
		}
	}

	/**
	 * @dev TODO return the data by looking up _app and _name in dData.
	 */
	function getSignature ( uint256 _app, uint256 _name ) public view returns ( bytes32 ) {
		return ( dData[_app][_name] );
	}

	// ----------------------------------------------------------------------------------------------------------------------

	/**
	 * @dev payable fallback
	 */
	function () external payable {
		emit ReceivedFunds(msg.sender, msg.value, 0, 1);
	}

	/**
	 * @dev genReceiveFunds - generate a receive funds event.
	 */
	function genReceivedFunds ( uint256 application, uint256 payFor ) public payable {
		emit ReceivedFunds(msg.sender, msg.value, application, payFor);
	}

	/**
	 * @dev Withdraw contract value amount.
	 */
	function withdraw( uint256 amount ) public onlyOwner returns(bool) {
		address(owner_address).transfer(amount);
		// owner_address.send(amount);
		emit Withdrawn(owner_address, amount);
		return true;
	}

	/**
	 * @dev How much do I got?
	 */
	function getBalanceContract() public view onlyOwner returns(uint256){
		return address(this).balance;
	}

	/**
	 * @dev For futute to end the contract, take the value.
	 */
	function kill() public onlyOwner {
		emit Withdrawn(owner_address, address(this).balance);
		selfdestruct(owner_address);
	}
}
