// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/access/AccessControl.sol";

/// @notice Minimal pausability for core/vault contracts.
/// @dev Uses AccessControl.onlyRole directly; no custom onlyRole modifier.
abstract contract PausableAuth is AccessControl {
    bool private _paused;

    event Paused(address indexed by);
    event Unpaused(address indexed by);

    modifier whenNotPaused() {
        require(!_paused, "PAUSED");
        _;
    }

    modifier whenPaused() {
        require(_paused, "NOT_PAUSED");
        _;
    }

    function _pause() internal whenNotPaused {
        _paused = true;
        emit Paused(msg.sender);
    }

    function _unpause() internal whenPaused {
        _paused = false;
        emit Unpaused(msg.sender);
    }

    function paused() public view returns (bool) {
        return _paused;
    }
}
