// SPDX-License-Identifier: MIT
// Creator: Chiru Labs

pragma solidity ^0.8.11;

import './ERC721A.sol';
import './extensions/ERC721AQueryable.sol';
import "@openzeppelin/contracts/access/Ownable.sol";

contract WaveFaceA is ERC721A, ERC721AQueryable, Ownable {
    using Strings for uint256;

    string public baseUri;

    constructor(string memory _baseUri)
        ERC721A("WaveFace", "WF")
    {
        baseUri = _baseUri;
    }

    function mint(address to, uint256 quantity) public {
        _safeMint(to, quantity);
    }

    function _baseURI() internal view override returns (string memory) {
        return baseUri;
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override
        returns (string memory)
    {
        if (!_exists(tokenId)) revert URIQueryForNonexistentToken();

        string memory baseURI = _baseURI();
        return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : '';
    }

    // owner functions

    function setBaseURI(string memory _baseUri) public onlyOwner {
        baseUri = _baseUri;
    }
}
