/**
 * Created by Pragma Labs
 * SPDX-License-Identifier: BUSL-1.1
 */
pragma solidity 0.8.22;

import {LendingPool} from "src/LendingPool.sol";
import {Script, console} from "lib/forge-std/src/Script.sol";
import {SimpleToken} from "src/ERC20token.sol";

contract DeployLendingPool is Script{

    LendingPool lendingPool;
    SimpleToken token;

    function run() external returns(LendingPool, SimpleToken) {

        vm.startBroadcast();

        token = new SimpleToken("TOMATO", "TMT", 18);
        lendingPool = new LendingPool(address(0), token , address(0), address(0), address(0));
    
        vm.stopBroadcast();

        return (lendingPool, token);
    }
}