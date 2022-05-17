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

    constructor(string memory _baseUri)
        ERC721("Test-NFT", "TNFT")
    {
        baseUri = _baseUri;
    }

    function _baseURI() internal view override returns (string memory) {
        return baseUri;
    }

    function mint() public returns (uint256) {
        _tokenIds.increment();

        uint256 newNftId = _tokenIds.current();
        _safeMint(msg.sender, newNftId);

        return newNftId;
    }

    function generateAvatarName(uint256 _head, uint256 _body, uint256 _leg) public pure returns (string memory) {
        return string(abi.encodePacked(_head.toString(), _body.toString(), _leg.toString()));
    }

    // owner functions

    function setBaseURI(string memory _baseUri) public onlyOwner {
        baseUri = _baseUri;
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
        return bytes(_baseURI()).length > 0 ? string(abi.encodePacked(_baseURI(), tokenId.toString(), ".json")) : "";
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
