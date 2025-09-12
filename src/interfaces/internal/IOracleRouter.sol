// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {OracleTypes} from "../../oracle/libs/OracleTypes.sol";

interface IOracleRouter {
    function getPrice(address base, address quote) external view returns (OracleTypes.Price memory);
    function getAPY(bytes32 marketId) external view returns (OracleTypes.YieldRate memory);
}
