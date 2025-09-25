// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

library SafeCastExt {
    function toU128(uint256 x) internal pure returns (uint128) {
        require(x <= type(uint128).max, "CAST_OOB");
        return uint128(x);
    }
}
