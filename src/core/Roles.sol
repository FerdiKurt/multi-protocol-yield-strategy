// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @notice Centralized role identifiers (keccak256 namespaces).
library Roles {
    bytes32 constant ROLE_ADMIN         = keccak256("ROLE_ADMIN");
    bytes32 constant ROLE_GUARDIAN      = keccak256("ROLE_GUARDIAN");
    bytes32 constant ROLE_STRATEGIST    = keccak256("ROLE_STRATEGIST");
    bytes32 constant ROLE_KEEPER        = keccak256("ROLE_KEEPER");
    bytes32 constant ROLE_RISK_MANAGER  = keccak256("ROLE_RISK_MANAGER");
}
