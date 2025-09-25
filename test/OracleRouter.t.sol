// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "forge-std/Test.sol";
import {OracleRouter} from "../src/oracle/OracleRouter.sol";

contract DummyFeed {
    uint8 public decimalsValue = 8;
    uint256 public updatedAt = block.timestamp;

    function latestRoundData() external view returns (uint80, int256, uint256, uint256, uint80) {
        return (0, int256(100_00000000), 0, updatedAt, 0); // 100 * 1e8
    }
    function decimals() external view returns (uint8) { return decimalsValue; }
}

contract OracleRouterTest is Test {
    OracleRouter router;
    DummyFeed feed;

    function setUp() public {
        router = new OracleRouter();
        feed = new DummyFeed();
        router.setPriceFeed(address(0xAAA), address(0xBBB), address(feed));
    }

    function testGetPriceScalesTo1e18() public view {
        (uint256 value, uint256 ts) = (router.getPrice(address(0xAAA), address(0xBBB)).value,
                                       router.getPrice(address(0xAAA), address(0xBBB)).lastUpdate);
        assertEq(value, 100e18); // scaled to 1e18
        assertTrue(ts != 0);
    }
}
