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

