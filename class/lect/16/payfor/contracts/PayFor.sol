// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract PayFor {

	struct productPriceStruct {
		uint256 price;
		bool isValue;
	}

    address payable owner_address;
	event ReceivedFunds(address sender, uint256 value, uint256 application, uint256 loc);
	event Withdrawn(address to, uint256 amount);
	event SetProductPrice ( uint256 product, uint256 minPrice );
	event LogDepositReceived(address sender);

    uint256 internal nPayments;
    uint256 internal paymentID;

    address[] private listOfPayedBy;
    uint256[] private listOfPayments;
    uint256[] private payFor;

    mapping (uint256 => productPriceStruct) internal productMinPrice;

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

    /**
     * @dev set the minimum price for a product.  Emit SetProductPrice when a price is set.
     */
	function setProductPrice(uint256 productNumber, uint256 minPrice) public onlyOwner {
		productMinPrice[productNumber] = productPriceStruct ( minPrice, true );
		emit SetProductPrice ( productNumber, minPrice );
	}

    /**
     * @return true for funds received.  Emit a ReceivedFunds event.
     */
	function receiveFunds(uint256 forProduct) public payable returns(bool) {
		// Check that product is valid
		require(productMinPrice[forProduct].isValue, 'Invalid product');
		// Validate that the sender has payed for the prouct.
		require(productMinPrice[forProduct].price <= msg.value, 'Insufficient funds for product');

		uint256 pos;
		uint256 tot;
		nPayments++;
		pos = listOfPayments.length;
    	listOfPayedBy.push(msg.sender);
    	listOfPayments.push(msg.value);
    	payFor.push(forProduct);
		tot = totalByAccount[msg.sender];
		totalByAccount[msg.sender] = tot + msg.value;
    	emit ReceivedFunds(msg.sender, msg.value, forProduct, pos);
		return true;
	}

    /**
     * @return the total that has been payed by an account.
     */
	function getNPayments(address lookUp) public onlyOwner returns(uint256) {
		return ( totalByAccount[lookUp] );
	}

    /**
     * @return the number of paymetns.
     */
	function getNPayments() public onlyOwner payable returns(uint256) {
		return ( nPayments );
	}

    /**
     * @return the address that payeed with the payment amount and what was payed for.
     */
	function getPaymentInfo(uint256 n) public onlyOwner payable returns(address, uint256, uint256) {
		return ( listOfPayedBy[n], listOfPayments[n], payFor[n] );
	}
	
    /**
     * @dev widthdraw funds form the contract.
     */
	function withdraw( uint256 amount ) public onlyOwner returns(bool) {
		require(address(this).balance >= amount, "Insufficient Balance for withdrawl");
		address(owner_address).transfer(amount);
		emit Withdrawn(owner_address, amount);
		return true;
	}

    /**
     * @return the amount of funds that can be withdrawn.
     */
	function getBalanceContract() public view onlyOwner returns(uint256){
		return address(this).balance;
	}

    /**
     * @return Catch and save funds for abstrc transfer.
     */
	function() external payable {
		require(msg.data.length == 0);
		emit LogDepositReceived(msg.sender);
	}

}
