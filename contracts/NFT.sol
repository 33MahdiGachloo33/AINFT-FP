// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract NFT is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    address public owner;
    uint256 public cost;

    constructor(
        string memory _name,
        string memory _symbol,
        uint256 _cost
    ) ERC721(_name, _symbol) {
        owner = msg.sender;
        cost = _cost;
    }

    function mint(string memory tokenURI) public payable {
        require(msg.value >= cost);

        _tokenIds.increment();

        uint256 newItemId = _tokenIds.current();
        _mint(msg.sender, newItemId);
        _setTokenURI(newItemId, tokenURI);
    }

    function totalSupply() public view returns (uint256) {
        return _tokenIds.current();
    }

    function withdraw() public {
        require(msg.sender == owner);
        (bool success, ) = owner.call{value: address(this).balance}("");
        require(success);
    }
    function safeTransferFrom(address _from, address _to, uint256 _tokenId) public payable {
   safeTransferFrom(_from, _to, _tokenId, "");
}

function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes memory _data) public payable {
   require(ownerOf(_tokenId) == msg.sender || _tokenApprovals[_tokenId] == msg.sender || _operatorApprovals[ownerOf(_tokenId)][msg.sender], "!Auth");
   _transfer(_from, _to, _tokenId);
   // trigger func check
   require(_checkOnERC721Received(_from, _to, _tokenId, _data), "!ERC721Implementer");
}
function balanceOf(address _owner) public view returns(uint256) {
   require(_owner != address(0), "!Add0");
   return _balances[_owner];
}

}
