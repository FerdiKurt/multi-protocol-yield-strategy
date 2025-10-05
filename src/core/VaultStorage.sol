// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {PausableAuth} from "../utils/PausableAuth.sol";
import {Roles} from "./Roles.sol";

/// @notice Holds core config/state for the vault system.
/// @dev No `asset` here (ERC4626 exposes asset()).
abstract contract VaultStorage is PausableAuth {
    // --- Config ---
    address public oracleRouter;    // oracle aggregator/router
    address public riskModule;      // risk params module (future)
    address public treasury;        // fee sink

    // Fees & caps (basis points)
    uint256 public tvlCap;              // 0 => unlimited
    uint256 public depositFeeBps;      
    uint256 public withdrawFeeBps;     
    uint256 public managementFeeBps;   
    uint256 public performanceFeeBps;   

    // --- Events ---
    event ConfigUpdated(address indexed admin, bytes32 indexed what, bytes data);
    event OracleRouterUpdated(address indexed oracle);
    event TVLCapUpdated(uint256 oldCap, uint256 newCap);

    constructor(address _admin, address _treasury) {
        require(_admin != address(0) && _treasury != address(0), "ZERO_ADDRESS");
        _grantRole(Roles.ROLE_ADMIN, _admin);
        _setRoleAdmin(Roles.ROLE_GUARDIAN, Roles.ROLE_ADMIN);
        _setRoleAdmin(Roles.ROLE_STRATEGIST, Roles.ROLE_ADMIN);
        _setRoleAdmin(Roles.ROLE_KEEPER, Roles.ROLE_ADMIN);
        _setRoleAdmin(Roles.ROLE_RISK_MANAGER, Roles.ROLE_ADMIN);

        treasury = _treasury;
    }

    function setOracleRouter(address _router) external onlyRole(Roles.ROLE_ADMIN) {
        require(_router != address(0), "ZERO_ADDRESS");
        oracleRouter = _router;
        emit OracleRouterUpdated(_router);
    }

    function setTVLCap(uint256 _cap) external onlyRole(Roles.ROLE_ADMIN) {
        emit TVLCapUpdated(tvlCap, _cap);
        tvlCap = _cap;
    }
}
