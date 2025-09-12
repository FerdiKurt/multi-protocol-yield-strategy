// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

interface IProtocolAdapter {
    /// @notice A unique identifier (e.g., keccak256("AAVE:USDC")).
    function marketId() external view returns (bytes32);
    function deposit(uint256 amount) external returns (uint256 receivedShares);
    function withdraw(uint256 shares) external returns (uint256 receivedUnderlying);
    function previewDeposit(uint256 amount) external view returns (uint256 expectedShares);
    function previewWithdraw(uint256 shares) external view returns (uint256 expectedUnderlying);
    function totalAssets() external view returns (uint256);
}
