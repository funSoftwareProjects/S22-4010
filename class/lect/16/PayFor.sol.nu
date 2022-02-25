  1: pragma solidity >=0.4.21 <0.6.0;
  2: 
  3: import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
  4: 
  5: contract PayFor is Ownable {
  6: 
  7:     address payable owner_address;
  8:     event ReceivedFunds(address sender, uint256 value, uint256 application, uint256 loc);
  9:     event Withdrawn(address to, uint256 amount);
 10: 
 11:     uint256 internal nPayments;
 12:     uint256 internal paymentID;
 13: 
 14:     address[] private listOfPayedBy;
 15:     uint256[] private listOfPayments;
 16:     uint256[] private payFor;
 17: 
 18:     mapping (address => uint256) internal totalByAccount;
 19: 
 20:     constructor() public {
 21:         owner_address = msg.sender;
 22:         nPayments = 0;
 23:     }
 24: 
 25:     function ReceiveFunds(uint256 forProduct) public payable returns(bool) {
 26:         nPayments++;
 27:         uint256 pos;
 28:         pos = listOfPayments.length;
 29:         listOfPayedBy.push(msg.sender);
 30:         listOfPayments.push(msg.value);
 31:         payFor.push(forProduct);
 32:         uint256 tot;
 33:         tot = totalByAccount[msg.sender];
 34:         totalByAccount[msg.sender] = tot + msg.value;
 35:         emit ReceivedFunds(msg.sender, msg.value, forProduct, pos);
 36:         return true;
 37:     }
 38: 
 39:     function getNPayments() public onlyOwner payable returns(uint256) {
 40:         return ( nPayments );
 41:     }
 42: 
 43:     function getPaymentInfo(uint256 n) public onlyOwner payable returns(address, uint256, uint256) {
 44:         return ( listOfPayedBy[n], listOfPayments[n], payFor[n] );
 45:     }
 46:     
 47:     function withdraw( uint256 amount ) public onlyOwner returns(bool) {
 48:         require(amount <= address(this).balance, "Insufficient funds for witdrawl");
 49:         address(owner_address).transfer(amount);
 50:         emit Withdrawn(owner_address, amount);
 51:         return true;
 52:     }
 53: 
 54:     function getBalanceContract() public view onlyOwner returns(uint256){
 55:         return address(this).balance;
 56:     }
 57: }
