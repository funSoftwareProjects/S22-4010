
m4_include(../../../setup.m4)

Lecture 35 - Alternative to Solidity
====================================

## in the news


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


