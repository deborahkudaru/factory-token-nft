// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.28;

import "./token/Token.sol";
import "./token/MyNFT.sol";

contract Factory {
    // ERC20
    address[] public tokens;
    uint256 public tokenCount;

    // NFT
    address[] public nfts;
    uint256 public nftCount;

    event TokenDeployed(
        address indexed tokenAddress,
        string name,
        string symbol
    );
    event NFTDeployed(address indexed nftAddress, string name, string symbol);

    function deployToken(
        string calldata _name,
        string calldata _symbol,
        uint256 _supply
    ) public returns (address) {
        Token token = new Token(_name, _symbol, _supply);

        address tokenAddress = address(token);

        tokens.push(tokenAddress);

        tokenCount++;

        emit TokenDeployed(tokenAddress, _name, _symbol);

        return tokenAddress;
    }

    function deployNFT(
        string calldata _name,
        string calldata _symbol
    ) public returns (address) {
        MyNFT nft = new MyNFT(_name, _symbol);

        address nftAddress = address(nft);

        nfts.push(nftAddress);

        nftCount++;

        emit NFTDeployed(nftAddress, _name, _symbol);

        return nftAddress;
    }
}
