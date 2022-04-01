

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


## Assignment 6 - Develop an employee vesting contract

200pts  <br>
Due Apr 11




Build a contract that records when an employee starts
and how many tokens an employee has vested.  The vesting
schedule is a once-every-3-months schedule.  When the 
employee starts create an account for the employee, then
every 3 months calculate the amount of tokens that they
receive and transfer these from an ERC 20 / ERC 777 / ERC1155
contract to the employee.  After 2.5 years (10 quarters)
the employee is fully vested.

Create an ERC-20/777/1155 contract with 1 billion (1,000,000,000)
tokens as the company "tokens".  This is where you will transfer
your tokens from.   Each transfer is to the employee's account
in the ERC-20/777/1155 contract. 





File: Vest90Days.sol

```

// Vest 90 Days contrct - interacting with ERC-20/777/1155 base contract
// for Employee Vesting

contract Vest90Days {
}


```

Develop and write tests for this smart contract.


