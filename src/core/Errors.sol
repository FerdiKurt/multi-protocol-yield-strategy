// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

library Errors {
    string constant UNAUTHORIZED = "UNAUTHORIZED";
    string constant PAUSED = "PAUSED";
    string constant ZERO_ADDRESS = "ZERO_ADDRESS";
    string constant INVALID_PARAM = "INVALID_PARAM";
    string constant ORACLE_STALE = "ORACLE_STALE";
    string constant ADAPTER_FAILURE = "ADAPTER_FAILURE";
    string constant NOT_IMPLEMENTED = "NOT_IMPLEMENTED";
}
