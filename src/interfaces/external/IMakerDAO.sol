// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @dev Minimal stubs; expanded in Week 7.
interface IVatLike {
    function hope(address) external;
    function dai(address) external view returns (uint256);
}
interface IJugLike { function drip(bytes32 ilk) external returns (uint256); }
interface IGemJoinLike { function join(address, uint256) external; function exit(address, uint256) external; }
