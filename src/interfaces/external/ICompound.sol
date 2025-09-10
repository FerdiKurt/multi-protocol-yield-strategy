// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

interface ICToken {
    function mint(uint256 mintAmount) external returns (uint256);
    function redeem(uint256 redeemTokens) external returns (uint256);
    function redeemUnderlying(uint256 redeemAmount) external returns (uint256);
    function exchangeRateStored() external view returns (uint256);
    function balanceOf(address) external view returns (uint256);
    function underlying() external view returns (address);
}
