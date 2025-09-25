// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {IProtocolAdapter} from "../../interfaces/internal/IProtocolAdapter.sol";

/// @notice Abstract adapter; concrete protocols implement hooks.
/// @dev Keeps interface stable for Vault -> Adapter routing.
abstract contract ProtocolAdapter is IProtocolAdapter {
    bytes32 internal _marketId;

    constructor(bytes32 market_) {
        _marketId = market_;
    }

    function marketId() external view override returns (bytes32) {
        return _marketId;
    }

    function deposit(uint256) external virtual override returns (uint256) {
        revert("NOT_IMPLEMENTED");
    }

    function withdraw(uint256) external virtual override returns (uint256) {
        revert("NOT_IMPLEMENTED");
    }

    function previewDeposit(uint256) external view virtual override returns (uint256) {
        return 0;
    }

    function previewWithdraw(uint256) external view virtual override returns (uint256) {
        return 0;
    }

    function totalAssets() external view virtual override returns (uint256) {
        return 0;
    }
}
