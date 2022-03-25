// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract FixedTermDesposite is Ownable {
    address payable owner_address;
    uint256 pct;				// Payment for Deposite
    uint256 numberOfdays;		// Payment can be withdrawn after X days.





	mapping(address => uint32) nOfDeposites; // Your Deposite ID
	mapping(uint256 => mapping(address => uint256)) depositeAmount;
	mapping(uint256 => mapping(address => address)) depositeOwner;
	mapping(uint256 => mapping(address => uint256)) depositeDeadline;

	event DepositeMade(address indexed who, uint256 amount, uint32 id);
	event FundsRemoved(address indexed who, uint256 amount, uint32 id);
	event ReceivedFunds(address sender, uint256 value);
	event Withdrawn(address to, uint256 amount);

	constructor(uint256 _pct) {
        owner_address = payable(msg.sender);
		pct  = _pct; // 1000000 times the yearly percentage rate
		numberOfdays = 365;
	}

	/**
	 * @dev Create a new deposite for 1 year.
	 */
    function depositCertificate(uint256 _amount) public payable returns ( uint32 ) {
        require(msg.value == _amount);
		uint32 id = nOfDeposites[msg.sender];
		id = id + 1;
		nOfDeposites[msg.sender] = id;
		depositeAmount[id][msg.sender] = _amount;
	 	depositeOwner[id][msg.sender] = msg.sender;
		depositeDeadline[id][msg.sender] = block.timestamp + ( numberOfdays * 1 days);
		emit DepositeMade( msg.sender, _amount, id);
		return id;
    }

	/**
	 * @dev Allow funds to be withdrawn at end of term.
	 */
    function withdrawCertificate(uint32 _id) public {
		uint32 id;
        id = nOfDeposites[msg.sender];
        require(id >= _id && _id > 0);	// check that _id is in range.

		address theOwner;
        theOwner = depositeOwner[_id][msg.sender];
        require(theOwner == msg.sender);					// You are the owner.
        require(block.timestamp >= depositeDeadline[_id][msg.sender]); 	// You'r deposite has reached term date.

		uint256 amount;
		amount = depositeAmount[_id][msg.sender];
		amount = amount + ( ( amount * pct ) / 1000000 );	// Pay the interest
		depositeAmount[_id][msg.sender] = 0;				// 0 left after withdrawl

		address payable to;
		to = payable(theOwner);								// convert type to payable

        to.transfer(amount);								// send them the $ plus interest
		emit DepositeMade( msg.sender, amount, _id);
    }









	/**
	 * @dev Allow funds to be withdrawn at end of term.
	 */
    function amountOnDeposite(uint32 _id) public view returns ( uint256 ) {
		uint32 id;
        id = nOfDeposites[msg.sender];
		if ( id > _id || id <= 0 ) {
			return ( 0 );
		}

		address theOwner;
        theOwner = depositeOwner[_id][msg.sender];
        if (theOwner != msg.sender) {
			return ( 0 );
		}

		uint256 amount;
		amount = depositeAmount[_id][msg.sender];

		return ( amount );
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
		emit ReceivedFunds(msg.sender, msg.value);
	}

	/**
	 * @dev payable receive.  The receive ether function is called whenever the call data
	 *      is empty (whether or not ether is received). This function is implicitly payable.
	 */
	receive() external payable {
		emit ReceivedFunds(msg.sender, msg.value);
    }

	/**
	 * @dev genReceiveFunds - generate a receive funds event.
	 */
	function genReceivedFunds () public payable {
		emit ReceivedFunds(msg.sender, msg.value);
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
