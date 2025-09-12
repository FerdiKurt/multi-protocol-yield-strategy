// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {OracleTypes} from "../../oracle/libs/OracleTypes.sol";

interface IYieldOracle {
    /// @notice Returns annualized net APY for a protocol/market (1e18 scaled).
    function getAPY(bytes32 marketId) external view returns (OracleTypes.YieldRate memory);
}
