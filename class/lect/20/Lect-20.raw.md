
m4_include(../../../setup.m4)

Lecture 20 - Smart Contracts - Standard Contracts (ERC-20)
==





## Standard ERC-20 Contract

### SimpleToken ERC20 Interface

| Method Name         | Const | $ | Params                                                               |
|---------------------|-------|---|----------------------------------------------------------------------|
| Approval            | event |   | `( address owner, address spender, uint256 value )`                  |
| INITIAL_SUPPLY      | const |   | `() returns ( uint256 )`                                             |
| Transfer            | event |   | `( address from, address to, uint256 value )`                        |
| allowance           | const |   | `( address _owner, address _spender ) returns ( uint256 )`           |
| approve             | Tx    |   | `( address _spender, uint256 _value ) returns ( bool )`              |
| balanceOf           | const |   | `( address _owner ) returns ( uint256 )`                             |
| decimals            | const |   | `() returns ( uint8 )`                                               |
| decreaseApproval    | Tx    |   | `( address _spender, uint256 _subtractedValue ) returns ( bool )`    |
| increaseApproval    | Tx    |   | `( address _spender, uint256 _addedValue ) returns ( bool )`         |
| name                | const |   | `() returns ( string )`                                              |
| symbol              | const |   | `() returns ( string )`                                              |
| totalSupply         | const |   | `() returns ( uint256 )`                                             |
| transfer            | Tx    |   | `( address _to, uint256 _value ) returns ( bool )`                   |
| transferFrom        | Tx    |   | `( address _from, address _to, uint256 _value ) returns ( bool )`    |
| constructor         | ()    |   |                                                                      |


### SimpleToken Ours derived from StandardToken

```
m4_include(./eth/contracts/Simple777Token.sol.nu)
m4_comment([[[
// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/token/ERC777/ERC777.sol";

/**
 * @title Simple777Token
 * @dev Very simple ERC777 Token example, where all tokens are pre-assigned to the creator.
 * Note they can later distribute these tokens as they wish using `transfer` and other
 * `ERC20` or `ERC777` functions.
 * Based on https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/examples/SimpleToken.sol
 */
contract Simple777Token is ERC777 {

    /**
     * @dev Constructor that gives msg.sender all of existing tokens.
     */
    constructor () ERC777("Simple777Token", "S7", new address[](0)) {
        _mint(msg.sender, 10000 * 10 ** 18, "", "", true);
    }
}
]]])
```

<div class="pagebreak"></div>

