
m4_include(../.././setup.m4)

## Assignment 6 - Develop an employee vesting contract

300pts  <br>
Due Apr 11

m4_comment([[[
     April 2022       
Su Mo Tu We Th Fr Sa  
                1  2  
 3  4  5  6  7  8  9  
10 11 12 13 14 15 16  
17 18 19 20 21 22 23  
24 25 26 27 28 29 30  
]]])


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
m4_include(Vest90Days/contracts/Vest90Days.sol.nu)
```

Develop the test of this contract (the TODO's) and a set of
test for it.


