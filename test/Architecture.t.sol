// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "forge-std/Test.sol";
import {VaultStorage} from "../src/core/VaultStorage.sol";

contract VaultStorageHarness is VaultStorage {
    constructor(address admin, address asset_, address treasury_) VaultStorage(admin, asset_, treasury_) {}
    function pause() external onlyRole(keccak256("ROLE_ADMIN")) { _pause(); }
    function unpause() external onlyRole(keccak256("ROLE_ADMIN")) { _unpause(); }
}

contract ArchitectureTest is Test {
    VaultStorageHarness vault;

    function setUp() public {
        vault = new VaultStorageHarness(address(this), address(0xA11CE), address(0xFEE));
    }

    function testInitialConfig() public  view{
        assertEq(vault.asset(), address(0xA11CE));
        assertEq(vault.treasury(), address(0xFEE));
    }

    function testPauseUnpause() public {
        vault.pause();
        assertTrue(vault.paused());
        vault.unpause();
        assertTrue(!vault.paused());
    }
}
