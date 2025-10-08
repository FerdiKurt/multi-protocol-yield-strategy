// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC4626.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

import {VaultStorage} from "./VaultStorage.sol";
import {Roles} from "./Roles.sol";

/// @title VaultCore
/// @notice ERC-4626 compliant vault with pausability, role gating and TVL cap.
/// @dev Fees are configured but not charged. withdraw/redeem allowed while paused.
contract VaultCore is ERC4626, ReentrancyGuard, VaultStorage {
    using SafeERC20 for IERC20;

    /// @param admin The address granted ROLE_ADMIN.
    /// @param asset_ The ERC20 underlying.
    /// @param treasury_ Fee sink address.
    /// @param name_ ERC20 share token name.
    /// @param symbol_ ERC20 share token symbol.
    constructor(
        address admin,
        IERC20 asset_,
        address treasury_,
        string memory name_,
        string memory symbol_
    ) ERC20(name_, symbol_) ERC4626(asset_) VaultStorage(admin, treasury_) {
        if (address(asset_) == address(0) || treasury_ == address(0)) revert("ZERO_ADDRESS");
    }

    // ----------------------------
    // Admin / Guardian controls
    // ----------------------------

    function pause() external onlyRole(Roles.ROLE_GUARDIAN) { _pause(); }

    function unpause() external onlyRole(Roles.ROLE_ADMIN) { _unpause(); }

    function setFees(
        uint256 _depositFeeBps,
        uint256 _withdrawFeeBps,
        uint256 _managementFeeBps,
        uint256 _performanceFeeBps
    ) external onlyRole(Roles.ROLE_ADMIN) {
        // Bounds; actual charging comes later.
        if (
            _depositFeeBps > 2000 ||
            _withdrawFeeBps > 2000 ||
            _managementFeeBps > 2000 ||
            _performanceFeeBps > 5000
        ) revert("INVALID_PARAM");

        depositFeeBps    = _depositFeeBps;
        withdrawFeeBps   = _withdrawFeeBps;
        managementFeeBps = _managementFeeBps;
        performanceFeeBps= _performanceFeeBps;

        emit ConfigUpdated(
            msg.sender,
            keccak256("FEES"),
            abi.encode(_depositFeeBps, _withdrawFeeBps, _managementFeeBps, _performanceFeeBps)
        );
    }

    // ----------------------------
    // ERC-4626 overrides (TVL cap + pause)
    // ----------------------------

    /// @notice Deposits are blocked when paused; TVL cap enforced.
    function deposit(uint256 assets, address receiver)
        public
        override
        nonReentrant
        whenNotPaused
        returns (uint256 shares)
    {
        _checkCap(assets);
        shares = super.deposit(assets, receiver);
    }

    /// @notice Mints shares; blocked when paused; TVL cap enforced via asset preview.
    function mint(uint256 shares, address receiver)
        public
        override
        nonReentrant
        whenNotPaused
        returns (uint256 assets)
    {
        assets = previewMint(shares);
        _checkCap(assets);
        assets = super.mint(shares, receiver);
    }

    /// @notice Withdraw remains allowed in pause state for safety.
    function withdraw(uint256 assets, address receiver, address owner)
        public
        override
        nonReentrant
        returns (uint256 shares)
    {
        shares = super.withdraw(assets, receiver, owner);
    }

    /// @notice Redeem remains allowed in pause state for safety.
    function redeem(uint256 shares, address receiver, address owner)
        public
        override
        nonReentrant
        returns (uint256 assets)
    {
        assets = super.redeem(shares, receiver, owner);
    }

    /// @dev Max deposit constrained by TVL cap (0 means unlimited).
    function maxDeposit(address) public view override returns (uint256) {
        if (tvlCap == 0) return type(uint256).max;
        uint256 ta = totalAssets();
        return ta >= tvlCap ? 0 : tvlCap - ta;
    }

    /// @dev Max mint derived from maxDeposit via conversion.
    function maxMint(address owner) public view override returns (uint256) {
        uint256 md = maxDeposit(owner);
        return convertToShares(md);
    }

    function _checkCap(uint256 assets) internal view {
        if (tvlCap == 0) return;
        uint256 ta = totalAssets();
        if (ta + assets > tvlCap) revert("TVL_CAP");
    }
}
