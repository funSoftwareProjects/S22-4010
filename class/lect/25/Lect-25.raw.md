
m4_include(../../../setup.m4)

# Lecture 25 - Chain Interoperability - Patterns in languages

## Object oriented 

Yes!  Multiple inheritance. 

```
contract SignData is Ownable {
```

Go is not object oriented.

This means constructors.

```
	constructor() {
	}
```

Or with values that it sets

```
	constructor(uint256 _pct) {
        owner_address = payable(msg.sender);
		pct  = _pct; // 1000000 times the yearly percentage rate
		...
```

These values come from the "migration" JavaScript code.

			
```
const FixedTermDesposite = artifacts.require("FixedTermDesposite");

module.exports = function (deployer) {
	deployer.deploy(FixedTermDesposite, 20000); // 2% Per Year * 1000000 = 20000
};
```

## Data Declaration

```
    address payable owner_address;
    uint256 pct;				// Payment for Deposite
    uint256 numberOfdays;		// Payment can be withdrawn after X days.

	mapping(address => uint256) nOfDeposites; // Your Deposite ID
```

Data that is not a "constant" is saved from call to call over time.
Data is expensive.

<div class="pagebreak"></div>

## Dictionary

Solidity dictionaries - are multi-level maps.

```
	mapping(address => uint256) nOfDeposites; // Your Deposite ID
```

It is important to note that it will return a "default" value for all
possible inputs - so a non-existent address will return a 0 in this
case.

You can have a map to a map to a value.

```
	mapping(uint256 => mapping(address => uint256)) depositeAmount;
```

The access to these is the same as an array.

```
	...
        id = nOfDeposites[msg.sender];
	...
        theOwner = depositeOwner[_id][msg.sender];
	...
```

## Output

Nope.

No output.

Use "events" instead.

Declare an event

```
	event ReceivedFunds(address sender, uint256 value);
```

and generate the event to the log

```
	emit ReceivedFunds(msg.sender, msg.value);
```

<div class="pagebreak"></div>

In the test code these can be dumped out with

```
var tx = await sd.depositCertificate ( amount, {"value":amount} );
console.log ( "tx=", tx );
console.log ( "tx.logs = ", tx.logs );
for ( var i = 0, mx = tx.logs.length; i < mx; i++ ) {
	if ( tx.logs[i].event == 'DepositeMade' ) {
		console.log ( "For DepositeMoade event tx.logs["+i+"].args = ", tx.logs[i].args );
		var r = tx.logs[i].args;
		console.log ( "    .who = ", r.who );
		console.log ( "    .id = ", r.id.toString() );
		console.log ( "    .amount = ", r.amount.toString() );
		assert.equal(r.id.toString(),"1","Should have an ID of 1");
		assert.equal(r.amount.toString(),"1000000","Should have a depoiste of 1000000");
	}
}
```

## Functions/Methods

Functions that "change" the data require "gas":

```
	...
    function depositCertificate(uint256 _amount) public payable returns ( uint256 ) {
	...
    function withdrawCertificate(uint256 _id) public {
	...
```
    
If a function is a "view" then it is local and "free":

```
	function amountOnDeposite(uint256 _id) public view returns ( uint256 ) {
```

## Remember to have functions to do standard things like 'withdraw'

```
	function withdraw( uint256 amount ) public onlyOwner returns(bool) {
```






## Example Fixed Term Deposit

This is like a Certificate of Deposit (CD) at a bank.

```
m4_include(./eth/contracts/FixedTermDesposite.sol.nu)
```


