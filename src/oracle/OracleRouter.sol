// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {IOracleRouter} from "../interfaces/internal/IOracleRouter.sol";
import {IChainlinkAggregator} from "../interfaces/external/IChainlinkAggregator.sol";
import {IYieldOracle} from "../interfaces/internal/IYieldOracle.sol";
import {OracleTypes} from "./libs/OracleTypes.sol";

/// @notice Minimal router that composes price feeds (Chainlink) and yield oracles.
/// @dev Staleness checks & fallback wiring kept simple for Week 1; expanded in Week 4.
contract OracleRouter is IOracleRouter {
    error OracleStale();
    error InvalidFeed();

    uint256 public constant STALE_AFTER = 1 hours;

    mapping(bytes32 => address) public priceFeed;   // keccak256(base,quote) => Chainlink feed
    mapping(bytes32 => address) public yieldOracle; // marketId => oracle

    event PriceFeedSet(bytes32 indexed key, address indexed feed);
    event YieldOracleSet(bytes32 indexed marketId, address indexed oracle);

    function setPriceFeed(address base, address quote, address feed) external {
        bytes32 key = keccak256(abi.encodePacked(base, quote));
        priceFeed[key] = feed;
        emit PriceFeedSet(key, feed);
    }

    function setYieldOracle(bytes32 marketId, address oracle) external {
        yieldOracle[marketId] = oracle;
        emit YieldOracleSet(marketId, oracle);
    }

    function getPrice(address base, address quote) external view override returns (OracleTypes.Price memory p) {
        bytes32 key = keccak256(abi.encodePacked(base, quote));
        address feed = priceFeed[key];
        if (feed == address(0)) revert InvalidFeed();

        (, int256 answer,, uint256 updatedAt,) = IChainlinkAggregator(feed).latestRoundData();
        if (updatedAt + STALE_AFTER < block.timestamp) revert OracleStale();

        uint8 dec = IChainlinkAggregator(feed).decimals();
        // scale to 1e18
        uint256 scaled = uint256(answer) * 10 ** (18 - dec);
        p = OracleTypes.Price({ value: scaled, lastUpdate: updatedAt });
    }

    function getAPY(bytes32 marketId) external view override returns (OracleTypes.YieldRate memory y) {
        address yo = yieldOracle[marketId];
        if (yo == address(0)) {
            return OracleTypes.YieldRate({ apyRay: 0, lastUpdate: 0 });
        }
        y = IYieldOracle(yo).getAPY(marketId);
    }
}
