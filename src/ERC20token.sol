/**
 * Created by Pragma Labs
 * SPDX-License-Identifier: BUSL-1.1
 */
pragma solidity 0.8.22;

import { ERC20 } from "../lib/solmate/src/mixins/ERC4626.sol";


contract SimpleToken is ERC20 {
    // Initialize the ERC20 token with a name, symbol, and decimals.
    constructor(
        string memory _name,
        string memory _symbol,
        uint8 _decimals
    ) ERC20(_name, _symbol, _decimals) {

        owner = msg.sender;

        _mint(owner, 10_000e18);
    }

    address public owner;

    // A function to mint tokens to an address.
    // Only callable by the owner of the contract for simplicity.
    // In a real-world scenario, you would have more complex access control.
    function mint(address to, uint256 amount) external {
        // Ensure the caller is the contract owner
        require(msg.sender == owner, "Only owner can mint");

        // Use the internal _mint function provided by solmate's ERC20
        _mint(to, amount);
    }

    // Optional: If you want to allow users to burn their tokens
    function burn(uint256 amount) external {
        // Use the internal _burn function provided by solmate's ERC20
        _burn(msg.sender, amount);
    }

   
}