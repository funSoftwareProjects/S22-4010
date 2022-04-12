// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

// import "./Ownable.sol";
import "zeppelin-solidity/contracts/ownership/Ownable.sol";


contract PayFor is Ownable {

	struct productPriceStruct {
		uint256 price;
		bool isValue;
	}
	struct paymentsStruct {
		address listOfPayedBy;
		uint256 listOfPayments;
		uint256 payFor;
	}

	event ReceivedFunds(address sender, uint256 value, uint256 application, uint256 loc);
	event Withdrawn(address to, uint256 amount);
	event SetProductPrice ( uint256 product, uint256 minPrice );
	event LogDepositReceived(address sender);

	paymentsStruct[] private paymentsFor;
    mapping (uint256 => productPriceStruct) internal productMinPrice;
    uint256[] private listOfSKU;
	uint public balance;

	constructor() Ownable() public {
	}

    /**
     * @dev set the minimum price for a product.  Emit SetProductPrice when a price is set.
     */
	function setProductPrice(uint256 SKU, uint256 minPrice) public onlyOwner {
		productMinPrice[SKU] = productPriceStruct ( minPrice, true );
		listOfSKU.push(SKU);
		emit SetProductPrice ( SKU, minPrice );
	}

    /**
     * @return true for funds received.  Emit a ReceivedFunds event.
     */
	function receiveFunds(uint256 forProduct) public payable returns(bool) {
		// Check that product is valid
		require(productMinPrice[forProduct].isValue, 'Invalid product');
		// Validate that the sender has payed for the prouct.
		require(productMinPrice[forProduct].price <= msg.value, 'Insufficient funds for product');

		balance += msg.value;
		uint256 pos;
		pos = paymentsFor.length;
		paymentsFor.push ( paymentsStruct ( msg.sender, msg.value, forProduct ) );
    	emit ReceivedFunds(msg.sender, msg.value, forProduct, pos);
		return true;
	}

    /**
     * @return the number of paymetns.
     */
	function getNPayments() public onlyOwner view returns(uint256) {
		return ( paymentsFor.length );
	}

    /**
     * @return the address that payeed with the payment amount and what was payed for.
     */
	function getPaymentInfo(uint256 n) public onlyOwner view returns(address, uint256, uint256) {
		require(n >= 0 && n < paymentsFor.length, 'Invalid entry');
		return ( paymentsFor[n].listOfPayedBy, paymentsFor[n].listOfPayments, paymentsFor[n].payFor );
	}
	
    /**
     * @return the number of Products (SKUs).
     */
	function getNSKU() public view returns(uint256) {
		return ( listOfSKU.length );
	}

    /**
     * @return the price for the nth SKU and its product number.
     */
	function getSKUInfo(uint256 n) public view returns(uint256, uint256) {
		require(n >= 0 && n < listOfSKU.length, 'Invalid entry');
		uint256 sku = listOfSKU[n];
		return ( sku, productMinPrice[sku].price );
	}
	
    /**
     * @dev widthdraw funds form the contract.
     */
	function withdraw( uint256 amount ) public onlyOwner returns(bool) {
		// require(address(this).balance >= amount, "Insufficient Balance for withdrawl");
		require(balance >= amount, "Insufficient Balance for withdrawl");
		// address to0 = address ( Ownable.owner() );
		address to0 = address ( Ownable.owner );
		address payable to = address ( uint160(to0) );
		address(to).transfer(amount);
		balance -= amount;
		emit Withdrawn(to, amount);
		return true;
	}

    /**
     * @return the amount of funds that can be withdrawn.
     */
	function getBalanceContract() public view onlyOwner returns(uint256){
		// return address(this).balance;
		return balance;
	}

    /**
     * @return Catch and save funds for abstrc transfer.
     */
	function() external payable {
		require(msg.data.length == 0);
		emit LogDepositReceived(msg.sender);
	}

}
