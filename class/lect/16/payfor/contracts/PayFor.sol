// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract PayFor {

    address payable owner_address;
	event ReceivedFunds(address sender, uint256 value, uint256 application, uint256 loc);
	event Withdrawn(address to, uint256 amount);

    uint256 internal nPayments;
    uint256 internal paymentID;

    address[] private listOfPayedBy;
    uint256[] private listOfPayments;
    uint256[] private payFor;

    mapping (address => uint256) internal totalByAccount;

	constructor() public {
        owner_address = msg.sender;
    	nPayments = 0;
	}

    /**
     * @return the address of the owner.
     */
    function owner() public view returns (address) {
        return owner_address;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(isOwner());
        _;
    }

    /**
     * @return true if `msg.sender` is the owner of the contract.
     */
    function isOwner() public view returns (bool) {
        return msg.sender == owner_address;
    }

	function ReceiveFunds(uint256 forProduct) public payable returns(bool) {
		nPayments++;
		uint256 pos;
		pos = listOfPayments.length;
    	listOfPayedBy.push(msg.sender);
    	listOfPayments.push(msg.value);
    	payFor.push(forProduct);
		uint256 tot;
		tot = totalByAccount[msg.sender];
		totalByAccount[msg.sender] = tot + msg.value;
    	emit ReceivedFunds(msg.sender, msg.value, forProduct, pos);
		return true;
	}

	function getNPayments() public onlyOwner payable returns(uint256) {
		return ( nPayments );
	}

	function getPaymentInfo(uint256 n) public onlyOwner payable returns(address, uint256, uint256) {
		return ( listOfPayedBy[n], listOfPayments[n], payFor[n] );
	}
	
	function withdraw( uint256 amount ) public onlyOwner returns(bool) {
		require(amount <= address(this).balance, "Insufficient funds for witdrawl");
		address(owner_address).transfer(amount);
		emit Withdrawn(owner_address, amount);
		return true;
	}

	function getBalanceContract() public view onlyOwner returns(uint256){
		return address(this).balance;
	}

}
