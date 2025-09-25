// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

library OracleTypes {
    struct Price {
        uint256 value;      // scaled by 1e18
        uint256 lastUpdate; // unix timestamp
    }

    struct YieldRate {
        // Annualized net APY in 1e18 (e.g., 5% => 0.05e18)
        int256 apyRay;
        uint256 lastUpdate;
    }
}
