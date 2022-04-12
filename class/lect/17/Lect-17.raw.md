
m4_include(../../../setup.m4)

Lecture 17 - Solidity Language
==

## Class

```
// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract PayFor {
```

or with inheritance

```
// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./Ownable.sol";

contract PayFor is Ownable {
```

For passing parameters to constructor:

```
// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.8.0;

contract Parent {
    public string aName;
    private uint256 aNumber;

    constructor(uint256 _importantNumber, string _name) public {
		aNumber = _imporantNumber;
        aName = _name;
    }
}
```

```
// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.8.0;

contract ParentTwo {
    private uint256 aNumber;

    constructor(uint256 _importantNumber) public {
		aNumber = _imporantNumber;
    }
}
```

<div class="pagebreak"></div>

```
// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.8.0;

import "./Parent.sol";
import "./ParentTwo.sol";

contract Child is Parent, ParentTwo {

    constructor(uint256 valToParent) Parent(valToParent,"constantToParent"), ParentTwo(valToParent) public {
         // Child construction code goes here
    }
}
```

With the corresponding tests code (in JavaScript)

```
...
	beforeEach(async () => {
		child = await Child.new(1234);
	});
...
```


Let's take a look at Ownable:

```
m4_include(payfor4/contracts/Ownable.sol.nu)
```



<div class="pagebreak"></div>

And now how it is used:

```
m4_include(payfor4/contracts/PayFor.sol.nu)
```



m4_comment([[[

https://michalzalecki.com/ethereum-test-driven-introduction-to-solidity-part-2/
]]])

<div class="pagebreak"></div>

```
Result {
  '0': '0x861B18623d1585eeb1aE94D0852313c366E992e8',
  '1': BN {
    negative: 0,
    words: [ 4, <1 empty item> ],
    length: 1,
    red: null
  },
  '2': BN {
    negative: 0,
    words: [ 10, <1 empty item> ],
    length: 1,
    red: null
  }
}

```


Events during this test (remember that they are cumulative)

```
    Events emitted during test:
    ---------------------------

    PayFor.OwnershipTransferred(
      previousOwner: <indexed> 0x0000000000000000000000000000000000000000 (type: address),
      newOwner: <indexed> 0xbA241C04969585671D0dc927f354eB2938511b6f (type: address)
    )

    PayFor.SetProductPrice(
      product: 8 (type: uint256),
      minPrice: 2 (type: uint256)
    )

    PayFor.SetProductPrice(
      product: 10 (type: uint256),
      minPrice: 4 (type: uint256)
    )

    PayFor.ReceivedFunds(
      sender: 0x861B18623d1585eeb1aE94D0852313c366E992e8 (type: address),
      value: 4 (type: uint256),
      application: 10 (type: uint256),
      loc: 0 (type: uint256)
    )

```

## Back to code
	
```
	function setProductPrice(uint256 SKU, uint256 minPrice) public onlyOwner {
```

## To install the OpenZepplin stuff.

```
$  npm install --save-exact zeppelin-solidity
```

And to import it into the code:

```
import "zeppelin-solidity/contracts/ownership/Ownable.sol";
```

