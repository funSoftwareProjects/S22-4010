
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



And now how it is used:

```
m4_include(payfor4/contracts/PayFor.sol.nu)
```



m4_comment([[[

https://michalzalecki.com/ethereum-test-driven-introduction-to-solidity-part-2/
]]])
