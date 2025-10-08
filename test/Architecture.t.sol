// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "forge-std/Test.sol";
import {VaultStorage} from "../src/core/VaultStorage.sol";
import {Roles} from "../src/core/Roles.sol";

contract VaultStorageHarness is VaultStorage {
    constructor(address admin, address treasury_) VaultStorage(admin, treasury_) {}
    function pause() external onlyRole(Roles.ROLE_ADMIN) { _pause(); }
    function unpause() external onlyRole(Roles.ROLE_ADMIN) { _unpause(); }
}

contract ArchitectureTest is Test {
    VaultStorageHarness vault;

    function setUp() public {
        vault = new VaultStorageHarness(address(this), address(0xFEE));
    }

    function testInitialConfig() public view {
        assertEq(vault.treasury(), address(0xFEE));
    }

    function testPauseUnpause() public {
        vault.pause();
        assertTrue(vault.paused());
        vault.unpause();
        assertTrue(!vault.paused());
    }
}
