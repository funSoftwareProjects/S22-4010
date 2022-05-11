<style>
.half { height: 200px; }
.halfLess { height: 180px; }
.half170 { height: 170px; }
</style>


<style>
.pagebreak { page-break-before: always; }
.half { height: 200px; }
</style>
<style>
.pagebreak { page-break-before: always; }
.half { height: 200px; }
.markdown-body {
	font-size: 12px;
}
.markdown-body td {
	font-size: 12px;
}
</style>


Final: 4010, 5010 Cosci - Blockchain 
========================================

Your Name: `_____________________________________________`

Upload answer - Due May 13 at midnight.


## Short Essay Questions.  

1. (30pt) Explain a zero knowledge proof to a layman.  Provide an example of how a zero knowledge proof can be used.
<div class="halfLess">&nbsp;</div>

2. (30pt) How do blockchains create trust between non-trusting parties?
<div class="halfLess">&nbsp;</div>

3. (30pt) What is a blockchain? - Why is blockchain important? - What are blockchains used for? 
<div class="halfLess">&nbsp;</div><br><div class="pagebreak"> </div>

4. (30pt) What is a smart contract?  Provide an Example of what you would use one for.
<div class="half">&nbsp;</div>

5. (30pt) What is "mining" in the context of a blockchain system?  
<div class="half">&nbsp;</div>

6. (30pt) What are the good properties of using a blockchain as a database?  Compare to a relational database.
<div class="half">&nbsp;</div><br><div class="pagebreak"> </div>

7. (30pt) What are the bad properties of using a blockchain as a database?  Compare to a relational database.	
<div class="half170">&nbsp;</div>

8. (30pt) What are the bad properties of blockchain as a database?  Compare to a relational database.  
<div class="half170">&nbsp;</div>

9. (30pt) Why are blockchains (Ethereum, Bitcoin) a so slow?
<div class="half170">&nbsp;</div>

10. (30pt) Explain the Byzantine generals problem and how Threshold-ECDSA solves it.
<div class="half170">&nbsp;</div>

11. (20pt) Provide an elevator pitch (if you said it out loud you have about 30 seconds) to explain
why blockchain is an important technology.  Assume that your audience is moderately non-technical.




<div class="pagebreak"> </div>
## Coding:

1. Solidity - a simple contract to take the hash of a document.  (The code is on the last page of the test)<br>
	1. [20pt] When is the contract constructor run?<br><br>
	2. [20pt] Who can call the setPayment function on line 19?<br><br>
	3. [20pt] Explain what the 'newInfo' function performs (line 23 to 31)<br><br>
	4. [20pt] Explain what "gas" is and how that effects running of contracts<br><br>






<br><div class="pagebreak"> </div>
Simple Contract to Register Documents
============================

```
  1 pragma solidity >=0.4.25 <0.9.0;
  2 
  3 import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
  4 
  5 contract DocumentReg is Ownable {
  6   using SafeMath for uint256;
  7 
  8   mapping(bytes32 => bool) infoSet;
  9   mapping(bytes32 => address) infoOwner;
 10   mapping(bytes32 => string) infoData;
 11   mapping(bytes32 => string) infoName;
 12   mapping(address => uint256) infoNDocs;
 13   mapping(address => []bytes32) infoDocs;
 14 
 15   mapping(address => bool) isNotery;
 16   mapping(bytes32 => address) noterized;
 17 
 18   uint256 minPayment;
 19   address contractOwner;
 20 
 21   event DocumentSet(string, indexed bytes32, string);
 22   event DocumentOwner(indexed address, string, bytes32, string);
 23   event DocumentNoterized(string, bytes32, string, indexed address);
 24   event Transfer(address, address, uint256);
 25 
 26   constructor() {
 27     contractOwner = msg.sender;
 28     minPayment = 1;
 29   }
 30 
 31   function setPayment ( uint256 p ) public onlyOwner {
 32     minPayment = p;
 33   }
 34 
 35   function setNoterizer ( bytes32 aNotery ) public onlyOwner {
 36     isNotery[aNotery] = true;
 37   }
 38 
 39   function rmNoterizer ( bytes32 aNotery ) public onlyOwner {
 40     isNotery[aNotery] = false;
 41   }
 42 
 43   function newDocument ( string name, bytes32 infoHash, string info )
      public payable returns(bool) {
 44     require(!infoSet[infoHash], "already set, already has owner.");
 45     require(msg.value >= minPayment, "insufficient payment to set data.");
 46     infoSet[infoHash] = true;
 47     infoOwner[infoHash] = msg.sender;
 48     if ( infoNDocs[msg.sender] ) {
 49       infoNDocs[msg.sender] = infoNDocs[msg.sender] + 1;
 50     } else {
 51       infoNDocs[msg.sender] = 1;
 52     }
 53     infoDocs[msg.sender].push ( infoHash );
 54     infoData[infoHash] = info;
 55     infoName[infoHash] = name;
 56     emit DocumentSet(name, infoHash, info);
 57     emit DocumentOwner(msg.sender, name, infoHash, info);
 58     return true;
 59   }
 60 
 61   function noterizeDocument ( string name, bytes32 infoHash,
      string info ) public returns (bool) {
 62     require(infoSet[infoHash], "document not created set.");
 63     require(!isNotery[msg.sender], "not a registered notery.");
 64     noterized[infoHash] = msg.sender;
 65     emit DocumentNoterized(name, infoHash, info, msg.sender);
 66     return true;
 67   }
 68 
 69   /**
 70   * @dev transfer token for a specified address
 71   * @param _to The address to transfer to.
 72   * @param _value The amount to be transferred.
 73   */
 74   function transfer(address _to, uint256 _value) public returns (bool) {
 75     require(_to != address(0), "Invalid null address.");
 76     require(_value <= balances[msg.sender], "Amoutn to transfer is too large.");
 77 
 78     // SafeMath.sub will throw if there is not enough balance.
 79     balances[msg.sender] = balances[msg.sender].sub(_value);
 80     balances[_to] = balances[_to].add(_value);
 81     addToCapTable(_to);
 82     emit Transfer(msg.sender, _to, _value);
 83     return true;
 84   }
 85 
 86   /**
 87    * @dev withdraw transfers all of the existing funds from the contract to
         the owner of the contract.
 88    */
 89   function withdraw() public onlyOwner {
 90     contractOwner.transfer(address(this).balance);
 91   }
 92 
 93   // List Documents by Owner of Document
 94   function nDocuments() public view returns ( uint256 ) {
 95     return( infoNDocs[msg.sender] );
 96   }
 97   function getDocName ( uint256 nth ) public view returns ( string ) {
 98     require(nth >= 0  && nth < infoDocs[msg.sender].length, "nth out of range.");
 99     bytes32 v = infoDocs[nth];
100     return ( infoName[v] );
101   }
102   function getDocInfoHash ( uint256 nth ) public view returns ( bytes32 ) {
103     require(nth >= 0  && nth < infoDocs[msg.sender].length, "nth out of range.");
104     bytes32 v = infoDocs[nth];
105     return ( v );
106   }
107   function getDocInfo ( uint256 nth ) public view returns ( string ) {
108     require(nth >= 0  && nth < infoDocs[msg.sender].length, "nth out of range.");
109     bytes32 v = infoDocs[nth];
110     return ( infoData[v] );
111   }
112 
112 }
```
