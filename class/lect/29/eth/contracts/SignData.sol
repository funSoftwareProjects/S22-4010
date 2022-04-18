// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract SignData is Ownable {

    address payable owner_address;
	uint256 private minPayment;

	mapping(uint256 => mapping(uint256 => bytes32)) dData;
	mapping(uint256 => mapping(uint256 => address)) dOowner;
	mapping(uint256 => mapping(uint256 => bool)) dMayChange;
	mapping(uint256 => mapping(uint256 => bool)) dExists;
	mapping(uint256 => mapping(uint256 => uint256)) dWhen;
	event DataChange(uint256 App, uint256 Name, bytes32 Value, address By);

	event ReceivedFunds(address sender, uint256 value, uint256 application, uint256 payFor);
	event Withdrawn(address to, uint256 amount);

	constructor() {
        owner_address = payable(msg.sender);
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

	// -----------------------------------------------------------------------------------------------------------

	/**
	 * @dev Update an existing set of data if the data was created with permissions to be updated.
	 */
	function setHash ( uint256 _app, uint256 _name, bytes32 _data ) public needMinPayment payable {
		address tmp = dOowner[_app][_name];
		bool mayChange = dMayChange[_app][_name];
		if ( tmp == msg.sender && !mayChange ) {
			revert("Data is not changable");
		}
		if ( tmp != msg.sender ) {
			revert("Not owner of data.");
		}
		bool ex = dExists[_app][_name];
		if ( !ex ) {
			revert("No data found." );
		}
		dData[_app][_name] = _data;
		dWhen[_app][_name] = block.timestamp;
		emit DataChange(_app, _name, _data, msg.sender);
		emit ReceivedFunds(msg.sender, msg.value, _app, _name);
	}

	/**
	 * @dev Create a new hash and save it's relevant data.  Check that this is a new set of data.
	 */
	function createHash ( uint256 _app, uint256 _name, bytes32 _data, bool _mayChange )
		public needMinPayment payable {
		if ( _name == 0 ) {
			revert("Invalid _name with value of 0");
		}
		if ( _app == 0 ) {
			revert("Invalid _app with value of 0");
		}
		if ( msg.sender == address(0) ) {
			revert("Invalid msg sender");
		}
		bool ex = dExists[_app][_name];
		if ( ex ) {
			revert("Data already exists for this app and name.");
		}
		dOowner[_app][_name] = msg.sender;
		dData[_app][_name] = _data;
		dMayChange[_app][_name] = _mayChange;
		dWhen[_app][_name] = block.timestamp;
		dExists[_app][_name] = true;
		emit DataChange(_app, _name, _data, msg.sender);
		emit ReceivedFunds(msg.sender, msg.value, _app, _name);
	}

	/**
	 * @dev return the data by looking up _app and _name in dData.  Return both the hash and the date when
	 *      it was stored..  Return 0's if no data exits.
	 */
	function getHash ( uint256 _app, uint256 _name ) public view returns ( bytes32, uint256 ) {
		bool ex = dExists[_app][_name];
		if ( !ex ) {
			return ( 0, 0 );
		}
		return ( dData[_app][_name], dWhen[_app][_name] );
	}

	// -------------------------------------------------------------------------------------------------------

	/**
	 * @dev payable fallback.  The fallback function is called when no other function 
	 * matches (if the receive ether function does not exist then this includes calls 
	 * with empty call data). You can make this function payable or not.  If it is not 
	 * payable then transactions not matching any other function which send value will
	 * revert. 
	 */
	fallback() external payable {
		emit ReceivedFunds(msg.sender, msg.value, 0, 1);
	}

	/**
	 * @dev payable receive.  The receive ether function is called whenever the call data
	 *      is empty (whether or not ether is received). This function is implicitly payable.
	 */
	receive() external payable {
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
		payable(owner_address).transfer(amount);
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
