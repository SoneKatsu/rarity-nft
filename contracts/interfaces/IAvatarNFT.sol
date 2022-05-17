// SPDX-License-Identifier: MIT LICENSE

pragma solidity ^0.8.0;

interface IAvatarNFT {
    struct avatarDetail {
        uint256 id;
        uint256 avatarId;
        bool staked;
    }

    function ownedAvatars(address purchaser) external view returns (avatarDetail[] memory);

    function getAvatarDetail(uint256 id) external view returns (avatarDetail memory);

    function stake(uint256 id, bool stakeStatus) external;
}
