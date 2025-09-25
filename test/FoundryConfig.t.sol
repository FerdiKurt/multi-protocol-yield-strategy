// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "forge-std/Test.sol";

contract FoundryConfigTest is Test {
    function testEnvironmentWorks() public pure {
        assertTrue(true, "Foundry test env should run");
    }
}
