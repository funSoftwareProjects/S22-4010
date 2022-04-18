
m4_include(../../../setup.m4)

Lecture 35 - Alternative to Solidity
====================================

## in the news

1. Axie Infinite, $625 million (150,000 ETH) theft was done by the Lazarus criminal group.
This is the same folks that did the WanaCry Raonsomware - and it is a state sponsored
North Korea entity.
2. Ethereum-based Stablecoin protocol Beanstalk looses $182 million - goes from stable
to 0.

## Vyper

There is "vyper" a python like contract language that is the most popular alternative to
Solidity.

From the vyper docs:

<dd>
	Vyper is a contract-oriented, pythonic programming language that targets the Ethereum Virtual Machine (EVM).
</dd>

Vyper was specifically developed to address the security issues which were there in Solidity.
It is modeled after python, as you might have guessed from the name. 

Vyper has dropped some Object-Oriented concepts such as Inheritance.   This makes the contracts
muck easier to read - you don't have to chaise all over to find the methods.   Also it eliminates
problems with dependencies on foreign code.

Vyper goals
1. Make contracts auditable
2. Make contracts more secure
3. Make contracts less error-prone
4. Make contracts easier to understand
5. Make it easier to learn the contract programming language

Vyper is strongly typed and always uses math operations that are
"safe".

Vyper adds:

1. Bounds and overflow checking - always on.
2. Decidability:  With vyper is is possible to compute a precise upper bound on the runtime (therefore the "gas") for all functions.


Vyper skips:
1. modifiers
2. class inheritance
3. recursive calls
4. dynamic data types - no unbounded arrays
5. Overflow
6. No Infinite Loops 
7. Assembly support -- this means no "proxy" contracts.   But you can build a standard Solidity contract that is a proxy and call a vyper contract.




To Install it you need python - I am using Anaconda Python.  
[https://www.anaconda.com/products/distribution](https://www.anaconda.com/products/distribution)

Then:

```
$ pip install vyper
```

You should be able to get the version of `vyper` with.

```
$ vyper --version
```

Files in `vyper` are `.vy` files.

You still need a Solidity `solc` install to be able to use truffle and 
ganache.  So will need to have:

```
m4_include(truffle-config.js)
```



## Really Simple Contract

```
m4_include(eth/contracts/VyperStorage.vy.nu)
m4_comment([[[
  1: # Minimual contract that stores a value
  2: 
  3: stored_data: uint256
  4: 
  5: @external
  6: def set(new_value : uint256):
  7:     self.stored_data = new_value
  8: 
  9: @external
 10: @view
 11: def get() -> uint256:
 12:     return self.stored_data
]]])
```

1. Comments start with a '#'
2. No special stuff for declaring the licenses for the contract
3. No special pragma to define the version of the language
4. No name for the contract - it is the file name.
5. Contract-global data is defined in the outer scope (lines 2..4)
6. External functions are declared "external" with a "decorator", `@external`.  (Line 5)
7. Functions use `def name` (line 6)
8. Declarations are `name : type` (line 6)
9. Data is referred to with `self.` (line 7)
9. non-transactional functions (views) are declared with a decorator, `@view`.   (Line 10)
9. The return type for a function is specified with `-> type` (line 11)
9. Way fewer reserved words - just "return" (line 12)


```
m4_include(eth/test/vyperStorage.js.nu)
m4_comment([[[
  1: const VyperStorage = artifacts.require("VyperStorage");
  2: 
  3: contract("VyperStorage", () => {
  4:   it("...should store the value 89.", async () => {
  5:     const storage = await VyperStorage.deployed();
  6: 
  7:     // Set value of 89
  8:     await storage.set(89);
  9: 
 10:     // Get stored value
 11:     const storedData = await storage.get();
 12: 
 13:     assert.equal(storedData, 89, "The value 89 was not stored.");
 14:   });
 15: });
]]])
```

testing...
1. Still using JS and Mocha.
2. Very little difference between the test.
3. Line 1 - load the contract
4. Line 7 - call to method - transaction
4. Line 11 - call to view 
4. Line 13 - check data is correct



