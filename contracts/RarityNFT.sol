// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract RarityNFT is
    ERC721,
    ERC721Enumerable,
    ERC721URIStorage,
    ERC721Burnable,
    Ownable,
    ReentrancyGuard
{
    using Counters for Counters.Counter;
    using Strings for uint256;

    string public baseUri;
    address payable public manager;

    Counters.Counter private _tokenIds;

    mapping(uint256 => string) public avatarName;
    mapping(string => uint256) public idByName;

    constructor()
        ERC721("AVATAR-BKWZ", "AVATAR")
    {
        manager = payable(msg.sender);
    }

    function _baseURI() internal view override returns (string memory) {
        return baseUri;
    }

    function mint(uint256 _head, uint256 _body, uint256 _leg) public returns (uint256) {
        string memory newName = generateAvatarName(_head, _body, _leg);
        require(idByName[newName] == 0, "this Rarity nft is already minted");
        _tokenIds.increment();

        uint256 newNftId = _tokenIds.current();
        _safeMint(msg.sender, newNftId);

        // set avatar details
        avatarName[newNftId] = newName;

        _setTokenURI(newNftId, string(abi.encodePacked(avatarName[newNftId], ".json")));

        idByName[newName] = newNftId;

        return newNftId;
    }

    function generateAvatarName(uint256 _head, uint256 _body, uint256 _leg) public pure returns (string memory) {
        return string(abi.encodePacked(_head.toString(), _body.toString(), _leg.toString()));
    }

    function ownedAvatars(address purchaser)
        external
        view
        returns (string[] memory)
    {
        uint256 balance = super.balanceOf(purchaser);
        string[] memory avatars = new string[](balance);
        for (uint256 i = 0; i < balance; i++) {
            avatars[i] = avatarName[tokenOfOwnerByIndex(purchaser, i)];
        }
        return avatars;
    }

    function getAvatarName(uint256 id)
        external
        view
        returns (string memory)
    {
        return avatarName[id];
    }

    function getAllAvatarNames() public view returns (string[] memory) {
        string[] memory avatarNames = new string[](totalSupply());
        for (uint256 i; i < totalSupply(); i ++) {
            avatarNames[i] = avatarName[i + 1];
        }

        return avatarNames;
    }

    // Function to withdraw all AVAX from this contract.
    function withdraw() public nonReentrant {
        // get the amount of AVAX stored in this contract
        require(msg.sender == manager, "only manager can call withdraw");
        uint256 amount = address(this).balance;

        // send all AVAX to manager
        // manager can receive AVAX since the address of manager is payable
        (bool success, ) = manager.call{value: amount}("");
        require(success, "Failed to send AVAX");
    }
    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function _burn(uint256 tokenId)
        internal
        override(ERC721, ERC721URIStorage)
    {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return bytes(_baseURI()).length > 0 ? string(abi.encodePacked(_baseURI(), avatarName[tokenId], ".json")) : "";
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
