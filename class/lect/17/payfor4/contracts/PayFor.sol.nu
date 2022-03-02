  1: // SPDX-License-Identifier: MIT
  2: pragma solidity >=0.4.22 <0.9.0;
  3: 
  4: // import "./Ownable.sol";
  5: import "zeppelin-solidity/contracts/ownership/Ownable.sol";
  6: 
  7: 
  8: contract PayFor is Ownable {
  9: 
 10:     struct productPriceStruct {
 11:         uint256 price;
 12:         bool isValue;
 13:     }
 14:     struct paymentsStruct {
 15:         address listOfPayedBy;
 16:         uint256 listOfPayments;
 17:         uint256 payFor;
 18:     }
 19: 
 20:     event ReceivedFunds(address sender, uint256 value, uint256 application, uint256 loc);
 21:     event Withdrawn(address to, uint256 amount);
 22:     event SetProductPrice ( uint256 product, uint256 minPrice );
 23:     event LogDepositReceived(address sender);
 24: 
 25:     paymentsStruct[] private paymentsFor;
 26:     mapping (uint256 => productPriceStruct) internal productMinPrice;
 27:     uint256[] private listOfSKU;
 28:     uint public balance;
 29: 
 30:     constructor() Ownable() public {
 31:     }
 32: 
 33:     /**
 34:      * @dev set the minimum price for a product.  Emit SetProductPrice when a price is set.
 35:      */
 36:     function setProductPrice(uint256 SKU, uint256 minPrice) public onlyOwner {
 37:         productMinPrice[SKU] = productPriceStruct ( minPrice, true );
 38:         listOfSKU.push(SKU);
 39:         emit SetProductPrice ( SKU, minPrice );
 40:     }
 41: 
 42:     /**
 43:      * @return true for funds received.  Emit a ReceivedFunds event.
 44:      */
 45:     function receiveFunds(uint256 forProduct) public payable returns(bool) {
 46:         // Check that product is valid
 47:         require(productMinPrice[forProduct].isValue, 'Invalid product');
 48:         // Validate that the sender has payed for the prouct.
 49:         require(productMinPrice[forProduct].price <= msg.value, 'Insufficient funds for product');
 50: 
 51:         balance += msg.value;
 52:         uint256 pos;
 53:         pos = paymentsFor.length;
 54:         paymentsFor.push ( paymentsStruct ( msg.sender, msg.value, forProduct ) );
 55:         emit ReceivedFunds(msg.sender, msg.value, forProduct, pos);
 56:         return true;
 57:     }
 58: 
 59:     /**
 60:      * @return the number of paymetns.
 61:      */
 62:     function getNPayments() public onlyOwner view returns(uint256) {
 63:         return ( paymentsFor.length );
 64:     }
 65: 
 66:     /**
 67:      * @return the address that payeed with the payment amount and what was payed for.
 68:      */
 69:     function getPaymentInfo(uint256 n) public onlyOwner view returns(address, uint256, uint256) {
 70:         require(n >= 0 && n < paymentsFor.length, 'Invalid entry');
 71:         return ( paymentsFor[n].listOfPayedBy, paymentsFor[n].listOfPayments, paymentsFor[n].payFor );
 72:     }
 73:     
 74:     /**
 75:      * @return the number of Products (SKUs).
 76:      */
 77:     function getNSKU() public view returns(uint256) {
 78:         return ( listOfSKU.length );
 79:     }
 80: 
 81:     /**
 82:      * @return the price for the nth SKU and its product number.
 83:      */
 84:     function getSKUInfo(uint256 n) public view returns(uint256, uint256) {
 85:         require(n >= 0 && n < listOfSKU.length, 'Invalid entry');
 86:         uint256 sku = listOfSKU[n];
 87:         return ( sku, productMinPrice[sku].price );
 88:     }
 89:     
 90:     /**
 91:      * @dev widthdraw funds form the contract.
 92:      */
 93:     function withdraw( uint256 amount ) public onlyOwner returns(bool) {
 94:         // require(address(this).balance >= amount, "Insufficient Balance for withdrawl");
 95:         require(balance >= amount, "Insufficient Balance for withdrawl");
 96:         // address to0 = address ( Ownable.owner() );
 97:         address to0 = address ( Ownable.owner );
 98:         address payable to = address ( uint160(to0) );
 99:         address(to).transfer(amount);
100:         emit Withdrawn(to, amount);
101:         return true;
102:     }
103: 
104:     /**
105:      * @return the amount of funds that can be withdrawn.
106:      */
107:     function getBalanceContract() public view onlyOwner returns(uint256){
108:         // return address(this).balance;
109:         return balance;
110:     }
111: 
112:     /**
113:      * @return Catch and save funds for abstrc transfer.
114:      */
115:     function() external payable {
116:         require(msg.data.length == 0);
117:         emit LogDepositReceived(msg.sender);
118:     }
119: 
120: }
