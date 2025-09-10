// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

interface IPool {
    function supply(address asset, uint256 amount, address onBehalfOf, uint16 referralCode) external;
    function withdraw(address asset, uint256 amount, address to) external returns (uint256);
}

interface IAToken {
    function balanceOf(address) external view returns (uint256);
    function UNDERLYING_ASSET_ADDRESS() external view returns (address);
}
