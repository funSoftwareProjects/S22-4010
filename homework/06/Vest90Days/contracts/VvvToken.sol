// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC777/ERC777.sol";

contract VvvToken is Ownable, ERC777 {
	/**
     * @dev Constructor that gives msg.sender all of existing tokens.
     */
    constructor () ERC777("VvvToken", "VVV", new address[](0)) {
        // _mint(msg.sender, msg.sender, 100000000000 * 10 ** 18, "", "");
        _mint(msg.sender, 100000000000 * 10 ** 18, "", "");
    }
}
