// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "forge-std/Test.sol";
import {VaultCore} from "../src/core/VaultCore.sol";
import {Roles} from "../src/core/Roles.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MockERC20 is ERC20 {
    constructor() ERC20("MockUSDC", "mUSDC") {}
    function mint(address to, uint256 amt) external { _mint(to, amt); }
    function decimals() public pure override returns (uint8) { return 18; }
}

contract VaultCoreTest is Test {
    MockERC20 usdc;
    VaultCore vault;

    address admin = address(this);
    address treasury = address(0xFEE);
    address alice = address(0xA11CE);
    address bob = address(0xB0B);

    function setUp() public {
        usdc = new MockERC20();
        vault = new VaultCore(admin, usdc, treasury, "DYOVault", "DYOV");
        usdc.mint(alice, 1_000e18);
        vm.startPrank(alice);
        usdc.approve(address(vault), type(uint256).max);
        vm.stopPrank();
    }

    function test_DepositMintWithdrawRedeem() public {
        vm.startPrank(alice);
        uint256 shares = vault.deposit(500e18, alice);
        assertEq(shares, 500e18);
        assertEq(vault.totalAssets(), 500e18);
        assertEq(vault.balanceOf(alice), 500e18);

        // mint path
        uint256 assetsFor200 = vault.previewMint(200e18);
        uint256 assetsSpent = vault.mint(200e18, alice);
        assertEq(assetsSpent, assetsFor200);
        assertEq(vault.totalAssets(), 700e18);
        assertEq(vault.balanceOf(alice), 700e18);
        vm.stopPrank();

        // withdraw 100 to bob by alice
        vm.startPrank(alice);
        uint256 burned = vault.withdraw(100e18, bob, alice);
        assertEq(burned, 100e18);
        assertEq(vault.totalAssets(), 600e18);
        assertEq(vault.balanceOf(alice), 600e18);
        vm.stopPrank();

        // redeem 50 shares to bob
        vm.startPrank(alice);
        uint256 got = vault.redeem(50e18, bob, alice);
        assertEq(got, 50e18);
        assertEq(vault.totalAssets(), 550e18);
        assertEq(vault.balanceOf(alice), 550e18);
        vm.stopPrank();
    }

    function test_TVLCap() public {
        vault.setTVLCap(400e18);
        vm.startPrank(alice);
        vault.deposit(300e18, alice); // ok
        vm.expectRevert();
        vault.deposit(200e18, alice); // would exceed cap
        vm.stopPrank();
    }

