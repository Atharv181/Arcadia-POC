/**
 * Created by Pragma Labs
 * SPDX-License-Identifier: BUSL-1.1
 */
pragma solidity 0.8.22;

import {Tranche} from "src/Tranche.sol";
import {Script, console} from "lib/forge-std/src/Script.sol";
import {DeployLendingPool} from "script/LendingPool.s.sol";
import {LendingPool} from "src/LendingPool.sol";
import {SimpleToken} from "src/ERC20token.sol";

contract DeployTranche is Script{

    Tranche tranche;
    LendingPool lendingPool;
    SimpleToken token;

    function run() external returns(Tranche, LendingPool, SimpleToken) {

        DeployLendingPool deployLedingPool = new DeployLendingPool();
        (lendingPool, token) = deployLedingPool.run();
        
        vm.startBroadcast();

        tranche = new Tranche(address(lendingPool), uint256(500), "Junior", "JR");
    
        vm.stopBroadcast();

        console.log("Lendingpool addr: ", address(lendingPool));
        console.log("Tranche addr: ", address(tranche));

        return (tranche, lendingPool, token);
       
    }
}